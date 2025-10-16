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

# add permission for lambda to invoke api gateway using "AmazonAPIGatewayInvokeFullAccess" policy
resource "aws_iam_role_policy_attachment" "lambda_apigw_invoke" {
  role       = aws_iam_role.lambda_dynamodb_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonAPIGatewayInvokeFullAccess"
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

#create a API with API Type HTTP API and add integration with lambda function
#aws region of lambda is us-west-1 and the lambda function name is WebsiteVisitCounterFunction


resource "aws_apigatewayv2_api" "http_api" {
  name          = "WebsiteVisitCounterAPI"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id             = aws_apigatewayv2_api.http_api.id
  integration_type   = "AWS_PROXY"
  integration_uri    = aws_lambda_function.website_visit_counter.arn
  integration_method = "POST"
  payload_format_version = "2.0"
}

#config the route, method = GET, resource path = /count, and intergration target = WebsiteVisitCounterFunction

resource "aws_apigatewayv2_route" "get_count_route" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "GET /"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

#state let defualt stage
resource "aws_apigatewayv2_stage" "default_stage" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "$default"
  auto_deploy = true
}
