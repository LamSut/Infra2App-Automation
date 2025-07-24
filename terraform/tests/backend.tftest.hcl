#################
### Variables ###
#################

variables {
  bucket         = "b2111933-store"
  key            = "b2111933-state"
  region         = "ap-southeast-1"
  dynamodb_table = "b2111933-lock"
}


#########################
### Terraform Backend ###
#########################

run "region_test" {
  command = plan

  assert {
    condition     = var.region == "ap-southeast-1"
    error_message = "Incorrect AWS region specified for the Terraform backend of the thesis project!"
  }
}

run "state_test" {
  command = plan

  assert {
    condition     = var.bucket == "b2111933-store"
    error_message = "Incorrect S3 bucket selected for storing Terraform state in the thesis project!"
  }

  assert {
    condition     = var.key == "b2111933-state"
    error_message = "Incorrect state file key specified for the Terraform backend of the thesis project!"
  }
}

run "state_lock_test" {
  command = plan

  assert {
    condition     = var.dynamodb_table == "b2111933-lock"
    error_message = "Incorrect DynamoDB table selected for state locking in the Terraform backend of the thesis project!"
  }
}
