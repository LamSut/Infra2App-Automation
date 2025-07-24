terraform {
  backend "s3" {
    bucket         = "b2111933-store"
    key            = "b2111933-state"
    region         = "ap-southeast-1"
    dynamodb_table = "b2111933-lock"
  }
}
