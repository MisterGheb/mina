-- 1. Here I have created a query that returns the total_volume of a traded stock "Facebook" on a given date "02/02/2023" 
SELECT SUM(volume) as total_volume
FROM dbAssMilestone2_OHLC
WHERE market_id = (SELECT id FROM market_day WHERE date = 'YYYY-MM-DD')
  AND stocks_id = (SELECT id FROM dbAssMilestone2_stocks WHERE name = 'stock_name');

-- 2. Net profit/loss made by a user on a given day

SELECT o.stock_id, (o.bid_price - h.avg_bid_price) * o.quantity AS net_profit_loss
FROM orders o
JOIN holdings h ON o.stock_id = h.stock_id AND o.users_id = h.users_id
WHERE o.users_id = 'User_ID' AND o.created_at= NOW()::timestamp

--3. This is an SQL query that takes stock_id, stock price and date from a stocks table and calculates the average price of each stock at the end of a month
-- it then uses that information to calculate the percentage growth of that stock and returns a limit of 5 stocks

SELECT ohlcv.stocks_id, (open - (LAG(open, 30) OVER (PARTITION BY ohlcv.stocks_id ORDER BY day DESC))) / LAG(open, 30) OVER (PARTITION BY ohlcv.stocks_id ORDER BY day DESC) * 100 as percentage_growth
FROM ohlcv
INNER JOIN market_day
ON ohlcv.market_id = market_day.id
WHERE day =61 
ORDER BY percentage_growth DESC
LIMIT 5
--join another table with date and then you can refernce date  USE OHLCV table
-- join the market day to OHLCV

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


-- Top performing stock in a users portfolio in the previous month(percentage growth)
SELECT (O1.close - O2.close)/O2.close *100 AS Percentage_Growth, O1.stocks_id
FROM ohlcv AS O1
JOIN ohlcv AS O2 ON O1.stocks_id = O2.stocks_id
JOIN holdings AS P on O2.stocks_id = P.stocks_id
WHERE O1.created_at = NOW()::timestamp
AND O2.created_at = NOW()::timestamp
ORDER BY Percentage_Growth DESC
LIMIT 1
-- Self join the dbAssMilestone2_OHLCV table on Stock_ID and filter 
-- out the rows where one's date equals today's date and the other's equal the date a month ago,
--  along with an inner join with dbAssMilestone2_Portfolio on the stock ID. This narrows down the results
--   to the stocks present only in the user's portfolio along with their OHLCV data todays and a month ago.The
--    close information is used to calculate the percentage growth. the query is ordered on the percentage growth
--     calculated in descending order and limited to 1 result to find the best performing stock in user's portfolio.

  