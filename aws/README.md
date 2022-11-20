# Terraform AWS DVWA

This directory contains a Terraform module to deploy DVWA on AWS.


## Usage
```bash
cp terraform.tfvars-example terraform.tfvars
terraform init
terraform plan
terraform apply
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| instance\_type | AWS EC2 instance type to use for DVWA server | string | `"t3.nano"` | no |
| listen\_port | Port for DVWA web interface | string | `"8080"` | no |
| php\_version | PHP version to run DVWA | string | `"8.1"` | no |
| public\_key | SSH public key to add | string | `""` | no |
| tags | Tags to add to all resources | map | `{ "Name": "dvwa" }` | no |
| vpc\_cidr | VPC CIDR | string | `"10.0.0.0/16"` | no |
| vpc\_subnet\_cidr | Subnet CIDR | string | `"10.0.1.0/24"` | no |

## Outputs

| Name | Description |
|------|-------------|
| dvwa\_ssh\_uri | DVWA SSH uri |
| dvwa\_web\_uri | DVWA web interface uri |
| public\_ip | Public IP address of EC2 instance containing DVWA web interface |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
