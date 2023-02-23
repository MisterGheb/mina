import matplotlib.pyplot as plt
import datetime
import yfinance as yf
symbols = ["AAPL", "MSFT", "GOOG", "AMZN", "TSLA", "NVDA", "JPM", "V", "JNJ", "BAC"]

end_date = datetime.datetime.today()
start_date = end_date - datetime.timedelta(days=365)

dataframes = []

for ticker in symbols:
    df = yf.download(ticker, start=start_date, end=end_date)
    df["Symbol"] = ticker
    dataframes.append(df)

