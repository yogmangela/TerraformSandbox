terraform{
    backend "s3"{
            bucket="terra-up-running-state"
            key= "global/s3/terraform.tfstate"
            region= "eu-west-1"

            #DynamoDB
            dynamodb_table="terra-lock"
            encrypt=true
    }
}