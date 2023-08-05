QUESTION 1: Uber

Title : User’s Third Transaction

Task : Assume you are given the table below on Uber transactions made by users. Write a query to obtain the third transaction of every user. Output the user id, spend and transaction date.

Table: 
| user_id | spend  | transaction_date       |
|---------|--------|------------------------|
| 111     | 100.50 | 01/08/2022 12:00:00    |
| 111     | 55.00  | 01/10/2022 12:00:00    |
| 121     | 36.00  | 01/18/2022 12:00:00    |
| 145     | 24.99  | 01/26/2022 12:00:00    |
| 111     | 89.60  | 02/05/2022 12:00:00    |

Expected:
| user_id | spend  | transaction_date       |
|---------|--------|------------------------|
| 111     | 89.60  | 02/05/2022 12:00:00    |
| 121     | 67.90  | 04/03/2022 12:00:00    |
| 263     | 100.00 | 07/12/2022 12:00:00    |

-- Solution 1: Using Window Function And CTE 

WITH transaction_rank AS (
  SELECT *
    , ROW_NUMBER() OVER(PARTITION BY user_id) AS rank_
  FROM (SELECT * FROM transactions ORDER BY user_id, transaction_date) x
)

SELECT user_id
    , spend
    , transaction_date
FROM transaction_rank t
WHERE t.rank_ = 3

-- Solution 2: Using Having Count
SELECT t1.user_id
     , t1.spend
     , t1.transaction_date
FROM transactions t1
        INNER JOIN transactions t2 ON t1.user_id = t2.user_id AND t2.transaction_date < t1.transaction_date
GROUP BY t1.user_id
        , t1.spend
        , t1.transaction_date
HAVING COUNT(t2.transaction_date) = 2;

-- Solution 3: Using SUM()
WITH src AS (
    SELECT t1.user_id
        , t1.spend
        , t1.transaction_date
        , 1+SUM(CASE WHEN t2.transaction_date < t1.transaction_date THEN 1 ELSE 0 END) AS rn
    FROM transactions t1
        INNER JOIN transactions t2 ON t1.user_id = t2.user_id
    GROUP BY t1.user_id
            , t1.spend
            , t1.transaction_date
)

SELECT s.user_id
     , s.spend
     , s.transaction_date
FROM src s
WHERE s.rn=3;