terraform {
  backend "s3" {
    bucket       = "platform-test-terraform-state"
    key          = "dev/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true # Native S3 locking (No DynamoDB needed!)
  }
}
