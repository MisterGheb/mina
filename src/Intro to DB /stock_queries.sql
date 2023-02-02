-- 1. Here I have created a query that returns the total_volume of a traded stock "Facebook" on a given date "02/02/2023" 
SELECT SUM(volume) as total_volume
FROM stocks
WHERE stock_name = "Facebook" AND date="20230202"

-- 2. This SQL query takes a persons sell trades as a profit and buy trades as a loss and sums the total to give the net profit_loss on a given date

SELECT SUM(CASE WHEN transaction_type = "sell" THEN total WHEN transaction_type = "buy" THEN -total  END) as "profit_loss"
FROM stocks
GROUP BY date = "date"

--3. This is an SQL query that takes stock_id, stock price and date from a stocks table and calculates the average price of each stock at the end of a month
-- it then uses that information to calculate the percentage growth of that stock and returns a limit of 5 stocks

WITH monthly_stock AS(
SELECT
    stock_id, date_trunc("month",'2023-01') AS current_month, date_trunc("month",'2022-12') AS previous_month, avg(stock_price) as price
From stocks
GROUP BY stock_id, month
)

SELECT
    stock_id, (current_month-previous_month OVER (PARTITION BY stock_id ORDER BY current_month))/(previous_month OVER (PARTITION BY stock_id ORDER BY current_month))*100 
    AS growth_percentage
FROM monthly_stock
ORDER BY growth_percentage
LIMIT 5

--4. This is an SQL query that calcualtes the average buying prices for given stock

SELECT user_id,stock_id,AVG(buy_price) as avg_buy_price
FROM holdings
WHERE stock_id="123"

--5. This is an SQL query that first has a query that gets the current price of a stock on todays date and then calculates you profit or loss 
-- by multiplying the number of shares a user has in the portfolio

WITH current_prices AS (

    SELECT stock_id, MAX(date) as today, AVG(close) as stock_price
    FROM stocks
    GROUP BY stock_id
)

SELECT
    holdings.user_id
    holdings.stock_id, (current_prices.stock_price- holdings.buy_price) * holdings.shares AS profit_loss
    FROM holdings
    JOIN stock_price
    ON holdings.stock_id = current_prices.stock_id AND holdings.purchase_date = current_prices.today