import boto3
import csv
import io
import os


boto3.Session(
    aws_access_key_id=os.environ.get('AWS_ACCESS_KEY_ID'),
    aws_secret_access_key=os.environ.get('AWS_SECRET_ACCESS_KEY'),
    aws_session_token=os.environ.get('AWS_SESSION_TOKEN')
)

# set up Kinesis client
kinesis = boto3.client('kinesis', region_name='us-east-1')

# set up S3 client
s3 = boto3.client('s3')

# set up variables for the Kinesis stream and S3 bucket
stream_name = 'mina-tu-feb-23-orders'
bucket_name = 'tu-feb-23-minaghebrial-intro2aws'

# define a function to write orders to S3 bucket
def write_to_s3(records, file_count):
    # create a CSV writer
    output = io.StringIO()
    writer = csv.writer(output)
    # write each record to the CSV file
    writer.writerow(['order_id', 'timestamp', 'order_type'])
    for record in records:
        writer.writerow(record['Data'].split())

    # upload the file to S3 bucket if there are 100 records
    if len(records) == 100:
        s3.put_object(Bucket=bucket_name, Key=f"data-processing-intro/orders{len(records)}.csv", Body=output.getvalue())
        return True
    else:
        return False

# continuously read records from Kinesis stream
shard_iterator = kinesis.get_shard_iterator(StreamName=stream_name, ShardId='shardId-000000000000', ShardIteratorType='LATEST')['ShardIterator']
file_count = 1
file_records = []

while True:
    # get records from Kinesis stream
    response = kinesis.get_records(ShardIterator=shard_iterator, Limit=100)

    # if there are no more records, write the remaining records to S3 and break out of the loop
    if not response['Records']:
        if file_records:
            write_to_s3(file_records, file_count)
        continue

    # add the records to the current file
    file_records.extend(response['Records'])

    # if the current file has 100 records, write it to S3 and start a new file
    if len(file_records) == 100:
        write_to_s3(file_records, file_count)
        file_count += 1
        file_records = []

    # get the next shard iterator
    shard_iterator = response['NextShardIterator']
