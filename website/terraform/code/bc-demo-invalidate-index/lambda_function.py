import boto3
import os
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
def create_invalidation():
    # Create CloudFront client
    cf = boto3.client('cloudfront')
    DISTRIBUTION_ID = os.environ.get('dist_id')
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
    # Create CloudFront Invalidation
    invd = create_invalidation()
    message = f"Invalidation response: {invd}"
    print(message)
    return return_func(status_code=200,message=message)
    