-- 1. Here I have created a query that returns the total_volume of a traded stock "Facebook" on a given date "02/02/2023" 
SELECT SUM(volume) as total_volume
FROM dbAssMilestone2_OHLC
WHERE market_id = (SELECT id FROM market_day WHERE date = 'YYYY-MM-DD')
  AND stocks_id = (SELECT id FROM dbAssMilestone2_stocks WHERE name = 'stock_name');

-- 2. This SQL query takes a persons sell trades as a profit and buy trades as a loss and sums the total to give the net profit_loss on a given date

SELECT SUM(CASE WHEN transaction_type = "sell" THEN total WHEN transaction_type = "buy" THEN -total  END) as "profit_loss"
FROM stocks
GROUP BY date = "date"

--3. This is an SQL query that takes stock_id, stock price and date from a stocks table and calculates the average price of each stock at the end of a month
-- it then uses that information to calculate the percentage growth of that stock and returns a limit of 5 stocks

SELECT stocks.name, (price - (LAG(price) OVER (PARTITION BY stocks.name ORDER BY date DESC))) / LAG(price) OVER (PARTITION BY stock_name ORDER BY date DESC) * 100 as percentage_growth
FROM dbAssMilestone2_stock
WHERE date >= DATEADD(month, -1, CURRENT_TIMESTAMP)
GROUP BY stock_name, date, price
ORDER BY percentage_growth DESC
LIMIT 5
--join another table with date and then you can refernce date  USE OHLCV table

--4. This is an SQL query that calcualtes the average buying prices for given stock

SELECT user_id, sum(bid_price*volume)/sum(volume) AS avg_price    --this will help with chalice assignment 
FROM dbAssMilestone2_holdings
GROUP BY user_id;

--use weighted average 

--5. This is an SQL query that first has a query that gets the current price of a stock on todays date and then calculates you profit or loss 
-- by multiplying the number of shares a user has in the portfolio

SELECT 
  users.id,
  SUM(CASE 
    WHEN stocks.price > dbAssMilestone2_holdings.bid_price THEN (stocks.price - dbAssMilestone2_holdings.bid_price) * holdings.volume
    ELSE (holdings.bid_price - stocks.price) * holdings.volume
  END) AS net_profit_loss
FROM 
  dbAssMilestone2_holdings
  JOIN stocks ON dbAssMilestone2_holdings.stocks_id = stocks.id
  JOIN users ON dbAssMilestone2_holdings.user_id = users.id
GROUP BY 
  users.id;