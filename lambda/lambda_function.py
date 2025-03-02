def lambda_handler(event, context):
    return {"message": "Lambda funcionando correctamente"}
import json

def lambda_handler(event, context):
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }