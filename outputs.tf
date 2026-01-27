output "detector_id" {
  description = "GuardDuty detector ID"
  value       = aws_guardduty_detector.this.id
}

output "module" {
  description = "Full module outputs"
  value = {
    detector_id               = aws_guardduty_detector.this.id
    publishing_destination_id = try(aws_guardduty_publishing_destination.this[0].id, null)
    ipset_id                  = try(aws_guardduty_ipset.this[0].id, null)
    threatintelset_id         = try(aws_guardduty_threatintelset.this[0].id, null)
  }
}
