import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

df = pd.read_csv('ohlcv.csv')
df['day'] = pd.to_datetime(df['day']).dt.strftime('%d\n%m')

df.set_index('day', inplace=True)

df['daily_change'] = df['close']
plt.xticks(np.arange(0, len(df.index), step=5) ,rotation ='vertical')
plt.plot(df.index, df['daily_change'])

plt.title('Daily Closing Price')
plt.xlabel('Date')
plt.ylabel('Price')

plt.savefig('milestone2.png')