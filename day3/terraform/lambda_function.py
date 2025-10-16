# lambda function to count number of visits of a webiste, the current date get from a dynamodb table, then increment the count and update the table
import json
import boto3
from botocore.exceptions import ClientError
from datetime import datetime


def lambda_handler(event, context):
    current_date = datetime.now().strftime("%Y-%m-%d")

    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('WebsiteVisits')

    try:
        date_key = {'VisitID': 'DATE', 'VisitDate': current_date}
        resp = table.update_item(
            Key=date_key,
            UpdateExpression='SET VisitCount = if_not_exists(VisitCount, :zero) + :inc',
            ExpressionAttributeValues={':zero': 0, ':inc': 1},
            ReturnValues='UPDATED_NEW'
        )
        

        total_key = {'VisitID': 'TOTAL', 'VisitDate': 'TOTAL'}
        total_resp = table.update_item(
            Key=total_key,
            UpdateExpression='SET VisitCount = if_not_exists(VisitCount, :zero) + :inc',
            ExpressionAttributeValues={':zero': 0, ':inc': 1},
            ReturnValues='UPDATED_NEW'
        )
        total_visit_count = int(total_resp['Attributes']['VisitCount'])

        return {
            'statusCode': 200,
            'body': json.dumps({
                'statusCode': 200,
                'total_visits': total_visit_count
            })
        }

    except ClientError as e:
        return {
            'statusCode': 500,
            'body': json.dumps(f'Error accessing DynamoDB: {e.response["Error"]["Message"]}')
        }
