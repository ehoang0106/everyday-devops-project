resource "aws_dynamodb_table" "WebsiteVisits" {
  name = "WebsiteVisits"
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "VisitID"
  range_key = "VisitDate"

  attribute {
    name = "VisitID"
    type = "S"
  }

  attribute {
    name = "VisitDate"
    type = "S"
  }

}

