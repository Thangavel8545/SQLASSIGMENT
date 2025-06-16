--task 1
-- db
CREATE DATABASE TechShop;
USE TechShop;

-- customers
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Email NVARCHAR(100),
    Phone NVARCHAR(20),
    Address NVARCHAR(100)
);

-- products
CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY,
    ProductName NVARCHAR(100),
    Description NVARCHAR(255),
    Price DECIMAL(10, 2)
);

-- orders
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY,
    CustomerID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10, 2),
    Status NVARCHAR(20),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- orderdetails
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY IDENTITY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- inventory
CREATE TABLE Inventory (
    InventoryID INT PRIMARY KEY IDENTITY,
    ProductID INT,
    QuantityInStock INT,
    LastStockUpdate DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- customer data
INSERT INTO Customers (FirstName, LastName, Email, Phone, Address) VALUES
('Amit', 'Kumar', 'amit.kumar@example.com', '9876543210', 'Delhi'),
('Priya', 'Sharma', 'priya.sharma@example.com', '9123456780', 'Mumbai'),
('Raj', 'Verma', 'raj.verma@example.com', '9012345678', 'Chennai'),
('Sneha', 'Iyer', 'sneha.iyer@example.com', '9988776655', 'Bangalore'),
('Vikas', 'Mehra', 'vikas.mehra@example.com', '8877665544', 'Pune'),
('Neha', 'Agarwal', 'neha.agarwal@example.com', '9786543210', 'Kolkata'),
('Ravi', 'Patel', 'ravi.patel@example.com', '9871234567', 'Ahmedabad'),
('Deepa', 'Reddy', 'deepa.reddy@example.com', '9765432109', 'Hyderabad'),
('Anil', 'Joshi', 'anil.joshi@example.com', '9654321078', 'Jaipur'),
('Meena', 'Singh', 'meena.singh@example.com', '9345678901', 'Lucknow');

-- product data
INSERT INTO Products (ProductName, Description, Price) VALUES
('Mobile', '4G smartphone', 15000),
('Laptop', 'i5 8GB RAM', 45000),
('Tablet', '10 inch screen', 18000),
('Earbuds', 'Wireless earbuds', 2500),
('Mouse', 'USB mouse', 400),
('Keyboard', 'Standard keyboard', 900),
('Smart Watch', 'With fitness tracking', 5000),
('DSLR Camera', 'Nikon DSLR', 60000),
('Bluetooth Speaker', 'Portable speaker', 1800),
('Monitor', '24 inch LED', 11000);

-- order data
INSERT INTO Orders (CustomerID, OrderDate, TotalAmount, Status) VALUES
(1, '2024-06-01', 60000, 'Delivered'),
(2, '2024-06-02', 15000, 'Shipped'),
(3, '2024-06-03', 18000, 'Processing'),
(4, '2024-06-04', 2500, 'Delivered'),
(5, '2024-06-05', 5000, 'Cancelled'),
(6, '2024-06-06', 11000, 'Pending'),
(7, '2024-06-07', 1800, 'Delivered'),
(8, '2024-06-08', 45000, 'Shipped'),
(9, '2024-06-09', 900, 'Processing'),
(10, '2024-06-10', 400, 'Shipped');

-- orderdetails
INSERT INTO OrderDetails (OrderID, ProductID, Quantity) VALUES
(1, 2, 1),
(2, 1, 1),
(3, 3, 1),
(4, 4, 1),
(5, 7, 1),
(6, 10, 1),
(7, 9, 1),
(8, 8, 1),
(9, 6, 1),
(10, 5, 1);

-- inventory
INSERT INTO Inventory (ProductID, QuantityInStock, LastStockUpdate) VALUES
(1, 100, '2024-05-10'),
(2, 50, '2024-05-10'),
(3, 70, '2024-05-10'),
(4, 90, '2024-05-10'),
(5, 150, '2024-05-10'),
(6, 140, '2024-05-10'),
(7, 80, '2024-05-10'),
(8, 20, '2024-05-10'),
(9, 60, '2024-05-10'),
(10, 30, '2024-05-10');
--task 2
-- 1. customer names and emails
SELECT FirstName, Email FROM Customers;

-- 2. orders with names
SELECT o.OrderID, o.OrderDate, c.FirstName, c.LastName
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID;

-- 3. insert customer
INSERT INTO Customers (FirstName, LastName, Email, Phone, Address)
VALUES ('Karan', 'Desai', 'karan.desai@example.com', '9001122334', 'Nagpur');

-- 4. increase prices
UPDATE Products
SET Price = Price * 1.10;

-- 5. delete order
DECLARE @OrderID INT = 5;
DELETE FROM OrderDetails WHERE OrderID = @OrderID;
DELETE FROM Orders WHERE OrderID = @OrderID;

-- 6. new order
INSERT INTO Orders (CustomerID, OrderDate, TotalAmount, Status)
VALUES (3, GETDATE(), 20000, 'Pending');

-- 7. update contact
UPDATE Customers
SET Email = 'priya.updated@example.com', Address = 'Andheri, Mumbai'
WHERE CustomerID = 2;

-- 8. recalculate total
UPDATE Orders
SET TotalAmount = (
    SELECT SUM(od.Quantity * p.Price)
    FROM OrderDetails od
    JOIN Products p ON od.ProductID = p.ProductID
    WHERE od.OrderID = Orders.OrderID
);

-- 9. delete by customer
DECLARE @CustomerID INT = 4;
DELETE FROM OrderDetails WHERE OrderID IN (
    SELECT OrderID FROM Orders WHERE CustomerID = @CustomerID
);
DELETE FROM Orders WHERE CustomerID = @CustomerID;

-- 10. add product
INSERT INTO Products (ProductName, Description, Price)
VALUES ('Power Bank', '10000mAh fast charge', 1200);

-- 11. update status
UPDATE Orders SET Status = 'Delivered' WHERE OrderID = 3;

-- 12. count orders
ALTER TABLE Customers ADD  OrderCount INT ;

UPDATE Customers
SET OrderCount = (
    SELECT COUNT(*) FROM Orders WHERE CustomerID = Customers.CustomerID
);


--task 3

-- 1. orders with customer
SELECT o.OrderID, o.OrderDate, c.FirstName, c.LastName
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID;

-- 2. revenue by product
SELECT p.ProductName, SUM(od.Quantity * p.Price) AS TotalRevenue
FROM OrderDetails od
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY p.ProductName;

-- 3. customers who purchased
SELECT DISTINCT c.FirstName, c.LastName, c.Email, c.Phone
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID;

-- 4. most popular product
SELECT TOP 1 p.ProductName, SUM(od.Quantity) AS TotalQty
FROM OrderDetails od
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY TotalQty DESC;

-- 6. avg order value
SELECT c.FirstName, c.LastName, AVG(o.TotalAmount) AS AvgValue
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.FirstName, c.LastName;

-- 7. highest revenue order
SELECT TOP 1 o.OrderID, c.FirstName, c.LastName, o.TotalAmount
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
ORDER BY o.TotalAmount DESC;

-- 8. product order count
SELECT p.ProductName, COUNT(*) AS OrderCount
FROM OrderDetails od
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY p.ProductName;

-- 9. customers by product name
DECLARE @Product NVARCHAR(50) = 'Laptop';
SELECT DISTINCT c.FirstName, c.LastName, c.Email
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
WHERE p.ProductName = @Product;

-- 10. revenue between dates
DECLARE @FromDate DATE = '2024-06-01';
DECLARE @ToDate DATE = '2024-06-30';
SELECT SUM(o.TotalAmount) AS TotalRevenue
FROM Orders o
WHERE o.OrderDate BETWEEN @FromDate AND @ToDate;

-- task 4

-- 1. customers with no orders
SELECT FirstName, LastName
FROM Customers
WHERE CustomerID NOT IN (
    SELECT DISTINCT CustomerID FROM Orders
);

-- 2. total products
SELECT COUNT(*) AS TotalProducts FROM Products;

-- 3. total revenue
SELECT SUM(TotalAmount) AS TotalRevenue FROM Orders;

-- 5. revenue by customer

SELECT SUM(o.TotalAmount) AS CustomerRevenue
FROM Orders o
WHERE o.CustomerID = 3;

-- 6. top order customers
SELECT TOP 1 c.FirstName, c.LastName, COUNT(o.OrderID) AS OrderCount
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.FirstName, c.LastName
ORDER BY OrderCount DESC;

-- 8. customer with highest spend
SELECT TOP 1 c.FirstName, c.LastName, SUM(o.TotalAmount) AS TotalSpent
FROM Customers c
JOIN Orders o ON c.CustomerID = c.CustomerID
GROUP BY c.FirstName, c.LastName
ORDER BY TotalSpent DESC;

-- 9. avg order value for all
SELECT AVG(TotalAmount) AS AvgOrderValue FROM Orders;

-- 10. order count by customer
SELECT c.FirstName, c.LastName, COUNT(o.OrderID) AS OrderCount
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.FirstName, c.LastName;
