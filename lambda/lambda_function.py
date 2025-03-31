import boto3
import json

dynamodb_client = boto3.client('dynamodb')

def lambda_handler(event):
  body = json.loads(event.body)

  dynamodb_client.put_item(
    TableName='serverless_api_table',
    Item={
      'id': {
        'S': body.get('id')
      },
      'name': {
        'S': body.get('name')
      }
    }
  )

  return {
    'statusCode': 2200,
    'body': json.dumps({ 'message': 'Item added successfully!' })
  }