
resource "aws_vpc" "obinna-redshift-vpc" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name        = "obinna_redshift_vpc"
    Environment = "development team"
  }
}

resource "aws_subnet" "obinna-redshift-subnet-1" {
  vpc_id            = aws_vpc.obinna-redshift-vpc.id
  cidr_block        = "10.10.0.1/24"
  availability_zone = "euw2-az1"
}

resource "aws_internet_gateway" "obinna-redshift-igw" {
  vpc_id = aws_vpc.obinna-redshift-vpc.id

}

resource "aws_route_table" "obinna-redshift-rt" {
  vpc_id = aws_vpc.obinna-redshift-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.obinna-redshift-igw.id
  }

}

resource "aws_route_table_association" "redshift-subnet-rt-association-igw-az1" {
  subnet_id      = aws_subnet.obinna-redshift-subnet-1.id
  route_table_id = aws_route_table.obinna-redshift-rt.id
}

resource "aws_iam_role" "obinna-redshift-role" {
  name = "redshift_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "redshift.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_redshift_cluster" "obinna_redshift" {
  cluster_identifier = "obinna-redshift-cluster"
  database_name      = "payments_dw"
  master_username    = "obinna_20"
  node_type          = "dc1.large"
  cluster_type       = "multi-node"
  number_of_nodes    = 3


  manage_master_password = true
}

resource "aws_redshift_cluster_iam_roles" "redshift_iam-role" {
  cluster_identifier = aws_redshift_cluster.obinna_redshift.id
  iam_role_arns      = [aws_iam_role.obinna-redshift-role.arn]
}