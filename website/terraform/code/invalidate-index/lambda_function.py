import boto3
import time
import json

def return_func(status_code=200, message="cf_invalidation success", headers=None, isBase64Encoded=False):
    if headers is None:
        headers = {"Content-Type": "application/json"}
    return {
        "statusCode": status_code,
        "headers": headers,
        "body": json.dumps({"message": message}),
        "isBase64Encoded": isBase64Encoded,
    }


# Create CloudFront invalidation
def create_invalidation(DISTRIBUTION_ID):
    # Create CloudFront client
    cf = boto3.client('cloudfront')

    # Enter Original name
    res = cf.create_invalidation(
    DistributionId=DISTRIBUTION_ID,
    InvalidationBatch={
        'Paths': {
        'Quantity': 1,
        'Items': [
            '/index.html'
        ]
        },
        'CallerReference': str(time.time()).replace(".", "")
    }
    )
    return res['Invalidation']['Id']


def lambda_handler(event, context):
    print(event)
    dist_id = event['dist_id']

    # Create CloudFront Invalidation
    invd = create_invalidation(dist_id)
    message = f"Invalidation response: {invd}"
    print(message)
    return return_func(status_code=200,message=message)
    