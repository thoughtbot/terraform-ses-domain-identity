resource "aws_ses_domain_identity" "this" {
  provider = aws.identity

  domain = var.domain
}

resource "aws_ses_identity_policy" "this" {
  count    = length(var.authorized_accounts) == 0 ? 0 : 1
  provider = aws.identity

  identity = aws_ses_domain_identity.this.arn
  name     = "${local.name}-delegated-senders"
  policy   = data.aws_iam_policy_document.this.json
}

resource "aws_route53_record" "domain_identity" {
  provider = aws.route53
  for_each = data.aws_route53_zone.domain

  name    = "_amazonses.${var.domain}"
  records = [aws_ses_domain_identity.this.verification_token]
  ttl     = 3600
  type    = "TXT"
  zone_id = each.value.zone_id
}

resource "aws_route53_record" "dkim" {
  count    = var.create_records ? 3 : 0
  provider = aws.route53

  ttl     = 3600
  type    = "CNAME"
  zone_id = data.aws_route53_zone.domain[local.zone_domain].zone_id

  name = join(
    ".",
    [
      element(aws_ses_domain_dkim.mail.dkim_tokens, count.index),
      "_domainkey",
      var.domain
    ]
  )

  records = [
    join(
      ".",
      [
        element(aws_ses_domain_dkim.mail.dkim_tokens, count.index),
        "dkim.amazonses.com"
      ]
    )
  ]
}

resource "aws_ses_domain_identity_verification" "mail" {
  count    = var.create_records ? 1 : 0
  provider = aws.identity

  domain = aws_ses_domain_identity.this.id
}

resource "aws_ses_domain_dkim" "mail" {
  domain   = aws_ses_domain_identity.this.domain
  provider = aws.identity
}

resource "aws_ses_identity_notification_topic" "bounce" {
  provider = aws.identity

  topic_arn         = aws_sns_topic.this.arn
  notification_type = "Bounce"
  identity          = aws_ses_domain_identity.this.domain
}

resource "aws_ses_identity_notification_topic" "complaint" {
  provider = aws.identity

  topic_arn         = aws_sns_topic.this.arn
  notification_type = "Complaint"
  identity          = aws_ses_domain_identity.this.domain
}

resource "aws_sns_topic" "this" {
  provider = aws.identity

  name = "${local.name}-notifications"
  tags = var.tags
}

data "aws_iam_policy_document" "this" {
  provider = aws.identity

  statement {
    actions   = ["SES:SendEmail", "SES:SendRawEmail"]
    resources = [aws_ses_domain_identity.this.arn]

    principals {
      identifiers = var.authorized_accounts
      type        = "AWS"
    }
  }
}

data "aws_route53_zone" "domain" {
  for_each = var.create_records ? toset([local.zone_domain]) : []
  provider = aws.route53

  name = each.value
}

locals {
  name        = join("-", concat(var.namespace, split(".", var.domain)))
  zone_domain = coalesce(var.zone_domain, var.domain)
}
