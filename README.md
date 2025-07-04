# Pizza-Sales-Analysis
An end-to-end SQL project analyzing a pizza sales dataset to uncover insights on order volume, revenue, pizza popularity, and customer behavior. Used SQL queries to perform data exploration, aggregation, joins, window functions, and ranking across 13 real-world business questions.

# Pizza Sales Analysis with SQL

Analyze one month of pizza‑store data to uncover ordering patterns, revenue drivers, and category performance.  
All insights are produced with pure SQL (MySQL 8) and run locally against `pizza_db`.

## Dataset
* **Dump file:** `pizza_db.sql` (included) – creates **4 tables**

| Table          | Key columns (excerpt)                       | Purpose                              |
| -------------- | ------------------------------------------- | ------------------------------------ |
| `orders`       | `order_id`, `order_date`                    | Master list of customer orders       |
| `order_details`| `order_id`, `pizza_id`, `quantity`          | Line‑items per pizza                 |
| `pizzas`       | `pizza_id`, `pizza_type_id`, `size`, `price`| SKU catalogue + price list           |
| `pizza_types`  | `pizza_type_id`, `name`, `category`         | Human‑readable pizza meta            |

## Setup

```sql
-- clone repo, start MySQL then:
SOURCE pizza_db.sql;   -- loads data (~48 K rows)
USE pizza_db;
That’s it—no extra extensions required.

🔎 Questions & Queries
Level	Business Question	File section
Basic	Total orders • Total revenue • Highest‑priced pizza • Most common size • Top‑5 pizzas by quantity	#Basic Q1–Q5
Intermediate	Quantity per category • Orders by hour • Menu mix by category • Avg. pizzas / day • Top‑3 pizzas by revenue	#Intermediate Q1–Q5
Advanced	% revenue share per pizza • Cumulative revenue trend • Top‑3 revenue pizzas inside each category	#Advanced Q1–Q3

All 13 parameterised queries (with comments) live in pizza_queries.sql and mirror the markdown above.

Key Findings <sub>(sample results on local run)</sub>

3 676 distinct orders generated ₹ 694 k revenue.

Large pizzas account for ≈ 46 % of volume.

“Thai Chicken L” is the single biggest earner; Veggie category dominates quantity but not revenue.

Sales peak between 18:00–20:00, hinting at dinner‑time promotions.

Cumulative revenue curve shows 80 % of the month’s takings arrive by day 22 (Pareto effect).

(Figures will reproduce exactly when you execute the scripts on the dump.)

Repository Layout
pgsql
Copy
Edit
├─ pizza_db.sql        # original data dump (schema + inserts)
├─ pizza_queries.sql   # 13 answered queries, grouped by level
└─ README.md           # project documentation (you are here)

Author
Made with ❤️ by Khizareen Taj for the Data‑Science‑with‑SQL module (July 2025).
Code is MIT‑licensed; dataset is provided for educational use only.
