#create a dynamodb

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

#create a customer policy to allow lambda to access dynamodb table to scan, read, write, put, update

resource "aws_iam_policy" "lambda_dynamodb_policy" {
  name = "allow_lambda_access_dynamodb"
  description = "Policy to allow Lambda function to access DynamoDB table in any region and any account"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:Scan",
          "dynamodb:Query",
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

#create a role for lambda to assusme and attach the above policy to plus the AWSLambdaBasicExecutionRole

resource "aws_iam_role" "lambda_dynamodb_role" {
  name = "CustomLambdaDynamoDBRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_dynamodb_policy_attachment" {
  role       = aws_iam_role.lambda_dynamodb_role.name
  policy_arn = aws_iam_policy.lambda_dynamodb_policy.arn
}
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_dynamodb_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}




#create a lambda function by using the file lambda_function.py

#but first need to zip the file
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda_function.py"
  output_path = "${path.module}/lambda_function.zip"
}

#create the lambda function but wait for the zip file to be created

resource "aws_lambda_function" "website_visit_counter" {
  function_name = "WebsiteVisitCounter"
  role          = aws_iam_role.lambda_dynamodb_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  filename      = "${path.module}/lambda_function.zip"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.WebsiteVisits.name
    }
  }
  #wait for the zip file to be created
  depends_on = [data.archive_file.lambda_zip]
}

