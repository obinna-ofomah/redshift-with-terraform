terraform {
  backend "s3" {
    bucket = "obinna-terraform-state"
    key    = "dev_team/dev_team.tfstate"
    region = "eu-west-2"
  }
}