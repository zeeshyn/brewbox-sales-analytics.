SELECT pid, state, left(query, 60) AS query
FROM pg_stat_activity
WHERE datname = 'brewbox' AND pid <> pg_backend_pid();

SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE datname = 'brewbox' AND pid <> pg_backend_pid();

SELECT COUNT(ORDER_STATUS) 
FROM ORDERS
WHERE ORDER_STATUS = 'Delivered'

--Q1 no of orders
SELECT 
	SUM(CASE WHEN order_status='Delivered' THEN 1 ELSE 0 END) AS Delivered_items,
	SUM(CASE WHEN order_status='Cancelled' THEN 1 ELSE 0 END) AS Cancelled_items,
	SUM(CASE WHEN order_status='Returned' THEN 1 ELSE 0 END) AS Returned_items,
	COUNT(ORDER_STATUS) AS total_orders
		FROM orders;

--Q2 customers per city
SELECT city,COUNT(customer_id) as no_of_customers
		FROM customers
	GROUP BY city
	ORDER BY no_of_customers desc;

--Q3 items sold per category
SELECT products.category,SUM(order_items.quantity) as units_sold FROM products
INNER JOIN order_items ON
products.product_id = order_items.product_id
GROUP BY category;

--Q4 What are the total revenue and profit by category? (Delivered orders only.)
SELECT products.category,
       ROUND(SUM(order_items.quantity * order_items.unit_price * (1 - orders.discount_pct / 100.0)), 2) AS revenue,
       ROUND(SUM(order_items.quantity * order_items.unit_price * (1 - orders.discount_pct / 100.0)
                 - order_items.quantity * products.cost_price), 2) AS profit
				 FROM products
INNER JOIN order_items ON
products.product_id = order_items.product_id
INNER JOIN orders ON 
orders.order_id=order_items.order_id
WHERE orders.order_status = 'Delivered'
GROUP BY products.category
	;

--Q5. Who are the top 10 customers by revenue?
SELECT customer_name,
	 ROUND(SUM(order_items.quantity * order_items.unit_price * 
	 (1 - orders.discount_pct / 100.0)), 2) AS revenue
FROM customers
INNER JOIN orders
ON customers.customer_id=orders.customer_id
INNER JOIN order_items ON 
order_items.order_id=orders.order_id
INNER JOIN products ON
products.product_id=order_items.product_id
WHERE orders.order_status='Delivered'
GROUP BY customers.customer_name,customers.customer_id
ORDER BY revenue DESC
LIMIT 10

--Q6. What is the revenue by sales channel and payment method?
SELECT orders.channel,orders.payment_method,
 ROUND(SUM(order_items.quantity * order_items.unit_price * 
	 (1 - orders.discount_pct / 100.0)), 2) AS revenue 
	 FROM
orders
INNER JOIN order_items ON
orders.order_id=order_items.order_id
WHERE orders.order_status = 'Delivered'
GROUP BY orders.channel,orders.payment_method
ORDER BY revenue DESC;

--Q7. Which cities have more than 50 delivered orders?
SELECT city,
SUM(CASE WHEN order_status = 'Delivered' THEN 1 ELSE 0 END)as no_of_orders FROM
customers
INNER JOIN orders
ON customers.customer_id=orders.customer_id
GROUP BY city
HAVING SUM(CASE WHEN order_status = 'Delivered' THEN 1 ELSE 0 END) > 50
ORDER BY no_of_orders DESC

--Q8. What is the return rate by payment method? Is COD worse?
SELECT payment_method,
ROUND(100.0*SUM(CASE WHEN order_status='Returned' THEN 1 ELSE 0 END)/COUNT(*),2) as return_rate
FROM orders
GROUP BY payment_method
ORDER BY return_rate DESC

--Q9. What is the monthly revenue, and the month-over-month growth %?
WITH monthly as (
SELECT  DATE_TRUNC('month', orders.order_date)::date AS month,
ROUND(SUM(order_items.quantity * order_items.unit_price * 
	 (1 - orders.discount_pct / 100.0)), 2) AS revenue
	 FROM orders
	 INNER JOIN order_items
	 ON orders.order_id=order_items.order_id
	 WHERE orders.order_status= 'Delivered'
	 GROUP BY DATE_TRUNC('month', orders.order_date)
	 )
	 SELECT month,
       ROUND(revenue, 2) AS revenue,
       ROUND(LAG(revenue) OVER (ORDER BY month), 2) AS prev_month_revenue,
       ROUND(100.0 * (revenue - LAG(revenue) OVER (ORDER BY month))
             / LAG(revenue) OVER (ORDER BY month), 1) AS mom_growth_pct
FROM monthly
ORDER BY month;

--Q10. How do products rank by profit within each category?
SELECT products.category,
       products.product_name,
        ROUND(SUM(order_items.quantity * order_items.unit_price * (1 - orders.discount_pct / 100.0)
                 - order_items.quantity * products.cost_price), 2) AS profit,
       RANK() OVER (PARTITION BY products.category
                    ORDER BY SUM(order_items.quantity * order_items.unit_price * (1 - orders.discount_pct / 100.0)
                 - order_items.quantity * products.cost_price) DESC) AS profits_rank FROM
products
INNER JOIN order_items ON
products.product_id=order_items.product_id
INNER JOIN orders ON
orders.order_id=order_items.order_id
WHERE orders.order_status='Delivered'
GROUP BY products.category,products.product_name
ORDER BY products.category, profits_rank;