/*
QUESTION 4: Amazon

Title : Highest-Grossing Items

Task : Write a query to identify the top two highest-grossing products within each category in the year 2022. The output should include the category, product, and total spend.

Example Input:

| category    | product           | user_id | spend  | transaction_date       |
|-------------|-------------------|---------|--------|------------------------|
| appliance   | refrigerator     | 165     | 246.00 | 12/26/2021 12:00:00    |
| appliance   | refrigerator     | 123     | 299.99 | 03/02/2022 12:00:00    |
| appliance   | washing machine  | 123     | 219.80 | 03/02/2022 12:00:00    |
| electronics | vacuum           | 178     | 152.00 | 04/05/2022 12:00:00    |
| electronics | wireless headset | 156     | 249.90 | 07/08/2022 12:00:00    |
| electronics | vacuum           | 145     | 189.00 | 07/15/2022 12:00:00    |


Expected Output:

| category    | product           | total_spend |
|-------------|-------------------|-------------|
| appliance   | refrigerator     | 299.99      |
| appliance   | washing machine  | 219.80      |
| electronics | vacuum           | 341.00      |
| electronics | wireless headset | 249.90      |


*/

---------- SOLUTION 1: Using Window Function DENSE_RANK() ----------
WITH get_year_2022 AS (
  SELECT * FROM product_spend WHERE DATE_PART('year',transaction_date) = 2022
)
, get_total_sales AS (
  SELECT 
    category
    , product
    , SUM(spend) AS total_spend
  FROM get_year_2022
  GROUP BY 
    category, product
)
, get_rank AS (
  SELECT 
    *
    , DENSE_RANK() OVER(PARTITION BY category ORDER BY total_spend DESC) AS rank_
  FROM get_total_sales
)

SELECT category, product, total_spend FROM get_rank WHERE rank_ <= 2