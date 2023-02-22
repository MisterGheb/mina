import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

df = pd.read_csv('ohlcv.csv')
df['day'] = pd.to_datetime(df['day'])
x = [1, 2, 3, 4, 5, 6]
df.set_index('day', inplace=True)

df['daily_change'] = df['close'].diff()

plt.plot(df.index, df['daily_change'])
plt.xticks(df.index, x)



plt.title('Daily Change in Closing Prices')
plt.xlabel('Date',)
plt.ylabel('Price Change')

plt.savefig('milestone3.png')