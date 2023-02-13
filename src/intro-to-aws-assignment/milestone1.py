import json
import requests
import boto3
from botocore.exceptions import ClientError
from requests_aws4auth import AWS4Auth

host = ""
region = 'us-east-1'
service = ''
credentials = boto3.Session().get_credentials()
awsauth = AWS4Auth(credentials.access_key, credentials.secret_key, region, service)

s3_client = boto3.client('s3')

try:
    response = s3_client.upload_file('itachi.jpg', 'tu-feb-23-minaghebrial-intro2aws', 'images/{}'.format("mina"))
except ClientError as e:
    logging.error(e)
