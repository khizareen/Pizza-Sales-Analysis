# Selecting the 'pizza_db' database 
USE pizza_db;

# Getting an idea about all the tables 
SELECT * FROM order_details;
SELECT * FROM orders;
SELECT * FROM pizza_types;
SELECT * FROM pizzas;

# Questions
# Basic Questions
# 1. Retrieve the total number of orders placed. (Objective: Understand the total volume of orders.)
# table used orders_details

SELECT COUNT(DISTINCT order_id) AS total_orders
FROM order_details;

# 2. Calculate the total revenue generated from pizza sales. (Objective: Calculate the total revenue generated from all pizza orders.)
# tables used pizzas and order_details

SELECT SUM(od.quantity * p.price) AS total_revenue
FROM order_details od
JOIN pizzas p 
ON od.pizza_id = p.pizza_id;

SELECT ROUND(SUM(od.quantity * p.price),3) AS total_revenue
FROM order_details od
JOIN pizzas p 
ON od.pizza_id = p.pizza_id;

SELECT FLOOR(SUM(od.quantity * p.price)) AS total_revenue
FROM order_details od
JOIN pizzas p 
ON od.pizza_id = p.pizza_id;

# 3. dentify the highest-priced pizza. ( Objective: Find out which pizza is the most expensive.)
# tables used pizza , pizza_types

SELECT pizza_id, price
FROM pizzas
ORDER BY price DESC
LIMIT 1;

# 4. Identify the most common pizza size ordered. ( Objective: Determine which pizza size (e.g., small, medium, large) is ordered the most.)
# tables used order_details and pizzas

SELECT p.size, SUM(od.quantity) AS total_quantity
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY p.size
ORDER BY total_quantity DESC
LIMIT 1;

#5. List the top 5 most ordered pizza types along with their quantities. (Objective: Find out which pizza types are most frequently ordered.)
# tables used order_details, pizzas, pizza_types

SELECT pt.name AS pizza_type, SUM(od.quantity) AS total_ordered
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_ordered DESC
LIMIT 5;

# Intermediate Questions
# 1. Join the necessary tables to find the total quantity of each pizza category ordered. 
# ( Objective: Explore the relationship between pizza categories and quantities ordered.)
# tables used pizza_types, order_details, pizzas

SELECT pt.category, SUM(od.quantity) AS Total_Quantity
FROM pizza_types AS pt 
JOIN pizzas AS p 
ON p.pizza_type_id = pt.pizza_type_id
JOIN Order_Details AS od 
ON od.pizza_id = p.pizza_id
GROUP BY pt.category
ORDER BY Total_Quantity DESC;

# 2. Determine the distribution of orders by hour of the day.
# (Objective: Analyze how orders are distributed across different times of day.)

SELECT HOUR(time) AS Hour_, COUNT(order_id) AS Number_of_Orders 
FROM Orders
GROUP BY Hour_
ORDER BY Hour_;
 
# 3. Join relevant tables to find the category-wise distribution of pizzas.
# (Objective: Find out how pizzas from different categories are ordered)

SELECT pt.category, COUNT(DISTINCT p.pizza_id) AS total_pizzas
FROM pizzas p
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY total_pizzas DESC;

# 4. Group the orders by date and calculate the average number of pizzas ordered per day.
# (Objective: Analyze daily order trends and average quantities.)

SELECT FLOOR(AVG(Quantity)) AS Avg_Pizzas_Ordered_Per_Day 
FROM (
	SELECT o.date, SUM(od.quantity) AS Quantity
    FROM Orders AS o 
    JOIN Order_Details AS od 
    ON o.order_id = od.order_id
    GROUP BY o.date
) AS a;

# 5. Determine the top 3 most ordered pizza types based on revenue.
# (Objective: Identify the pizza types that generated the most revenue.)

SELECT pt.name AS pizza_type, 
       ROUND(SUM(od.quantity * p.price), 2) AS total_revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_revenue DESC
LIMIT 3;

# Advanced Questions
# 1. Calculate the percentage contribution of each pizza type to total revenue.
# (Objective: Understand each pizza's contribution to overall sales.)

SELECT pt.name AS pizza_type,
       ROUND(SUM(od.quantity * p.price), 2) AS revenue,
       ROUND(SUM(od.quantity * p.price) * 100 / (
         SELECT SUM(od2.quantity * p2.price)
         FROM order_details od2
         JOIN pizzas p2 ON od2.pizza_id = p2.pizza_id
       ), 2) AS percentage_contribution
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY percentage_contribution DESC;

# 2. Analyze the cumulative revenue generated over time.
# (Objective: Track how revenue accumulates over time.)

SELECT date, FLOOR(Revenue) AS Revenue,
FLOOR(SUM(Revenue) OVER (ORDER BY date)) AS Cum_Revenue
FROM (
	SELECT o.date, 
    SUM(od.quantity * p.price) AS Revenue 
    FROM Order_Details AS od
    JOIN Pizzas AS p
    ON p.pizza_id = od.pizza_id 
    JOIN Orders AS o 
    ON o.order_id = od.order_id 
    GROUP BY o.date
) AS s;

# 3. Determine the top 3 most ordered pizza types based on revenue for each pizza category.
# (Objective: Find the highest-grossing pizzas within each category.)

SELECT name, Revenue 
FROM (
	SELECT category, name, revenue, 
    RANK() OVER (PARTITION BY category ORDER BY Revenue DESC) AS rank_
    FROM (
		SELECT pt.category, pt.name,
        SUM(od.quantity * p.price) AS Revenue
        FROM pizza_types AS pt
        JOIN pizzas AS p 
        ON pt.pizza_type_id = p.pizza_type_id
        JOIN order_details AS od 
        ON od.pizza_id = p.pizza_id 
        GROUP BY pt.category, pt.name
        ) AS a
) AS b
WHERE rank_ <= 3;