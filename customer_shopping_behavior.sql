# Create a Database : Customer_Behaviour

Create Database IF Not Exists Customer_Behaviour;

Use Customer_Behaviour;

Select * From customer limit 20;


-- 1.What is total Revenue  generated w.r.t gender?
SELECT 
    gender, SUM(purchase_amount) AS revenue
FROM
    customer
GROUP BY gender;

-- 2.Which Category generating more revenue ?
SELECT 
    category, SUM(purchase_amount) AS revenue
FROM
    customer
GROUP BY Category
ORDER BY revenue DESC;

-- 3. Top 5 products with highest average rating ?
SELECT 
    item_purchased, AVG(review_rating) AS average_rating
FROM
    customer
GROUP BY item_purchased
ORDER BY average_rating DESC
LIMIT 5;

-- 4. which customer used a discount still spent more than  average purchase amount ?
SELECT 
    customer_id, purchase_amount
FROM
    customer
WHERE
    discount_applied = 'Yes'
        AND purchase_amount >= (SELECT 
            AVG(purchase_amount)
        FROM
            customer);

-- 5. Compare the average Purchase Amounts between Standard and Express Shipping. ?
SELECT 
    shipping_type,
    AVG(purchase_amount) AS average_purchase_amount
FROM
    customer
WHERE
    shipping_type IN ('Standard' , 'Express')
GROUP BY shipping_type;


SELECT 
    shipping_type, ROUND(AVG(purchase_amount), 2)
FROM
    customer
WHERE
    shipping_type IN ('Standard' , 'Express')
GROUP BY shipping_type;

-- 6. Do subscribed customers spend more? Compare average spend and total revenue between subscribers and non-subscribers ?
Select subscription_status , avg(purchase_amount) as average_spend , sum(purchase_amount) as total_revenue
From customer
Group by subscription_status
Order by average_spend,total_revenue Desc;

SELECT 
    subscription_status,
    COUNT(customer_id) AS total_customers,
    ROUND(AVG(purchase_amount), 2) AS avg_spend,
    ROUND(SUM(purchase_amount), 2) AS total_revenue
FROM
    customer
GROUP BY subscription_status
ORDER BY total_revenue , avg_spend DESC;

-- 7. Segment customers into New, Returning, and Loyal based on their total number of previous purchases, and show the count of each segment?
select * from customer;

 
with customer_type as (
SELECT customer_id, previous_purchases,
CASE 
    WHEN previous_purchases = 1 THEN 'New'
    WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
    ELSE 'Loyal'
    END AS customer_segment
FROM customer)

Select customer_segment,count(*) as "Number of Customers"
From customer_type
group by customer_segment;

-- 8. What are the top 3 most purchased products within each category? 
WITH item_counts AS (
    SELECT category,
           item_purchased,
           COUNT(customer_id) AS total_orders,
           ROW_NUMBER() OVER (PARTITION BY category ORDER BY COUNT(customer_id) DESC) AS item_rank
    FROM customer
    GROUP BY category, item_purchased
)
SELECT item_rank,category, item_purchased, total_orders
FROM item_counts
WHERE item_rank <=3;

-- 9. Are customers who are repeat buyers (more than 5 previous purchases) also likely to subscribe
SELECT 
    subscription_status, COUNT(customer_id) as repeat_buyers
FROM
    customer
WHERE
    previous_purchases > 5
GROUP BY subscription_status;

-- 10. What is the revenue contribution of each age group? 
SELECT 
    age_group, SUM(purchase_amount) AS revenue
FROM
    customer
GROUP BY age_group
ORDER BY revenue DESC;
