output "arn" {
  description = "ARN of the created domain identity"
  value       = aws_ses_domain_identity.this.arn
}

output "notifications_topic_arn" {
  description = "ARN of the SNS topic created for complaints and bounces"
  value       = aws_sns_topic.this.arn
}
