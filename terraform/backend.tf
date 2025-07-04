terraform {
  backend "s3" {
    bucket         = "b2111933-bucket"
    key            = "b2111933-state"
    region         = "us-east-1"
    dynamodb_table = "b2111933-table"
  }
}
