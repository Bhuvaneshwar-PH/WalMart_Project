-- Create database
CREATE DATABASE IF NOT EXISTS walmartSales;

-- Create table
CREATE TABLE IF NOT EXISTS sales (
    invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10 , 2 ) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6 , 4 ) NOT NULL,
    total DECIMAL(12 , 4 ) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10 , 2 ) NOT NULL,
    gross_margin_pct FLOAT(11 , 9 ),
    gross_income DECIMAL(12 , 4 ),
    rating FLOAT(2 , 1 )
);


SELECT 
    *
FROM
    sales;




SELECT 
    time,
    (CASE
        WHEN `time` BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN `time` BETWEEN '12:00:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END) AS time_of_dates
FROM
    sales;

alter table sales add column time_of_day varchar(20);


-- updating column ------------------------------------------

UPDATE sales 
SET 
    time_of_day = (CASE
        WHEN `time` BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN `time` BETWEEN '12:00:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END);

-- day of the week(sun,mon,tue....)

SELECT 
    date, DAYNAME(date)
FROM
    sales;

alter table sales add column day_name varchar(20);

UPDATE sales 
SET 
    day_name = DAYNAME(date);


SELECT 
    date, MONTHNAME(date)
FROM
    sales;

alter table sales add column month_name varchar(20);


UPDATE sales 
SET 
    month_name = MONTHNAME(date);
    
    
# -----------------------------------------------------------------------------------------------------------

select * from sales;

-- 1) how many distinct cities    

SELECT DISTINCT
    city
FROM
    sales;

-- 2) how many distinct branch

select distinct
	branch
from
sales;

-- ---------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------Products ------------------------------------------------

-- how many unique products line that data have?

select count(distinct
product_line) as count_of_unique_products_line
from sales;


-- what is the most common payment method?

select payment,count(payment)as cnt
from sales
group by payment
order by cnt desc;

-- most selling product_line?

select product_line,count(product_line) as cnt
from sales
group by product_line
order by cnt desc;


-- total revenue by month

select month_name,round(sum(total),2) as total_revenue
from sales
group by month_name
order by total_revenue desc;


-- which month had largest COGS? (cost of goods sales)

select month_name, sum(cogs) as cogs
from sales
group by month_name
order by cogs desc
limit 1;


select * from sales;

-- which city has largest revenue?

select city, round(sum(total),1) as total_revenue
from sales
group by city
order by total_revenue desc
limit 1;

-- what product_line had largest average VAT?

select product_line,
avg(tax_pct) as avg_vat
 from sales
 group by product_line
 order by avg_vat desc;
 
 
 -- which branch sold more products than average production sold?
select branch,sum(quantity) as total_quantity
from sales
group by branch
having sum(quantity) > (select avg(quantity) from sales);
 
-- average rating of each product_line

select product_line,avg(rating) as avg_rating 
from sales
group by product_line;

-- -------------------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------Sales -----------------------------------------------------------------

-- 1) which of customer type brings most revenue?

select customer_type,round(sum(total),2) as tot_revenue from sales
group by customer_type
order by tot_revenue desc;


-- 2) which city has the largest VAT?

select city,avg(tax_pct) as avg_tax from sales
group by city
order by avg_tax desc;

-- 3) which customer type pay most the vat/tax_pct?

select customer_type,round(avg(tax_pct),2) as avg_vat from sales
group by customer_type
order by avg_vat desc;


-- 4) number of sales made in each time of day per Monday?

select 
time_of_day,
count(*) as total_sales
 from sales 
 where day_name='Monday'
 group by time_of_day
order by total_sales desc;


-- ------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------Customer------------------------------------------------

-- 1) how many unique customer type we have?

select distinct customer_type 
from sales;

-- 2) how many unique payment method?

select distinct payment 
from sales;

-- 3) most common customer type?

select customer_type,count(*) as cnt
from sales
group by customer_type
order by cnt desc
limit 1;

-- what is the gender of most of customer?

select gender,count(*) as gender_count
from sales
group by gender
order by gender_count desc;


-- what is gender distribution by branch C?
select gender,count(*) as gender_count
from sales
where branch = 'c'
group by gender
order by gender_count desc;


-- what time of day give most rating?

select time_of_day,count(rating) as avg_rt
from sales
group by time_of_day
order by avg_rt desc;



-- which day of the week has the best rating?

select day_name,avg(rating) as avg_rt
from sales
group by day_name
order by avg_rt desc



