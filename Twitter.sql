/*
QUESTION 3: Twitter

Title : Tweets’ Rolling Averages

Task : Given a table of tweet data over a specified time period, calculate the 3-day rolling average of tweets for each user. Output the user ID, tweet date, and rolling averages rounded to 2 decimal places.

Notes:

A rolling average, also known as a moving average or running mean is a time-series technique that examines trends in data over a specified period of time.
In this case, we want to determine how the tweet count for each user changes over a 3-day period.

tweets Table:

| user_id | tweet_date          | tweet_count |
|---------|---------------------|-------------|
| 111     | 06/01/2022 00:00:00 | 2           |
| 111     | 06/02/2022 00:00:00 | 1           |
| 111     | 06/03/2022 00:00:00 | 3           |
| 111     | 06/04/2022 00:00:00 | 4           |
| 111     | 06/05/2022 00:00:00 | 5           |

Example Output:

| user_id | tweet_date          | rolling_avg_3d |
|---------|---------------------|----------------|
| 111     | 06/01/2022 00:00:00 | 2.00           |
| 111     | 06/02/2022 00:00:00 | 1.50           |
| 111     | 06/03/2022 00:00:00 | 2.00           |
| 111     | 06/04/2022 00:00:00 | 2.67           |
| 111     | 06/05/2022 00:00:00 | 4.00           |

*/


---------- SOLUTION 1: Using Window Function AVG() ----------

SELECT 
  user_id
  , tweet_date
  , ROUND(
        AVG(tweet_count) OVER(
                            PARTITION BY user_id 
                            ORDER BY tweet_date
                            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
      , 2) AS rolling_avg_3d
FROM tweets;




---------- SOLUTION 2: Using Window Function ROW_NUMBER() ----------

WITH table_with_row_number AS (
  SELECT 
   t1.user_id
    , t1.tweet_date AS date_t1
    , t2.tweet_date
    , t2.tweet_count AS tweet_counts
    , ROW_NUMBER() OVER(PARTITION BY t1.user_id, t1.tweet_date ORDER BY t2.tweet_date DESC) AS rn
  FROM tweets  t1
  JOIN tweets  t2
  ON t1.user_id = t2.user_id AND t1.tweet_date >= t2.tweet_date
)

SELECT user_id, date_t1  
    , ROUND(SUM(tweet_counts) / COUNT(user_id) ,2) AS rolling_avg_3d 
FROM table_with_row_number
WHERE rn <=3
GROUP BY 
    user_id, date_t1 
ORDER BY 
    user_id, date_t1;