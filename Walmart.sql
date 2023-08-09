/*
QUESTION 9: Walmart

Title : Histogram of Users and Purchases

Task : Based on their most recent transaction date, write a query that retrieve the users along with the number of products they bought.

Output the user’s most recent transaction date, user ID, and the number of products, sorted in chronological order by the transaction date.

Table User_transactions :

| product_id | user_id | spend  | transaction_date      |
|------------|---------|--------|-----------------------|
| 3673       | 123     | 68.90  | 07/08/2022 12:00:00  |
| 9623       | 123     | 274.10 | 07/08/2022 12:00:00  |
| 1467       | 115     | 19.90  | 07/08/2022 12:00:00  |
| 2513       | 159     | 25.00  | 07/08/2022 12:00:00  |
| 1452       | 159     | 74.50  | 07/10/2022 12:00:00  |

*/

---------- SOLUTION 1: Using Window Function DENSE_RANK and CTE ----------

WITH latest_transactions AS (
  SELECT 
    transaction_date, 
    user_id, 
    DENSE_RANK() OVER(
      PARTITION BY user_id 
      ORDER BY 
        transaction_date DESC
    ) AS latest_purchase 
  FROM 
    user_transactions
) 
SELECT 
  transaction_date, 
  user_id, 
  COUNT(user_id) AS purchase_count 
FROM 
  latest_transactions 
WHERE 
  latest_purchase = 1 
GROUP BY 
  transaction_date, 
  user_id
