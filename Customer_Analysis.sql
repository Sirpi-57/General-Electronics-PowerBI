SELECT * FROM global_electronics.customer_analysis;

SELECT COUNT(CustomerKey) AS Customer_Count
FROM customer_analysis; -- 11887

#CUSTOMER ANALYSIS:

## 1.Demographic Distribution:

-- Gender Distribution:
SELECT Gender, COUNT(*) AS Count
FROM customer_analysis
GROUP BY Gender; -- 11887

-- City wise Distribution:
SELECT City, COUNT(*) AS Count
FROM customer_analysis
GROUP BY City
ORDER BY Count DESC;

 
-- State wise Distribution: 
SELECT State_Customer, COUNT(*) AS Count
FROM customer_analysis
GROUP BY State_Customer
ORDER BY Count DESC;


-- Country Wise Distribution:
SELECT Country_Customer, COUNT(*) AS Count
FROM customer_analysis
GROUP BY Country_Customer
ORDER BY Count DESC;

-- Age Analysis:
SELECT 
    CASE 
        WHEN age BETWEEN 14 AND 17 THEN '12-17'
        WHEN age BETWEEN 18 AND 24 THEN '18-24'
        WHEN age BETWEEN 25 AND 34 THEN '25-34'
        WHEN age BETWEEN 35 AND 44 THEN '35-44'
        WHEN age BETWEEN 45 AND 54 THEN '45-54'
        WHEN age BETWEEN 55 AND 64 THEN '55-64'
        WHEN age BETWEEN 65 AND 74 THEN '65-74'
        WHEN age BETWEEN 75 AND 81 THEN '75-85'
        ELSE '85+'
    END AS age_group,
    COUNT(*) AS count
FROM customer_analysis
GROUP BY age_group
ORDER BY age_group;

## ADDING NECESSARY COLUMNS:

-- First, ensure the columns exist in the customer_analysis table
ALTER TABLE customer_analysis
ADD COLUMN final_price_per_unit_USD DECIMAL(10, 2),
ADD COLUMN Quantity INT,
ADD COLUMN Order_ID VARCHAR(255),
ADD COLUMN Product_Name VARCHAR(255);

-- Then, update the customer_analysis table with the data from the data table
UPDATE customer_analysis ca
JOIN data d ON ca.CustomerKey = d.CustomerKey
SET ca.final_price_per_unit_USD = d.final_price_per_unit_USD,
    ca.Quantity = d.Quantity,
    ca.Order_ID = d.Order_ID,
    ca.Product_Name = d.Product_Name;

## PURCHASE PATTERN ANALYSIS:

-- Total sales by customer (top 10):
SELECT Name, SUM(final_price_per_unit_USD * Quantity) as Total_Sales
FROM customer_analysis
GROUP BY Name
ORDER BY Total_Sales DESC
LIMIT 10;

-- Sales by customer's geography country & continent vs total_sales:
SELECT Continent, Country_Customer, SUM(final_price_per_unit_USD * Quantity) as Total_Sales
FROM customer_analysis
GROUP BY Continent, Country_Customer
ORDER BY Total_Sales DESC;

-- Top 5 favorite product based on customer purchase (assuming favorite means most frequently purchased):
SELECT 
    Product_Name,
    COUNT(DISTINCT Name) as Unique_Customers,
    SUM(Quantity) as Total_Quantity
FROM customer_analysis
GROUP BY Product_Name
ORDER BY Unique_Customers DESC, Total_Quantity DESC
LIMIT 10;

-- Frequency of purchases based on purchase_count:
SELECT 
    purchase_count,
    COUNT(*) as customer_count
FROM (
    SELECT Name, COUNT(DISTINCT Order_ID) as purchase_count
    FROM customer_analysis
    GROUP BY Name
) subquery
GROUP BY purchase_count
ORDER BY purchase_count;

