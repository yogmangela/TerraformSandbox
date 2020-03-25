provider "aws" {
  region="eu-west-1"
}
output "s3" {
  value = aws_s3_bucket.terraform_state.bucket
}

output "DynamoDB" {
  value = aws_dynamodb_table.terraform_locks.name
}

output "s3_bucke_arn" {
  value = aws_s3_bucket.terraform_state.arn
}

resource "aws_s3_bucket" "terraform_state" {
  bucket="terra-up-running-state"

    #preventing accidental deletin of s3 bucket

    lifecycle{
        prevent_destroy=true
    }

#enable versioning to see full revision history of state file

    versioning{
        enabled=true
    }

    #enable server-side encryption by default
    server_side_encryption_configuration{
        rule{
            apply_server_side_encryption_by_default{
                sse_algorithm="AES256"
            }
        }
    }

}


#DynamoDB for locking with Terrafor LockID

resource "aws_dynamodb_table" "terraform_locks" {
  name="terra-lock"
  billing_mode="PAY_PER_REQUEST"
  hash_key="LockID"

  attribute{
      name="LockID"
      type="S"
  }
}
