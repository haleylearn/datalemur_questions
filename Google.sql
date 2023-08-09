/*
QUESTION 8: Google
Title : Odd and Even Measurements

Task :

Write a query to calculate the sum of odd-numbered and even-numbered measurements separately for a particular day and display the results in two different columns. Refer to the Example Output below for the desired format.

Definition :

Within a day, measurements taken at 1st, 3rd, and 5th times are considered odd-numbered measurements, and measurements taken at 2nd, 4th, and 6th times are considered even-numbered measurements.

Table Measurements :

| measurement_id | measurement_value | measurement_time      |
|----------------|-------------------|-----------------------|
| 131233         | 1109.51           | 07/10/2022 09:00:00  |
| 135211         | 1662.74           | 07/10/2022 11:00:00  |
| 523542         | 1246.24           | 07/10/2022 13:15:00  |
| 


*/


---------- SOLUTION : Using Window Function DENSE_RANK  ----------

WITH get_measurement_number AS (
  SELECT 
    measurement_id
    , measurement_value
    , measurement_time
    , date(measurement_time) as measurement_day
    , DENSE_RANK() 
        OVER(PARTITION BY date(measurement_time) 
        ORDER BY measurement_time ASC) AS measurement_number
  FROM measurements
)

SELECT
  measurement_day
  , SUM(CASE WHEN measurement_number % 2 = 0 THEN measurement_value ELSE 0 END) AS even_sum
  , SUM(CASE WHEN measurement_number % 2 <> 0 THEN measurement_value ELSE 0 END) AS odd_sum
FROM get_measurement_number
GROUP BY measurement_day
ORDER BY measurement_day