-- Geographic distribution of product sales:
SELECT 
    Product_Name,
    Country_Customer,
    COUNT(DISTINCT Name) as Unique_Customers,
    SUM(Quantity) as Total_Quantity,
    SUM(final_price_per_unit_USD * Quantity) as Total_Sales
FROM customer_analysis
GROUP BY Product_Name, Country_Customer
ORDER BY Product_Name, Total_Sales DESC;

-- Segmentation by age group vs total_sales:
SELECT 
    CASE 
        WHEN age < 18 THEN 'Under 18'
        WHEN age BETWEEN 18 AND 24 THEN '18-24'
        WHEN age BETWEEN 25 AND 34 THEN '25-34'
        WHEN age BETWEEN 35 AND 44 THEN '35-44'
        WHEN age BETWEEN 45 AND 54 THEN '45-54'
        WHEN age BETWEEN 55 AND 64 THEN '55-64'
        ELSE '65+'
    END AS age_group,
    COUNT(DISTINCT Name) as customer_count,
    SUM(final_price_per_unit_USD * Quantity) as total_sales
FROM customer_analysis
GROUP BY age_group
ORDER BY total_sales DESC;

## CUSTOMER SEGMENTATION AND BEHAVIORAL ANALYSIS:

-- Gender-based Segmentation analysis vs total_sales:
SELECT Gender, COUNT(DISTINCT Name) as customer_count, SUM(final_price_per_unit_USD * Quantity) as total_sales
FROM customer_analysis
GROUP BY Gender;

-- Number of customers who bought each product:
SELECT 
    Product_Name,
    COUNT(DISTINCT Name) as Customer_Count
FROM customer_analysis
GROUP BY Product_Name
ORDER BY Customer_Count DESC;

-- Gender interest in products: (Product Name vs Gender vs Unique Customer vs Total Quantity vs Total Sales)
SELECT 
    Product_Name,
    Gender,
    COUNT(DISTINCT Name) as Unique_Customers,
    SUM(Quantity) as Total_Quantity,
    SUM(final_price_per_unit_USD * Quantity) as Total_Sales
FROM customer_analysis
GROUP BY Product_Name, Gender
ORDER BY Product_Name, Total_Sales DESC;

-- Age group preference for products:
SELECT 
    Product_Name,
    CASE 
        WHEN age < 18 THEN 'Under 18'
        WHEN age BETWEEN 18 AND 24 THEN '18-24'
        WHEN age BETWEEN 25 AND 34 THEN '25-34'
        WHEN age BETWEEN 35 AND 44 THEN '35-44'
        WHEN age BETWEEN 45 AND 54 THEN '45-54'
        WHEN age BETWEEN 55 AND 64 THEN '55-64'
        ELSE '65+'
    END AS age_group,
    COUNT(DISTINCT Name) as Unique_Customers,
    SUM(Quantity) as Total_Quantity,
    SUM(final_price_per_unit_USD * Quantity) as Total_Sales
FROM customer_analysis
GROUP BY Product_Name, age_group
ORDER BY Product_Name, Total_Sales DESC;

-- Customer purchase frequency analysis:
WITH purchase_frequency AS (
    SELECT 
        Name,
        COUNT(DISTINCT Order_ID) as Order_Count,
        SUM(Quantity) as Total_Items,
        SUM(final_price_per_unit_USD * Quantity) as Total_Spent
    FROM customer_analysis
    GROUP BY Name
)
SELECT 
    CASE 
        WHEN Order_Count = 1 THEN 'One-time'
        WHEN Order_Count BETWEEN 2 AND 3 THEN 'Occasional'
        WHEN Order_Count BETWEEN 4 AND 6 THEN 'Regular'
        ELSE 'Frequent'
    END AS Customer_Type,
    COUNT(*) as Customer_Count,
    AVG(Total_Items) as Avg_Items_Purchased,
    AVG(Total_Spent) as Avg_Total_Spent
FROM purchase_frequency
GROUP BY Customer_Type
ORDER BY Customer_Count DESC;
