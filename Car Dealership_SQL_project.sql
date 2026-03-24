CREATE DATABASE car_dealership;

USE car_dealership;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(50),
    phone VARCHAR(15),
    email VARCHAR(100),
    gender VARCHAR(10),
    customer_type VARCHAR(20),
    created_date DATE
);

CREATE TABLE cars (
    car_id INT PRIMARY KEY,
    brand VARCHAR(50),
    model VARCHAR(50),
    year INT,
    price INT,
    fuel_type VARCHAR(20),
    transmission VARCHAR(20),
    color VARCHAR(30),
    stock_status VARCHAR(20),
    branch VARCHAR(50),
    mileage INT,
    discount INT
);

CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    customer_id INT,
    car_id INT,
    sale_date DATE,
    employee_name VARCHAR(100),
    final_price INT,
    payment_method VARCHAR(20),
    booking_amount INT,
    discount_given INT,
    loan_required VARCHAR(5),
    delivery_date DATE,

    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (car_id) REFERENCES cars(car_id)
);

SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE 'E:/It Vedant 2026/Projects/Car_Dealership_datasets/customers.csv'
INTO TABLE customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


LOAD DATA LOCAL INFILE 'E:/It Vedant 2026/Projects/Car_Dealership_datasets/cars.csv'
INTO TABLE cars
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'E:/It Vedant 2026/Projects/Car_Dealership_datasets/sales.csv'
INTO TABLE sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Total number of cars sold by brand
select c.brand, count(*) as Total_cars_sold
From sales s
join cars c 
on s.car_id = c.car_id
group by c.brand
order by total_cars_sold DESC;

-- Monthly revenue 
SELECT DATE_FORMAT(sale_date, '%Y-%m') AS sale_month,
       SUM(final_price) AS monthly_revenue
FROM sales
GROUP BY DATE_FORMAT(sale_date, '%Y-%m')
ORDER BY sale_month;

-- City-wise customers count
SELECT city, COUNT(*) AS total_customers
FROM customers
GROUP BY city
ORDER BY total_customers DESC;

-- Top 5 most sold models
SELECT c.model, COUNT(*) AS times_sold
FROM sales s
JOIN cars c ON s.car_id = c.car_id
GROUP BY c.model
ORDER BY times_sold DESC
LIMIT 5;

-- Unsold cars 
SELECT car_id, brand, model, year, price, branch, stock_status
FROM cars
WHERE stock_status = 'Available';

-- Cars sold with loan vs without loan
SELECT loan_required, COUNT(*) AS total_sales
FROM sales
GROUP BY loan_required;

-- Payment method usage
SELECT payment_method, COUNT(*) AS total_transactions
FROM sales
GROUP BY payment_method
ORDER BY total_transactions DESC;

-- Highest revenue-generating branch
SELECT c.branch, SUM(s.final_price) AS total_revenue
FROM sales s
JOIN cars c ON s.car_id = c.car_id
GROUP BY c.branch
ORDER BY total_revenue DESC;

-- Most Expensive Car Sold per Brand
SELECT c.brand, c.model, s.final_price
FROM sales s
JOIN cars c ON s.car_id = c.car_id
WHERE s.final_price = (
    SELECT MAX(s2.final_price)
    FROM sales s2
    JOIN cars c2 ON s2.car_id = c2.car_id
    WHERE c2.brand = c.brand
);

-- Rank Employees by Revenue
SELECT employee_name,
       SUM(final_price) AS total_revenue,
       RANK() OVER (ORDER BY SUM(final_price) DESC) AS rank_position
FROM sales
GROUP BY employee_name;

-- Highest Sale per Day
SELECT *
FROM (
    SELECT sale_date, final_price,
           ROW_NUMBER() OVER (PARTITION BY sale_date ORDER BY final_price DESC) AS rn
    FROM sales
) t
WHERE rn = 1;


 