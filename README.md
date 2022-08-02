# SES Domain Identity Terraform Module

Manage an [SES domain identity] using Terraform.

Major features:

* Creates an SNS topic for bounces and complaints
* Validates the domain identity using Route 53 record sets
* Adds DKIM validates using Route 53 record sets
* Includes optional [delegated authorized sending] to other AWS accounts

[SES domain identity]: https://docs.aws.amazon.com/ses/latest/dg/creating-identities.html#verify-domain-procedure
[delegated authorized sending]: https://docs.aws.amazon.com/ses/latest/dg/sending-authorization.html

## Example

```
module "domain_identity" {
  source = "git@github.com:thoughtbot/terraform-ses-domain-identity.git?ref=v0.4.0"

  domain = "example.com"

  # Set to false if you want to manually validate DNS and set up DKIM
  create_records = true

  # Optional; other AWS accounts which should be allowed to use this identity
  authorized_accounts = ["123456789083", "234567890834"]
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws.identity"></a> [aws.identity](#provider\_aws.identity) | ~> 4.0 |
| <a name="provider_aws.route53"></a> [aws.route53](#provider\_aws.route53) | ~> 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_route53_record.dkim](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.domain_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_ses_domain_dkim.mail](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_domain_dkim) | resource |
| [aws_ses_domain_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_domain_identity) | resource |
| [aws_ses_domain_identity_verification.mail](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_domain_identity_verification) | resource |
| [aws_ses_identity_notification_topic.bounce](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_identity_notification_topic) | resource |
| [aws_ses_identity_notification_topic.complaint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_identity_notification_topic) | resource |
| [aws_ses_identity_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_identity_policy) | resource |
| [aws_sns_topic.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_route53_zone.domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_authorized_accounts"></a> [authorized\_accounts](#input\_authorized\_accounts) | Other AWS account IDs authorized to use this domain identity | `list(string)` | `[]` | no |
| <a name="input_create_records"></a> [create\_records](#input\_create\_records) | Set to false to disable Route 53 record creation | `bool` | `true` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | The domain from which emails are sent | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace to prefix resource | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags which should be applied to created resources | `map(string)` | `{}` | no |
| <a name="input_zone_domain"></a> [zone\_domain](#input\_zone\_domain) | Name of the AWS Route53; defaults to domain identity | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the created domain identity |
| <a name="output_notifications_topic_arn"></a> [notifications\_topic\_arn](#output\_notifications\_topic\_arn) | ARN of the SNS topic created for complaints and bounces |
<!-- END_TF_DOCS -->

## Contributing

Please see [CONTRIBUTING.md](./CONTRIBUTING.md).

## License

These modules are Copyright © 2021 Joe Ferris and thoughtbot. It is free
software, and may be redistributed under the terms specified in the [LICENSE]
file.

[LICENSE]: ./LICENSE

About thoughtbot
----------------

![thoughtbot](https://thoughtbot.com/brand_assets/93:44.svg)

These modules are maintained and funded by thoughtbot, inc. The names and logos
for thoughtbot are trademarks of thoughtbot, inc.

We love open source software! See [our other projects][community] or [hire
us][hire] to design, develop, and grow your product.

[community]: https://thoughtbot.com/community?utm_source=github
[hire]: https://thoughtbot.com/hire-us?utm_source=github
