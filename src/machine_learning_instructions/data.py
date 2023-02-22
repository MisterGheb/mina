import json

# with json load  (file)
with open('chart.json', 'r') as f:
    res = json.load(f)

data = [d['z'] for d in res['data']['chart']]

csvContent = 'day,open,high,low,close,volume'

for row in data:
    csvContent += ','.join([row['dateTime'], row['open'], row['high'], row['low'], row['close'], row['volume']]) + '\n'

with open("ohlcv.csv", "w") as output_file:
    output_file.write(csvContent)

