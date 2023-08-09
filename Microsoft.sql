/*
QUESTION 7: Microsoft
Title : Supercloud customer

Task :

A Microsoft Azure Supercloud customer is a company which buys at least 1 product from each product category.

Write a query to report the company ID which is a Supercloud customer.

Table Customer_contracts :

| customer_id | product_id | amount |
|-------------|------------|--------|
| 1           | 1          | 1000   |
| 1           | 3          | 2000   |
| 1           | 5          | 1500   |
| 2           | 2          | 3000   |
| 2           | 6          | 2000   |


Table Products :
| product_id | product_category | product_name           |
|------------|------------------|------------------------|
| 1          | Analytics        | Azure Databricks      |
| 2          | Analytics        | Azure Stream Analytics|
| 4          | Containers       | Azure Kubernetes Service |
| 5          | Containers       | Azure Service Fabric  |
| 6          | Compute          | Virtual Machines      |
| 7          | Compute          | Azure Functions       |

*/


---------- SOLUTION 1 ----------

SELECT customer_id
FROM customer_contracts c
JOIN products p ON c.product_id = p.product_id
GROUP BY customer_id
HAVING COUNT(DISTINCT p.product_category) >= 3
ORDER BY customer_id;