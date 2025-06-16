
-- db
CREATE DATABASE CarRentalSystem;

USE CarRentalSystem;


-- vehicle table
CREATE TABLE Vehicle (
    vehicleID INT PRIMARY KEY,
    make NVARCHAR(50),
    model NVARCHAR(50),
    year INT,
    dailyRate DECIMAL(10,2),
    status NVARCHAR(20),
    passengerCapacity INT,
    engineCapacity INT
);

-- customer table
CREATE TABLE Customer (
    customerID INT PRIMARY KEY,
    firstName NVARCHAR(50),
    lastName NVARCHAR(50),
    email NVARCHAR(100),
    phoneNumber NVARCHAR(20)
);

-- lease table
CREATE TABLE Lease (
    leaseID INT PRIMARY KEY,
    vehicleID INT,
    customerID INT,
    startDate DATE,
    endDate DATE,
    type NVARCHAR(20),
    FOREIGN KEY (vehicleID) REFERENCES Vehicle(vehicleID),
    FOREIGN KEY (customerID) REFERENCES Customer(customerID)
);

-- payment table
CREATE TABLE Payment (
    paymentID INT PRIMARY KEY,
    leaseID INT,
    paymentDate DATE,
    amount DECIMAL(10,2),
    FOREIGN KEY (leaseID) REFERENCES Lease(leaseID)
);

-- insert vehicle data
INSERT INTO Vehicle VALUES
(1, 'Toyota', 'Camry', 2022, 50.00, 'available', 4, 1450),
(2, 'Honda', 'Civic', 2023, 45.00, 'available', 7, 1500),
(3, 'Ford', 'Focus', 2022, 48.00, 'notAvailable', 4, 1400),
(4, 'Nissan', 'Altima', 2023, 52.00, 'available', 7, 1200),
(5, 'Chevrolet', 'Malibu', 2022, 47.00, 'available', 4, 1800),
(6, 'Hyundai', 'Sonata', 2023, 49.00, 'notAvailable', 7, 1400),
(7, 'BMW', '3 Series', 2023, 60.00, 'available', 7, 2499),
(8, 'Mercedes', 'C-Class', 2022, 58.00, 'available', 8, 2599),
(9, 'Audi', 'A4', 2022, 55.00, 'notAvailable', 4, 2500),
(10, 'Lexus', 'ES', 2023, 54.00, 'available', 4, 2500);

-- insert customer data
INSERT INTO Customer VALUES
(1, 'John', 'Doe', 'johndoe@example.com', '555-555-5555'),
(2, 'Jane', 'Smith', 'janesmith@example.com', '555-123-4567'),
(3, 'Robert', 'Johnson', 'robert@example.com', '555-789-1234'),
(4, 'Sarah', 'Brown', 'sarah@example.com', '555-456-7890'),
(5, 'David', 'Lee', 'david@example.com', '555-987-6543'),
(6, 'Laura', 'Hall', 'laura@example.com', '555-234-5678'),
(7, 'Michael', 'Davis', 'michael@example.com', '555-876-5432'),
(8, 'Emma', 'Wilson', 'emma@example.com', '555-432-1098'),
(9, 'William', 'Taylor', 'william@example.com', '555-321-6547'),
(10, 'Olivia', 'Adams', 'olivia@example.com', '555-765-4321');

-- insert lease data
INSERT INTO Lease VALUES
(1, 1, 1, '2023-01-01', '2023-01-05', 'Daily'),
(2, 2, 2, '2023-02-15', '2023-02-28', 'Monthly'),
(3, 3, 3, '2023-03-10', '2023-03-15', 'Daily'),
(4, 4, 4, '2023-04-20', '2023-04-30', 'Monthly'),
(5, 5, 5, '2023-05-05', '2023-05-10', 'Daily'),
(6, 4, 3, '2023-06-15', '2023-06-30', 'Monthly'),
(7, 7, 7, '2023-07-01', '2023-07-10', 'Daily'),
(8, 8, 8, '2023-08-12', '2023-08-15', 'Monthly'),
(9, 3, 3, '2023-09-07', '2023-09-10', 'Daily'),
(10, 10, 10, '2023-10-10', '2023-10-31', 'Monthly');

