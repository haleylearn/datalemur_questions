/*
QUESTION 2: Snapchat

Title : Sending vs. Opening Snaps

Task : Write a query to obtain a breakdown of the time spent sending vs. opening snaps as a percentage of total time spent on these activities grouped by age group. Round the percentage to 2 decimal places in the output.

Notes :

Calculate the following percentages:
** Time spent sending / (Time spent sending + Time spent opening)

** Time spent opening / (Time spent sending + Time spent opening)

To avoid integer division in percentages, multiply by 100.0 and not 100.

Table activities:

| activity_id | user_id | activity_type | time_spent | activity_date       |
|-------------|---------|---------------|------------|---------------------|
| 7274        | 123     | open          | 4.50       | 06/22/2022 12:00:00 |
| 2425        | 123     | send          | 3.50       | 06/22/2022 12:00:00 |
| 1413        | 456     | send          | 5.67       | 06/23/2022 12:00:00 |
| 1414        | 789     | chat          | 11.00      | 06/25/2022 12:00:00 |
| 2536        | 456     | open          | 3.00       | 06/25/2022 12:00:00 |

Table age_breakdown:

| user_id | age_bucket |
|---------|------------|
| 123     | 31-35      |
| 456     | 26-30      |
| 789     | 21-25      |

Example Output:

| age_bucket | send_perc | open_perc |
|------------|-----------|-----------|
| 26-30      | 65.40     | 34.60     |
| 31-35      | 43.75     | 56.25     |

*/

---------- SOLUTION 1: Using CTE And Sum(), Case----------
WITH table_no_activity_chat AS (
  SELECT *
  FROM activities a
  JOIN age_breakdown e ON a.user_id = e.user_id
  WHERE a.activity_type <> 'chat'
)
, calculate_time AS (
  SELECT age_bucket
    , SUM(CASE WHEN activity_type = 'send' THEN time_spent ELSE 0 END) AS total_time_send
    , SUM(CASE WHEN activity_type = 'open' THEN time_spent ELSE 0 END) AS total_time_open
    , SUM(time_spent) AS total_time
  FROM table_no_activity_chat
  GROUP BY age_bucket
)

SELECT age_bucket
  , ROUND((total_time_send / total_time) * 100 , 2) AS send_perc
  , ROUND((total_time_open / total_time) * 100 , 2) AS open_perc
FROM calculate_time



---------- SOLUTION 1: Using Sum(), Case----------
SELECT 
  ag.age_bucket, 
  ROUND(
    SUM( CASE WHEN a.activity_type = 'send' THEN a.time_spent ELSE 0 END ) * 100.0 
    / 
    SUM( CASE WHEN a.activity_type in ('send', 'open') THEN a.time_spent ELSE 0 END)
    , 2 
  ) AS send_perc, 
  ROUND(
    SUM( CASE WHEN a.activity_type = 'open' THEN a.time_spent ELSE 0 END ) * 100.0 
    / 
    SUM( CASE WHEN a.activity_type in ('send', 'open') THEN a.time_spent ELSE 0 END )
    , 2 
  ) AS open_perc 
FROM 
  activities a 
  JOIN age_breakdown ag ON a.user_id = ag.user_id 
GROUP BY 
  age_bucket;