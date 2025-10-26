-- =================================================================
-- Project 1: Online Retail Sales Database
-- DQL Script (reports.sql)
-- This script creates views and runs queries for business reports.
-- =================================================================

USE retail_sales_db;

-- --- 1. CREATING VIEWS (Reusable Reports) ---

-- View 1: A detailed report on every item sold, joining 5 tables.
-- This simplifies future queries.
CREATE OR REPLACE VIEW v_SalesDetails AS
SELECT
    O.OrderID,
    O.OrderDate,
    C.CustomerID,
    CONCAT(C.FirstName, ' ', C.LastName) AS CustomerName,
    C.Email AS CustomerEmail,
    P.ProductID,
    P.ProductName,
    Cat.CategoryName,
    OI.Quantity,
    OI.PriceAtPurchase,
    (OI.Quantity * OI.PriceAtPurchase) AS ItemTotal
FROM Orders AS O
JOIN Customers AS C ON O.CustomerID = C.CustomerID
JOIN Order_Items AS OI ON O.OrderID = OI.OrderID
JOIN Products AS P ON OI.ProductID = P.ProductID
JOIN Categories AS Cat ON P.CategoryID = Cat.CategoryID;


-- View 2: A summary of total spending per customer.
CREATE OR REPLACE VIEW v_CustomerSpending AS
SELECT
    C.CustomerID,
    CONCAT(C.FirstName, ' ', C.LastName) AS CustomerName,
    C.Email,
    COUNT(DISTINCT O.OrderID) AS TotalOrders,
    SUM(O.TotalAmount) AS TotalSpent
FROM Customers AS C
LEFT JOIN Orders AS O ON C.CustomerID = O.CustomerID
GROUP BY C.CustomerID, CustomerName, C.Email;


-- --- 2. RUNNING QUERIES (Answering Business Questions) ---

-- Query 1: Show the detailed sales report using our new view.
-- (This is now simple, thanks to the view)
SELECT * FROM v_SalesDetails;

-- Query 2: Show the customer spending summary.
-- (This also uses a view)
SELECT * FROM v_CustomerSpending
ORDER BY TotalSpent DESC;

-- Query 3: Who is our top customer?
-- (Querying a view)
SELECT CustomerName, TotalSpent
FROM v_CustomerSpending
ORDER BY TotalSpent DESC
LIMIT 1;

-- Query 4: What is our best-selling product category?
-- (Querying a view)
SELECT
    CategoryName,
    SUM(ItemTotal) AS TotalRevenue,
    SUM(Quantity) AS TotalQuantitySold
FROM v_SalesDetails
GROUP BY CategoryName
ORDER BY TotalRevenue DESC;

-- Query 5: Find all customers who have NOT placed any orders.
-- (This demonstrates a LEFT JOIN / NULL check from the view)
SELECT CustomerName, Email
FROM v_CustomerSpending
WHERE TotalOrders = 0;