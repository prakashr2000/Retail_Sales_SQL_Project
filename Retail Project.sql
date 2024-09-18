--SQL Project For Retail Analysis


CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);

SELECT *
FROM retail_sales;

-- To Find Null Values for single single value
SELECT *
FROM retail_sales
WHERE sale_time is NULL

-- Data cleaning
-- To Find Null Values for all the value
SELECT *
FROM retail_sales
WHERE
		transactions_id is NULL
		OR
		sale_time is NULL
		OR
		sale_date is NULL
		OR
		customer_id is NULL
		OR
		gender is NULL
		OR
		age is NULL
		OR
		category is NULL
		OR
		quantity is NULL
		OR
		price_per_unit is NULL
		OR
		cogs is NULL 
		OR
		total_sale is NULL;


-- Delete NULL values
DELETE FROM retail_sales
WHERE
		transactions_id is NULL
		OR
		sale_time is NULL
		OR
		sale_date is NULL
		OR
		customer_id is NULL
		OR
		gender is NULL
		OR
		age is NULL
		OR
		category is NULL
		OR
		quantity is NULL
		OR
		price_per_unit is NULL
		OR
		cogs is NULL 
		OR
		total_sale is NULL;


SELECT COUNT(*)
FROM retail_sales

-- Data Exploratation
-- how many sales we have
SELECT COUNT(*) as Total_sales
FROM retail_sales

-- how many customers we have
SELECT COUNT(DISTINCT customer_id) as Total_Customer
FROM retail_sales

-- how many category we have
SELECT DISTINCT category as Total_Category
FROM retail_sales

-- 1.Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT COUNT(*)
FROM retail_sales
WHERE sale_date = '2022-11-05'

--2.Write a SQL query to retrieve all transactions where the category is 'Clothing' 
--and the quantity sold is more than 4 in the month of Nov-2022
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
	  AND 
	  quantity >= 4
	  AND 
	  TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	  
	  
--3.Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT category,SUM(total_sale) as Net_sale,COUNT(*) as Total_Orders
FROM retail_sales
GROUP BY category

--4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
SELECT ROUND(AVG (age))
FROM retail_sales
WHERE category = 'Beauty'

--5.Write a SQL query to find all transactions where the total_sale is greater than 1000.:
SELECT *
FROM retail_sales
WHERE total_sale >=1000;

--6.Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
SELECT 
		COUNT(transactions_id),
		gender,
		category
		
FROM retail_sales
GROUP BY gender,category
ORDER BY 3

--7. Write a SQL Query to calculate the average sale for each month find out best selling month in each year

SELECT *
FROM 
(
SELECT 
		EXTRACT(YEAR FROM sale_date)as YEAR, --to seperate year from date
		EXTRACT(MONTH FROM sale_date)as MONTH, --to seperate month from date
		AVG(total_sale),
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale)DESC) AS Rank
FROM retail_sales
GROUP BY 1,2
) AS CTE
WHERE RANK=1

-- ORDER BY 1,3 DESC

--8. Write a query to select top 5 customer based on the total sales
SELECT 
		SUM(total_sale) AS Total,
		customer_id
FROM retail_sales
GROUP BY 2
ORDER BY 1 DESC
LIMIT 5

--9.write a SQL query to find the number of unique customer who purchased item from each category
SELECT 
		category,
		COUNT(DISTINCT customer_id)
FROM retail_sales
GROUP BY 1

--10.Write a SQL Query to create each shift and number of orders 
WITH CTE
AS
(
SELECT *,
		CASE 
		WHEN EXTRACT(HOUR FROM sale_time) <12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
		END as shift
FROM retail_sales
)
SELECT 
		shift,
		COUNT(*)
FROM CTE
GROUP BY shift



