terraform {
  backend "s3" {
    bucket         = "technion-final-project"
    key            = "backend/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
