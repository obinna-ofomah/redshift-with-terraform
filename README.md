# Terraform AWS Redshift Infrastructure

This Terraform configuration sets up the required AWS resources to deploy an Amazon Redshift cluster, including VPC, networking, IAM roles, and the Redshift cluster itself.

## 🚀 Resources Created

### VPC

```hcl
resource "aws_vpc" "obinna-redshift-vpc" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name        = "obinna_redshift_vpc"
    Environment = "development team"
  }
}
