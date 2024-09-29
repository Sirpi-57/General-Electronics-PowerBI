SELECT * FROM global_electronics.sales_analysis;

## SALES AND PRODUCT ANALYSIS:

-- Overall Sales Performance:
SELECT 
    SUM(Quantity * final_price_per_unit_USD) as Total_Sales,
    SUM(Quantity * profit_USD) as Total_Profit,
    SUM(Quantity * profit_USD) / SUM(Quantity * final_price_per_unit_USD) * 100 as Profit_Margin_Percentage
FROM sales_analysis;

-- Sales by Product:
SELECT 
    Product_Name,
    SUM(Quantity) as Total_Quantity_Sold,
    SUM(Quantity * final_price_per_unit_USD) as Total_Sales,
    SUM(Quantity * profit_USD) as Total_Profit
FROM sales_analysis
GROUP BY Product_Name
ORDER BY Total_Sales DESC;

-- Sales by Store:
SELECT 
    StoreKey,
    SUM(Quantity * final_price_per_unit_USD) as Total_Sales,
    SUM(Quantity * profit_USD) as Total_Profit
FROM sales_analysis
GROUP BY StoreKey
ORDER BY Total_Sales DESC;

-- Sales by Country:
SELECT 
    Country_Store,
    SUM(Quantity * final_price_per_unit_USD) as Total_Sales,
    SUM(Quantity * profit_USD) as Total_Profit
FROM sales_analysis
GROUP BY Country_Store
ORDER BY Total_Sales DESC;

-- Sales/Profit by Category and Subcategory:
SELECT 
    Category,
    Subcategory,
    SUM(Quantity * final_price_per_unit_USD) as Total_Sales,
    SUM(Quantity * profit_USD) as Total_Profit,
    SUM(Quantity * profit_USD) / SUM(Quantity * final_price_per_unit_USD) * 100 as Profit_Margin_Percentage
FROM sales_analysis
GROUP BY Category, Subcategory
ORDER BY Category, Total_Sales DESC;

-- Top 10 Most Profitable Products:
SELECT 
    Product_Name,
    SUM(Quantity * profit_USD) as Total_Profit,
    SUM(Quantity * final_price_per_unit_USD) as Total_Sales,
    SUM(Quantity) as Total_Quantity_Sold
FROM sales_analysis
GROUP BY Product_Name
ORDER BY Total_Profit DESC
LIMIT 10;

-- Brand Performance Analysis:
SELECT 
    StoreKey,
    Country_Store,
    SUM(Quantity * final_price_per_unit_USD) as Total_Sales,
    SUM(Quantity * profit_USD) as Total_Profit,
    RANK() OVER (ORDER BY SUM(Quantity * profit_USD) DESC) as Profit_Rank
FROM sales_analysis
GROUP BY StoreKey, Country_Store
ORDER BY Total_Profit DESC;

-- Most and Meast Popular Product by sales:

(SELECT 
    Product_Name,
    SUM(Quantity * final_price_per_unit_USD) as Total_Sales,
    'Top 5' as Category
FROM sales_analysis
GROUP BY Product_Name
ORDER BY Total_Sales DESC
LIMIT 5)

UNION ALL

(SELECT 
    Product_Name,
    SUM(Quantity * final_price_per_unit_USD) as Total_Sales,
    'Bottom 5' as Category
FROM sales_analysis
GROUP BY Product_Name
ORDER BY Total_Sales ASC
LIMIT 5)

ORDER BY Total_Sales DESC;   
