-- =================================================================
-- Project 1: Online Retail Sales Database
-- DDL Script (schema.sql)
-- This script creates the database and all its tables.
-- =================================================================

-- Create and use the new database
CREATE DATABASE IF NOT EXISTS retail_sales_db;
USE retail_sales_db;

-- --- 1. Customers Table ---
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(255) NOT NULL UNIQUE,
    PasswordHash VARCHAR(255) NOT NULL,
    Phone VARCHAR(20),
    CreatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- --- 2. Addresses Table ---
-- Stores multiple addresses per customer
CREATE TABLE Addresses (
    AddressID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT NOT NULL,
    AddressType ENUM('Shipping', 'Billing') NOT NULL,
    Street VARCHAR(255) NOT NULL,
    City VARCHAR(100) NOT NULL,
    State VARCHAR(100) NOT NULL,
    ZipCode VARCHAR(20) NOT NULL,
    Country VARCHAR(100) NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE
);

-- --- 3. Categories Table ---
-- Uses a self-referencing key for subcategories
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY AUTO_INCREMENT,
    CategoryName VARCHAR(100) NOT NULL UNIQUE,
    Description TEXT,
    ParentCategoryID INT,
    FOREIGN KEY (ParentCategoryID) REFERENCES Categories(CategoryID) ON DELETE SET NULL
);

-- --- 4. Products Table ---
CREATE TABLE Products (
    ProductID INT PRIMARY KEY AUTO_INCREMENT,
    ProductName VARCHAR(255) NOT NULL,
    Description TEXT,
    Price DECIMAL(10, 2) NOT NULL,
    StockQuantity INT NOT NULL DEFAULT 0,
    CategoryID INT NOT NULL,
    CreatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID) ON DELETE RESTRICT,
    INDEX idx_product_name (ProductName),
    CONSTRAINT chk_price CHECK (Price > 0),
    CONSTRAINT chk_stock CHECK (StockQuantity >= 0)
);

-- --- 5. Orders Table ---
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT NOT NULL,
    OrderDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Status ENUM('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled') NOT NULL DEFAULT 'Pending',
    ShippingAddressID INT NOT NULL,
    BillingAddressID INT NOT NULL,
    TotalAmount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE RESTRICT,
    FOREIGN KEY (ShippingAddressID) REFERENCES Addresses(AddressID) ON DELETE RESTRICT,
    FOREIGN KEY (BillingAddressID) REFERENCES Addresses(AddressID) ON DELETE RESTRICT,
    CONSTRAINT chk_total_amount CHECK (TotalAmount >= 0)
);

-- --- 6. Order_Items Table (Junction Table) ---
CREATE TABLE Order_Items (
    OrderItemID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    PriceAtPurchase DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID) ON DELETE RESTRICT,
    UNIQUE KEY uk_order_product (OrderID, ProductID),
    CONSTRAINT chk_quantity CHECK (Quantity > 0)
);

-- --- 7. Payments Table ---
CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT NOT NULL,
    PaymentDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Amount DECIMAL(10, 2) NOT NULL,
    PaymentMethod VARCHAR(50) NOT NULL DEFAULT 'Credit Card',
    Status ENUM('Pending', 'Succeeded', 'Failed') NOT NULL DEFAULT 'Pending',
    TransactionID VARCHAR(255),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE RESTRICT
);