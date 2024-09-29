## ADDING NECESSARY COLUMNS FOR ANALYSIS:

SELECT * FROM global_electronics.data;
SELECT * FROM global_electronics.data
ORDER BY id DESC  -- or any column that dictates the order
LIMIT 10;  -- Number of rows to fetch

-- Adding Necessary columns: 

-- Add Profit Column to my table.
ALTER TABLE data
ADD COLUMN profit_USD DECIMAL(10, 2);

SET SQL_SAFE_UPDATES = 0;

UPDATE data
SET profit_USD = final_price_per_unit_USD - final_cost_per_unit_USD;

-- Add Age Column:

ALTER TABLE data
ADD COLUMN age INT;

SET SQL_SAFE_UPDATES = 0;

UPDATE data
SET age = FLOOR(DATEDIFF(Order_Date, Birthday) / 365);

-- Add Days to Deliver:

ALTER TABLE data
ADD COLUMN days_to_deliver INT;

SET SQL_SAFE_UPDATES = 0;
UPDATE data
SET days_to_deliver = DATEDIFF(Delivery_Date, Order_Date);

################################################################################################################################################################################################

CREATE TABLE customer_analysis (
    CustomerKey varchar(255) PRIMARY KEY,
    Name varchar(255),
    Gender varchar(255),
    City varchar(255),
    State_Code varchar(255),
    State_Customer varchar(255),
    Zip_Code varchar(255),
    Country_Customer varchar(255),
    Continent varchar(255),
    age int
);

INSERT INTO customer_analysis (CustomerKey, Name, Gender, City, State_Code, State_Customer, Zip_Code, Country_Customer, Continent, age)
SELECT 
    CustomerKey,
    Name,
    Gender,
    City,
    State_Code,
    State_Customer,
    Zip_Code,
    Country_Customer,
    Continent,
    age
FROM (
    SELECT 
        CustomerKey,
        Name,
        Gender,
        City,
        State_Code,
        State_Customer,
        Zip_Code,
        Country_Customer,
        Continent,
        age,
        ROW_NUMBER() OVER (PARTITION BY CustomerKey ORDER BY CustomerKey) as rn
    FROM data
) sub
WHERE rn = 1;

###############################################################################################################################################



