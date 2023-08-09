/*
QUESTION 6: TikTok

Title : Signup Activation Rate

Task :

A senior analyst is interested to know the activation rate of specified users in the emails table. Write a query to find the activation rate. Round the percentage to 2 decimal places.

Definitions:

emails table contain the information of user signup details.
texts table contains the users’ activation information.
Assumptions:

The analyst is interested in the activation rate of specific users in the emails table, which may not include all users that could potentially be found in the texts table.
For example, user 123 in the emails table may not be in the texts table and vice versa.

Table Emails:

| email_id | user_id | signup_date         |
|----------|---------|---------------------|
| 125      | 7771    | 06/14/2022 00:00:00 |
| 236      | 6950    | 07/01/2022 00:00:00 |
| 433      | 1052    | 07/09/2022 00:00:00 |


Table Texts:

| text_id | email_id | signup_action |
|---------|----------|---------------|
| 6878    | 125      | Confirmed     |
| 6920    | 236      | Not Confirmed |
| 6994    | 236      | Confirmed     |


*/


---------- SOLUTION  ----------

WITH count_confirmed AS (
  SELECT COUNT(DISTINCT email_id) AS cnt_confirmed FROM texts WHERE signup_action = 'Confirmed'
)
,  total_email_id AS (
  SELECT COUNT(email_id) AS total_email_id FROM texts
)
SELECT ROUND((cnt_confirmed ::NUMERIC) / (total_email_id ::NUMERIC), 2) AS confirm_rate
FROM count_confirmed, total_email_id