# AWS Cloudfront Logs to Dynatrace

TO DO

## Architecture diagram

![infra-diagrams](./docs/architecture/terraform-aws-cloudfront-logs-to-dynatrace.png)

<!-- BEGIN_TF_DOCS -->


### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.2 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | 2.6.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=5.59.0 |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_env"></a> [app\_env](#input\_app\_env) | Environment name of the application. | `string` | `"test"` | no |
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | Name of the application. | `string` | `"demoapp"` | no |
| <a name="input_app_owner"></a> [app\_owner](#input\_app\_owner) | Owner of the application. | `string` | `"me"` | no |
| <a name="input_custom_tags"></a> [custom\_tags](#input\_custom\_tags) | A map of tags to add to all resources. | `map(string)` | `{}` | no |
| <a name="input_dynatrace_url"></a> [dynatrace\_url](#input\_dynatrace\_url) | URL of the Dynatrace endpoint. | `string` | `"https://*******.live.dynatrace.com"` | no |

<!-- END_TF_DOCS -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
README.md updated successfully
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
