/*
QUESTION 10: Alibaba
Title : Compressed Mode

Task : Write a query to retrieve the mode of the order occurrences. Additionally, if there are multiple item counts with the same mode, the results should be sorted in ascending order.

Clarifications:

item_count: Represents the number of items sold in each order.
order_occurrences: Represents the frequency of orders with the corresponding number of items sold per order.
For example, if there are 800 orders with 3 items sold in each order, the record would have an item_count of 3 and an order_occurrences of 800.

Table Items_per_order :

| item_count | order_occurrences |
|------------|-------------------|
| 1          | 500               |
| 2          | 1000              |
| 3          | 800               |

*/


---------- SOLUTION 1: Using MAX() ----------

SELECT item_count AS mode
FROM items_per_order
WHERE order_occurrences =  (SELECT MAX(order_occurrences) FROM items_per_order);