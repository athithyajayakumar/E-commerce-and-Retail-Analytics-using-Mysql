

create database amazon;
use amazon;
select * from amazon.customers;
select * from amazon.orderdetails;
select * from amazon.orders;
select * from amazon.products;
select * from amazon.reviews;
select * from amazon.suppliers;


-- Task 1 
-- Create an ER diagram for the Amazon Fresh database to understand the relationships between tables (e.g., Customers, Products, Orders).

-- Task 2 
-- Identify the primary keys and foreign keys for each table and describe their relationships.

create table amazon.customers (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(100),
    Age INT,
    Gender VARCHAR(10),
    City VARCHAR(50),
    State VARCHAR(50),
    Country VARCHAR(50),
    SignupDate DATE,
    PrimeMember BOOLEAN
);

create table orderdetails (
    OrderID INT,
    ProductID INT,
    Quantity INT,
    UnitPrice DECIMAL(10,2),
    Discount DECIMAL(10,2),
    PRIMARY KEY (OrderID, ProductID),
    FOREIGN KEY (OrderID) references orders(OrderID),
    FOREIGN KEY (ProductID) references products(ProductID)
);

create table orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    OrderAmount DECIMAL(10,2),
    DeliveryFee DECIMAL(10,2),
    DiscountApplied DECIMAL(10,2),
    Foreign key (CustomerID) references customers(CustomerID)
);

create table products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    SubCategory VARCHAR(50),
    PricePerUnit DECIMAL(10,2),
    StockQuantity INT,
    SupplierID INT,
    FOREIGN KEY (SupplierID) references suppliers(SupplierID)
);

create table reviews (
    ReviewID INT PRIMARY KEY,
    ProductID INT,
    CustomerID INT,
    Rating INT,
    ReviewText VARCHAR(255),
    FOREIGN KEY (ProductID) references products(ProductID),
    FOREIGN KEY (CustomerID) references customers(CustomerID)
);

create table suppliers (
    SupplierID INT PRIMARY KEY,
    SupplierName VARCHAR(100),
    ContactPerson VARCHAR(100),
    Phone VARCHAR(20),
    City VARCHAR(50),
    State VARCHAR(50)
);

-- Task 3: 

-- Retrieve all customers from a specific city. Fetch all products under the "Fruits" category.

select * from amazon.customers where City = "Tinaside";
select * from amazon.products where category ="Fruits";

-- Task 4

--  Write DDL statements to recreate the Customers table with the following constraints:
-- ○ CustomerID as the primary key.
-- Ensure Age cannot be null and must be greater than 18.
-- Add a unique constraint for Name.

create table customerss(
customerID int primary key,Name varchar(100) unique,Age int NOT NULL check(Age>18),
Gender varchar(50),City varchar(50),State varchar(50), Country varchar(50), SignupDate Date, PrimeMember varchar(50));

-- Task 5 :

--  Insert 3 new rows into the Products table using INSERT statements.

INSERT into products(ProductID, ProductName, Category, SubCategory, PricePerUnit, StockQuantity, SupplierID)
VALUES
('2aa28375-c563-41b5-d79d1b95-ecdf-4810', 'However Fruit', 'Fruits', 'Sub-Fruits-1', 207, 290, '0658c953-98c4-4d00-bf29-a98d71d3ba88'),
('aa33-8e2c2e0f4db9-aea0-45e9bd10627d', 'Rule Fruit', 'Fruits', 'Sub-Fruits-4', 111, 26, '455b7097-b656-49b8-9cf2-6209edf45a02'),
('2aa28375-c563-41b5-96e2-31fa53d42cb2', 'We Vegetable', 'Vegetables', 'Sub-Vegetables-1', 887, 296, 'a2ed0ef5-a6c8-4b51-ac6f-4fbfe4aca4cd');

-- Task 6 

-- Update the stock quantity of a product where ProductID matches a specific ID.

update products set StockQuantity = 300 where ProductID = "2aa28375-c563-41b5-d79d1b95-ecdf-4810";

-- Task 7 

-- Delete a supplier from the Suppliers table where their city matches a specific value.

delete from suppliers where City = "Wongberg";

-- Task 8

--  Use SQL constraints to: 

-- Add a CHECK constraint to ensure that ratings in the Reviews table are between 1 and 5.

alter table reviews add constraint chk_rating
check (Rating BETWEEN 1 AND 5);

-- Add a DEFAULT constraint for the PrimeMember column in the Customers table (default value: "No").

alter table customers alter column PrimeMember SET DEFAULT 'No';

-- Task 9

--  Write queries using: 

-- ○ WHERE clause to find orders placed after 2024-01-01.

select * from amazon.orders where OrderDate > "2024-01-01";

--  ○ HAVING clause to list products with average ratings greater than 4.

select ProductID,avg(Rating) from amazon.reviews
group by productID
having avg(Rating) > 4;

-- ○ GROUP BY and ORDER BY clauses to rank products by total sales.

select productID,sum(Quantity * UnitPrice) as total_sales from amazon.orderdetails
group by productID
order by total_sales desc;

-- Task 10 Scenario: 

-- Amazon Fresh wants to identify top customers based on their total spending. We will:

