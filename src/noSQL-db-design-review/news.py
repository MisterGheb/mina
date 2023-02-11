import json
import requests
import boto3
from requests_aws4auth import AWS4Auth


host = "https://vpc-ti-shared-e2wxgh4hpjqlvfgbqe472c4maa.us-east-1.es.amazonaws.com/"
region = 'us-east-1'
service = 'es'
credentials = boto3.Session().get_credentials()
awsauth = AWS4Auth(credentials.access_key, credentials.secret_key, region, service)

path = 'tu-fe1e0e/_bulk/' # the OpenSearch API endpoint
url = host + path

api_token = '94cad95fd9ba4dd8bb41e11ca008e74b'
headers = {'X-Api-Key': api_token, 'Content-Type': 'application/json'}

search_queries = ['stocks', 'tesla', 'apple', 'microsoft', 'amazon', 'nike', 'google', 'meta', 'nvidia', 'pfizer']

print('Begining to fetch articles...')

all_articles = []

for q in search_queries: # limiting to 12 requests
    response = requests.get('https://newsapi.org/v2/everything', 
        headers=headers, 
        params={'q': q}
    )
    data = response.json()
    all_articles += data['articles']


print(f'Successfully fetched {len(all_articles)} articles!')

print(f'Pushing them into elasticsearch...')

payload = ''

for i, article in enumerate(all_articles):
    payload += json.dumps({ "index": { "_id": i+1 } }) + '\n' + json.dumps(article) + '\n'

r = requests.post(url, auth=awsauth, data=payload, headers={"Content-Type": "application/json"})

print(r.status_code)
print(r.text)