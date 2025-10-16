import json
import boto3
from botocore.exceptions import ClientError
from datetime import datetime
from boto3.dynamodb.conditions import Key

def lambda_handler(event, context):
    current_date = datetime.now().strftime("%Y-%m-%d")

    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('WebsiteVisits')

    try:
        #increment today's count
        date_key = {'VisitID': 'DATE', 'VisitDate': current_date}
        table.update_item(
            Key=date_key,
            UpdateExpression='SET VisitCount = if_not_exists(VisitCount, :zero) + :inc',
            ExpressionAttributeValues={':zero': 0, ':inc': 1},
            ReturnValues='UPDATED_NEW'
        )

        #query all date entries and sum VisitCount to compute the true total
        q = table.query(
            KeyConditionExpression=Key('VisitID').eq('DATE'),
            ProjectionExpression='VisitCount'
        )
        items = q.get('Items', [])
        total_sum = sum(int(item.get('VisitCount', 0)) for item in items)

        #write the computed total into the TOTAL item
        total_key = {'VisitID': 'TOTAL', 'VisitDate': 'TOTAL'}
        table.update_item(
            Key=total_key,
            UpdateExpression='SET VisitCount = :total',
            ExpressionAttributeValues={':total': total_sum}
        )

        return {
            'statusCode': 200,
            'body': json.dumps({
                'statusCode': 200,
                'total_visits': total_sum
            })
        }

    except ClientError as e:
        return {
            'statusCode': 500,
            'body': json.dumps(f'Error accessing DynamoDB: {e.response["Error"]["Message"]}')
        }