-- 1. Calculate each customer's total spending.

select CustomerID,sum(OrderAmount) as total_spending from amazon.orders
group by CustomerID;

-- 2. Rank customers based on their spending.

select CustomerID,sum(OrderAmount) as total_spending,rank() over (order by sum(OrderAmount) desc) as spending_rank from orders
group by CustomerID;

-- 3. Identify customers who have spent more than ₹5,000.

select CustomerID,sum(OrderAmount) as total_spending from amazon.orders
group by CustomerID
having sum(OrderAmount) > 5000;

-- Task 11: 

-- Use SQL to:

-- ○ Join the Orders and OrderDetails tables to calculate total revenue per order.

select o.OrderID,sum(od.Quantity * od.UnitPrice) as total_revenue from amazon.orders o
join orderdetails od on o.OrderID=od.OrderID
group by OrderID;

-- ○ Identify customers who placed the most orders in a specific time period.

select CustomerID,count(OrderID) as total_orders from amazon.orders
where OrderDate between "2025-01-01" and "2025-01-31"
group by CustomerID
order by total_orders desc limit 5;

-- ○ Find the supplier with the most products in stock.

SELECT SupplierID,SUM(StockQuantity) AS total_units FROM amazon.Products
GROUP BY SupplierID
ORDER BY total_units DESC LIMIT 1;

-- Task 12: 

-- Normalize the Products table to 3NF:

-- ○ Separate product categories and subcategories into a new table.
-- ○ Create foreign keys to maintain relationships.

CREATE TABLE Categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(100),
    subcategory_name VARCHAR(100)
);
INSERT INTO Categories (category_id, category_name, subcategory_name) VALUES
(1, 'Beverages', 'Tea'),
(2, 'Beverages', 'Coffee'),
(3, 'Beverages', 'Juices'),
(4, 'Snacks', 'Chips'),
(5, 'Snacks', 'Cookies'),
(6, 'Dairy', 'Milk'),
(7, 'Dairy', 'Cheese'),
(8, 'Bakery', 'Bread'),
(9, 'Bakery', 'Cakes'),
(10, 'Fruits & Vegetables', 'Fruits'),
(11, 'Fruits & Vegetables', 'Vegetables'),
(12, 'Personal Care', 'Soap'),
(13, 'Personal Care', 'Shampoo'),
(14, 'Household', 'Cleaning Supplies'),
(15, 'Household', 'Laundry Detergent');

CREATE TABLE Products1 (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    price_per_unit DECIMAL(10,2),
    stockquantity INT,
    SupplierID INT,
    category_id INT,
        FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);
INSERT INTO Products1 (ProductID, ProductName, price_per_unit, stockquantity, SupplierID, category_id) VALUES
(101, 'Green Tea Pack', 200.00, 50, 1, 1),
(102, 'Black Coffee Beans', 500.00, 30, 2, 2),
(103, 'Orange Juice', 150.00, 40, 1, 3),
(104, 'Potato Chips', 50.00, 100, 3, 4),
(105, 'Chocolate Cookies', 120.00, 80, 2, 5),
(106, 'Whole Milk', 60.00, 200, 1, 6),
(107, 'Cheddar Cheese', 250.00, 25, 3, 7),
(108, 'Whole Wheat Bread', 80.00, 60, 2, 8),
(109, 'Chocolate Cake', 400.00, 15, 3, 9),
(110, 'Fresh Apples', 100.00, 150, 1, 10),
(111, 'Carrots', 40.00, 120, 2, 11),
(112, 'Bath Soap', 90.00, 100, 3, 12),
(113, 'Herbal Shampoo', 180.00, 50, 1, 13),
(114, 'Floor Cleaner', 150.00, 70, 3, 14),
(115, 'Laundry Detergent', 200.00, 60, 2, 15);

-- Task 13: 

-- Write a subquery to:

-- ○ Identify the top 3 products based on sales revenue.
SELECT ProductID, productname, total_revenue
FROM (
    SELECT 
        p.ProductID,
        p.ProductName,
        SUM(od.Quantity * od.UnitPrice) AS total_revenue
    FROM 
        Products p
    JOIN 
        OrderDetails od ON p.ProductID = od.ProductID
    GROUP BY 
        p.ProductID, p.ProductName
) AS product_revenue
ORDER BY 
    total_revenue DESC
LIMIT 3;

-- ○ Find customers who haven’t placed any orders yet.

SELECT c.CustomerID, c.Name FROM amazon.Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.CustomerID IS NULL;

-- Task 14: 
-- Provide actionable insights:

-- ○ Which cities have the highest concentration of Prime members?

SELECT City, COUNT(*) AS prime_members FROM amazon.customers
WHERE PrimeMember = 'YES'
GROUP BY City
ORDER BY prime_members DESC;

-- ○ What are the top 3 most frequently ordered categories?

SELECT c.category_name, SUM(od.quantity) AS total_quantity FROM Orders o
 JOIN OrderDetails od ON o.OrderID = od.OrderID
 JOIN Products1 p ON od.productid = p.productid
 JOIN Categories c ON p.category_id = c.category_id
 GROUP BY c.category_name
 ORDER BY total_quantity DESC LIMIT 3;
 
 