select *
from pizza_sales

--To Calculate Total Revenue
select sum(total_price) as Total_Revenue
from pizza_sales

--To calculate Average Order Value
select sum(total_price) / count(distinct(order_id)) as Average_Order_Value
from pizza_sales

--Total Quantities of Pizzas Sold
select SUM(quantity) as Total_Pizza_Sold
from pizza_sales

---Total Orders
select count(distinct(order_id)) as Total_Order
from pizza_sales

---Average Pizzas per Order
select cast(cast(sum(quantity) as decimal(10,2)) / 
cast(count(distinct(order_id)) as decimal(10,2)) as decimal(10,2)) as Average_Pizzas_per_order
from pizza_sales

------------

select *
from pizza_sales

----Daily Trend for Total Order
select datename(dw, order_date) as Order_day, count(distinct order_id) as Total_Order
from pizza_sales
group by datename(dw, order_date)

----Monthly Trend for Total Order
select datename(MONTH, order_date) as Order_Month, count(distinct order_id) as Total_Order
from pizza_sales
group by datename(MONTH, order_date)
order by Total_Order desc

----Percentage of sales by Pizza Category

select pizza_category, cast(sum(total_price) AS decimal(10,3)) as Total_Sale, 
cast((sum(total_price)/ (select SUM(total_price) from pizza_sales)) AS decimal(10,3))  * 100 as Percent_Total_Sale
from pizza_sales
group by pizza_category


----Percentage of sales by Pizza Category for each month(e.g January)
select pizza_category, sum(total_price) Total_Sale, 
(sum(total_price)/ (select SUM(total_price) from pizza_sales where MONTH(order_date)=1))  * 100 as Percent_Total_Sale
from pizza_sales
where MONTH(order_date)=1
group by pizza_category

----Percentage of sales by Pizza Size
select pizza_size, sum(total_price) Total_Sale, 
cast(sum(total_price)/ (select SUM(total_price) from pizza_sales) AS decimal(10,3))  * 100 as Percent_Total_Sale
from pizza_sales
group by pizza_size
order by Percent_Total_Sale desc

----Percentage of sales by Pizza Size for each month(e.g January)
select pizza_size, cast(sum(total_price) AS decimal(10,3)) as Total_Sale, 
cast(sum(total_price)/ (select SUM(total_price) from pizza_sales where MONTH(order_date)=1) AS decimal(10,3))  * 100 as Percent_Total_Sale
from pizza_sales
where MONTH(order_date)=1
group by pizza_size
order by Percent_Total_Sale desc


---Top 5 Best sellers by revenue
select top 5 pizza_name, sum(total_price) as Seller_Total_Price
from pizza_sales
group by pizza_name
order by 2 desc

---Bottom 5 Best sellers by revenue
select top 5 pizza_name, sum(total_price) as Seller_Total_Price
from pizza_sales
group by pizza_name
order by 2 asc

---Top 5 Best sellers by total quantity
select top 5 pizza_name, sum(quantity) as Seller_Total_Qty
from pizza_sales
group by pizza_name
order by 2 desc

---Bottom 5 Best sellers by total quantity
select top 5 pizza_name, sum(quantity) as Seller_Total_Qty
from pizza_sales
group by pizza_name
order by 2 asc


---Top 5 Best sellers by total orders
select top 5 pizza_name, count(distinct order_id) as Seller_Total_Order
from pizza_sales
group by pizza_name
order by 2 desc

---Bottom 5 Best sellers by total orders
select top 5 pizza_name, count(distinct order_id) as Seller_Total_Order
from pizza_sales
group by pizza_name
order by 2 asc


select distinct pizza_size, COUNT (pizza_size)
from pizza_sales
group by pizza_size
order by 1