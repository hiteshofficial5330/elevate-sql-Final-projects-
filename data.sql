-- =================================================================
-- Project 1: Online Retail Sales Database
-- DML Script (data.sql)
-- This script populates the database with sample data.
-- =================================================================

USE retail_sales_db;

-- We must insert data in a specific order to satisfy foreign key constraints.
-- Order: Customers -> Addresses -> Categories -> Products -> Orders -> Order_Items -> Payments

-- --- 1. Customers ---
INSERT INTO Customers (FirstName, LastName, Email, PasswordHash, Phone) VALUES
('Alice', 'Smith', 'alice.smith@example.com', 'hash_alice_pwd', '555-0101'),
('Bob', 'Johnson', 'bob.johnson@example.com', 'hash_bob_pwd', '555-0102'),
('Charlie', 'Brown', 'charlie.brown@example.com', 'hash_charlie_pwd', '555-0103');

-- --- 2. Addresses ---
-- Add 2 addresses for Alice (Shipping & Billing) and 1 for Bob
INSERT INTO Addresses (CustomerID, AddressType, Street, City, State, ZipCode, Country) VALUES
(1, 'Shipping', '123 Maple St', 'New York', 'NY', '10001', 'USA'),
(1, 'Billing', '123 Maple St', 'New York', 'NY', '10001', 'USA'),
(2, 'Shipping', '456 Oak Ave', 'Los Angeles', 'CA', '90001', 'USA');

-- --- 3. Categories ---
-- Add parent categories first
INSERT INTO Categories (CategoryName, Description) VALUES
('Electronics', 'Laptops, smartphones, and accessories'),
('Home Goods', 'Kitchen and home appliances');

-- Add subcategories (ParentCategoryID 1 = Electronics)
INSERT INTO Categories (CategoryName, Description, ParentCategoryID) VALUES
('Laptops', 'Portable computers', 1),
('Smartphones', 'Mobile devices', 1),
('Coffee Makers', 'Machines to brew coffee', 2);

-- --- 4. Products ---
-- Product prices and stock levels
INSERT INTO Products (ProductName, Description, Price, StockQuantity, CategoryID) VALUES
('14" Laptop Pro', 'A high-performance laptop.', 1499.99, 50, 3), -- CategoryID 3 = Laptops
('Smartphone Z', 'The latest smartphone.', 899.50, 200, 4), -- CategoryID 4 = Smartphones
('Espresso Machine', 'Premium home espresso maker.', 199.99, 75, 5); -- CategoryID 5 = Coffee Makers

-- --- 5. Orders ---
-- Create orders for customers
-- Note: Alice (ID 1) has 2 orders, Bob (ID 2) has 1
INSERT INTO Orders (CustomerID, ShippingAddressID, BillingAddressID, TotalAmount) VALUES
(1, 1, 2, 1499.99), -- Alice's first order
(2, 3, 3, 899.50),  -- Bob's order
(1, 1, 2, 399.98);  -- Alice's second order (2 Espresso Machines)

-- --- 6. Order_Items ---
-- Link the orders to the products
INSERT INTO Order_Items (OrderID, ProductID, Quantity, PriceAtPurchase) VALUES
(1, 1, 1, 1499.99), -- Order 1, Laptop Pro, 1, 1499.99
(2, 2, 1, 899.50),  -- Order 2, Smartphone Z, 1, 899.50
(3, 3, 2, 199.99);  -- Order 3, Espresso Machine, 2, 199.99

-- --- 7. Payments ---
-- Add payment information for the orders
INSERT INTO Payments (OrderID, Amount, PaymentMethod, Status, TransactionID) VALUES
(1, 1499.99, 'Credit Card', 'Succeeded', 'txn_1001'),
(2, 899.50, 'PayPal', 'Succeeded', 'txn_1002'),
(3, 399.98, 'Credit Card', 'Succeeded', 'txn_1003');