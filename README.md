# AWS Cloudfront Logs to Dynatrace

This sample demonstrates how to send AWS CloudFront logs to Dynatrace.

- Dynatrace API URL is placed in the `dynatrace_url` variable
- Dynatrace token is placed in a AWS Secret Manager secret (secret key: api_key, secret value: your token)
  more information
  [here](https://docs.dynatrace.com/docs/shortlink/lma-stream-logs-with-firehose#prerequisites)
- KMS encryption is optional

## Architecture diagram

![infra-diagrams](./docs/architecture/terraform-aws-cloudfront-logs-to-dynatrace.png)

<!-- BEGIN_TF_DOCS -->

### Requirements

| Name                                                                     | Version  |
| ------------------------------------------------------------------------ | -------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 1.6.2 |
| <a name="requirement_archive"></a> [archive](#requirement_archive)       | 2.6.0    |
| <a name="requirement_aws"></a> [aws](#requirement_aws)                   | >=5.59.0 |

### Inputs

| Name                                                                     | Description                            | Type          | Default                                | Required |
| ------------------------------------------------------------------------ | -------------------------------------- | ------------- | -------------------------------------- | :------: |
| <a name="input_app_env"></a> [app_env](#input_app_env)                   | Environment name of the application.   | `string`      | `"test"`                               |    no    |
| <a name="input_app_name"></a> [app_name](#input_app_name)                | Name of the application.               | `string`      | `"demoapp"`                            |    no    |
| <a name="input_app_owner"></a> [app_owner](#input_app_owner)             | Owner of the application.              | `string`      | `"me"`                                 |    no    |
| <a name="input_custom_tags"></a> [custom_tags](#input_custom_tags)       | A map of tags to add to all resources. | `map(string)` | `{}`                                   |    no    |
| <a name="input_dynatrace_url"></a> [dynatrace_url](#input_dynatrace_url) | URL of the Dynatrace endpoint.         | `string`      | `"https://*******.live.dynatrace.com"` |    no    |

<!-- END_TF_DOCS -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
