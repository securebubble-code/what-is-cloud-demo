import boto3
import time

# Create CloudFront client
cf = boto3.client('cloudfront')

# Enter Original name

DISTRIBUTION_ID = "E1FG0O9DB37S55"

# Create CloudFront invalidation
def create_invalidation():
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

# Create CloudFront Invalidation
invd = create_invalidation()
print(f"Invalidation created successfully with Id: {invd}")