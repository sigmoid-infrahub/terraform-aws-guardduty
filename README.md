# Module: GuardDuty

This module enables and configures Amazon GuardDuty for intelligent threat detection.

## Features
- Enable GuardDuty Detector
- Configure data sources (S3, Malware Protection, Kubernetes, etc.)
- Finding publishing frequency management
- Publishing destination (S3) configuration
- Filter criteria and IP sets support
- Threat intel sets integration
- Auto-enable for organization members

## Usage
```hcl
module "guardduty" {
  source = "../../terraform-modules/terraform-aws-guardduty"

  enable = true
}
```

## Inputs
| Name | Type | Default | Description |
|------|------|---------|-------------|
| `enable` | `bool` | `true` | Enable GuardDuty |
| `finding_publishing_frequency` | `string` | `"SIX_HOURS"` | Finding publishing frequency |
| `datasources` | `any` | `null` | Datasources configuration |
| `publishing_destination` | `any` | `null` | Publishing destination configuration |
| `filter_criteria` | `list(any)` | `[]` | Filter criteria list |
| `ipset` | `any` | `null` | IP set configuration |
| `threatintelset` | `any` | `null` | Threat intel set configuration |
| `auto_enable_organization_members` | `string` | `null` | Auto-enable organization members |
| `tags` | `map(string)` | `{}` | Tags to apply |

## Outputs
| Name | Description |
|------|-------------|
| `detector_id` | GuardDuty detector ID |
| `module` | Full module outputs |

## Environment Variables
None

## Notes
- `finding_publishing_frequency` can be one of: `FIFTEEN_MINUTES`, `ONE_HOUR`, `SIX_HOURS`.
- S3 publishing destination requires additional setup for the bucket policy and KMS key.
