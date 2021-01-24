terraform {
    backend "s3" {
        bucket = "tf-planner"
        key = "terraform/state"
        region = "eu-west-1"
        dynamodb_table = "tf-planner-state"
    }
}