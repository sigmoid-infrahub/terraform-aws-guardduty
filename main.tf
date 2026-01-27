resource "aws_guardduty_detector" "this" {
  enable = var.enable

  dynamic "datasources" {
    for_each = var.datasources == null ? [] : [var.datasources]
    content {
      dynamic "s3_logs" {
        for_each = lookup(datasources.value, "s3_logs", null) == null ? [] : [datasources.value.s3_logs]
        content {
          enable = s3_logs.value.enable
        }
      }

      dynamic "kubernetes" {
        for_each = lookup(datasources.value, "kubernetes", null) == null ? [] : [datasources.value.kubernetes]
        content {
          dynamic "audit_logs" {
            for_each = lookup(kubernetes.value, "audit_logs", null) == null ? [] : [kubernetes.value.audit_logs]
            content {
              enable = audit_logs.value.enable
            }
          }
        }
      }

      dynamic "malware_protection" {
        for_each = lookup(datasources.value, "malware_protection", null) == null ? [] : [datasources.value.malware_protection]
        content {
          dynamic "scan_ec2_instance_with_findings" {
            for_each = lookup(malware_protection.value, "scan_ec2_instance_with_findings", null) == null ? [] : [malware_protection.value.scan_ec2_instance_with_findings]
            content {
              dynamic "ebs_volumes" {
                for_each = lookup(scan_ec2_instance_with_findings.value, "ebs_volumes", null) == null ? [] : [scan_ec2_instance_with_findings.value.ebs_volumes]
                content {
                  enable = ebs_volumes.value.enable
                }
              }
            }
          }
        }
      }
    }
  }

  tags = local.resolved_tags
}

resource "aws_guardduty_publishing_destination" "this" {
  count = var.publishing_destination == null ? 0 : 1

  detector_id      = aws_guardduty_detector.this.id
  destination_arn  = var.publishing_destination.destination_arn
  kms_key_arn      = var.publishing_destination.kms_key_arn
  destination_type = lookup(var.publishing_destination, "destination_type", "S3")
}

resource "aws_guardduty_filter" "this" {
  for_each = { for idx, entry in var.filter_criteria : entry.name => entry }

  detector_id = aws_guardduty_detector.this.id
  name        = each.value.name
  description = lookup(each.value, "description", null)
  action      = lookup(each.value, "action", "NOOP")
  rank        = lookup(each.value, "rank", 1)

  finding_criteria {
    dynamic "criterion" {
      for_each = lookup(each.value.finding_criteria, "criterion", {})
      content {
        field                 = criterion.key
        equals                = lookup(criterion.value, "equals", null)
        not_equals            = lookup(criterion.value, "not_equals", null)
        greater_than          = lookup(criterion.value, "greater_than", null)
        greater_than_or_equal = lookup(criterion.value, "greater_than_or_equal", null)
        less_than             = lookup(criterion.value, "less_than", null)
        less_than_or_equal    = lookup(criterion.value, "less_than_or_equal", null)
      }
    }
  }
}

resource "aws_guardduty_ipset" "this" {
  count = var.ipset == null ? 0 : 1

  activate    = var.ipset.activate
  detector_id = aws_guardduty_detector.this.id
  format      = var.ipset.format
  location    = var.ipset.location
  name        = var.ipset.name
}

resource "aws_guardduty_threatintelset" "this" {
  count = var.threatintelset == null ? 0 : 1

  activate    = var.threatintelset.activate
  detector_id = aws_guardduty_detector.this.id
  format      = var.threatintelset.format
  location    = var.threatintelset.location
  name        = var.threatintelset.name
}