-- insert payment data
INSERT INTO Payment VALUES
(1, 1, '2023-01-03', 200.00),
(2, 2, '2023-02-20', 1000.00),
(3, 3, '2023-03-12', 75.00),
(4, 4, '2023-04-25', 900.00),
(5, 5, '2023-05-07', 60.00),
(6, 6, '2023-06-18', 1200.00),
(7, 7, '2023-07-03', 40.00),
(8, 8, '2023-08-14', 1100.00),
(9, 9, '2023-09-09', 80.00),
(10, 10, '2023-10-25', 1500.00);

-- 1. update rate
UPDATE Vehicle SET dailyRate = 68 WHERE make = 'Mercedes';

-- 2. delete customer data
DECLARE @custID INT = 3;
DELETE FROM Payment WHERE leaseID IN (SELECT leaseID FROM Lease WHERE customerID = @custID);
DELETE FROM Lease WHERE customerID = @custID;
DELETE FROM Customer WHERE customerID = @custID;

-- 3. rename column
EXEC sp_rename 'Payment.paymentDate', 'transactionDate', 'COLUMN';

-- 4. find customer by email
SELECT * FROM Customer WHERE email = 'robert@example.com';

-- 5. active leases
SELECT * FROM Lease WHERE customerID = 3;

-- 6. payments by phone
SELECT p.* FROM Payment p
JOIN Lease l ON p.leaseID = l.leaseID
JOIN Customer c ON l.customerID = c.customerID
WHERE c.phoneNumber = '555-789-1234';

-- 7. avg rate
SELECT AVG(dailyRate) AS AvgRate FROM Vehicle WHERE status = 'available';

-- 8. highest rate
SELECT TOP 1 * FROM Vehicle ORDER BY dailyRate DESC;

-- 9. cars by customer
SELECT * FROM Vehicle v
JOIN Lease l ON v.vehicleID = l.vehicleID
WHERE l.customerID = 10;

-- 10. latest lease
SELECT TOP 1 * FROM Lease ORDER BY endDate DESC;

-- 11. payments in 2023
SELECT * FROM Payment as  P WHERE YEAR(P.paymentDate) = 2023;

-- 12. customers with no payments
SELECT * FROM Customer
WHERE customerID NOT IN (
    SELECT DISTINCT customerID
    FROM Lease
    WHERE leaseID IN (SELECT leaseID FROM Payment)
);

-- 13. car total payments
SELECT v.vehicleID, v.make, v.model, SUM(p.amount) AS TotalPaid
FROM Vehicle v
JOIN Lease l ON v.vehicleID = l.vehicleID
JOIN Payment p ON l.leaseID = p.leaseID
GROUP BY v.vehicleID, v.make, v.model;

-- 14. customer total payments
SELECT c.customerID, c.firstName, c.lastName, SUM(p.amount) AS TotalPaid
FROM Customer c
JOIN Lease l ON c.customerID = l.customerID
JOIN Payment p ON l.leaseID = p.leaseID
GROUP BY c.customerID, c.firstName, c.lastName;

-- 15. car lease details
SELECT l.leaseID, v.make, v.model, l.startDate, l.endDate
FROM Lease l
JOIN Vehicle v ON l.vehicleID = v.vehicleID;

-- 16. active leases info
SELECT l.*, c.firstName, c.lastName, v.make, v.model
FROM Lease l
JOIN Customer c ON l.customerID = c.customerID
JOIN Vehicle v ON l.vehicleID = v.vehicleID
WHERE l.endDate >= GETDATE();

-- 17. top spender
SELECT TOP 1 c.firstName, c.lastName, SUM(p.amount) AS TotalSpent
FROM Customer c
JOIN Lease l ON c.customerID = l.customerID
JOIN Payment p ON l.leaseID = p.leaseID
GROUP BY c.firstName, c.lastName
ORDER BY TotalSpent DESC;

-- 18. cars with leases
SELECT * FROM Vehicle v JOIN Lease l ON v.vehicleID = l.vehicleID;