CREATE DATABASE AS1;
USE AS1;
DROP DATABASE AS1;

CREATE TABLE employees (
    id_employee INT PRIMARY KEY,
    name_employee VARCHAR(100),
    work_hours INT,
    level_employee VARCHAR(100)
);

INSERT INTO employees (id_employee, name_employee, work_hours, level_employee)
VALUES
    (1, 'Anna', 40, 'higher'),
    (2, 'Oleh', 35, 'primary'),
    (3, 'Iryna', 30, 'secondary'),
    (4, 'Mykola', 25, 'primary'),
    (5, 'Kateryna', 20, 'higher');

SELECT * FROM employees;
- тиць )



CREATE TABLE flowers (
    id_flower INT PRIMARY KEY,
    name_flower VARCHAR(100),
    count_flower INT,
    times_buy INT
);

INSERT INTO flowers (id_flower, name_flower, count_flower, times_buy)
VALUES
    (1, 'Roses', 500, 46),
    (2, 'Tulips', 130, 78),
    (3, 'Lilies', 20, 6),
    (4, 'Daisies', 178, 43),
    (5, 'Orchids', 15, 56);
   
SELECT * FROM flowers;
- тиць )




CREATE TABLE deliveries (
    id_delivery INT PRIMARY KEY,
    delivery_company VARCHAR(100),
    delivery_times TIME,
    id_flower INT,
    FOREIGN KEY (id_flower) REFERENCES flowers(id_flower)
);

INSERT INTO deliveries (id_delivery, delivery_company, delivery_times, id_flower)
VALUES
    (1, 'DHL', '12:30:00', 1),
    (2, 'FedFlower', '14:00:00', 2),
    (3, 'UPS', '15:30:00', 3),
    (4, 'Nova Flower', '16:00:00', 4),
    (5, 'City Flower', '17:45:00', 5);
   
SELECT * FROM deliveries;
- тиць )

SELECT deliveries.id_delivery, deliveries.delivery_company, deliveries.delivery_times, flowers.name_flower
FROM deliveries
JOIN flowers ON deliveries.id_flower = flowers.id_flower;
- тиць )




CREATE TABLE additions (
    id_additions INT PRIMARY KEY,
    additions_name VARCHAR(100),
    count_additionals INT
);

INSERT INTO additions (id_additions, additions_name, count_additionals)
VALUES
    (1, 'Card', 10),
    (2, 'Gift wrap', 5),
    (3, 'Balloon', 3),
    (4, 'Ribbon', 7),
    (5, 'Chocolate', 2),
    (6, 'Bear', 16),
    (7, 'Cake', 2);
   
SELECT * FROM additions;
- тиць )



CREATE TABLE orders (
    id_order INT PRIMARY KEY,
    name_customer VARCHAR(100),
    price DECIMAL(10),
    id_flower INT,
    order_date DATE,
    adress_order VARCHAR(100),
    FOREIGN KEY (id_flower) REFERENCES flowers(id_flower)
);

INSERT INTO orders (id_order, name_customer, price, id_flower, order_date, adress_order)
VALUES
    (1, 'Nastya S.', 1650, 1, '2024-03-01', 'Kyiv'),
    (2, 'Danya', 670, 1, '2024-03-02', 'Odessa'),
    (3, 'Dana', 1200, 2, '2024-03-03', 'Symu'),
    (4, 'Nika', 5600, 4, '2024-03-04', 'Kyiv'),
    (5, 'Selena', 150, 1, '2024-03-05', 'Odessa'),
    (6, 'Maksim', 700, 4, '2024-03-06', 'Kyiv'),
    (7, 'Shon', 960, 1, '2024-03-07', 'Symu'),
    (8, 'Lesia', 10800, 2, '2024-03-08', 'Kyiv'),
    (9, 'Rada', 8300, 5, '2024-03-09', 'Kyiv'),
    (10, 'Sasha', 2900, 1, '2024-03-10', 'Kyiv'),
    (11, 'Naskya K.', 50, 3, '2024-03-11', 'Symu');


SELECT orders.id_order, orders.name_customer, orders.price, flowers.name_flower, orders.order_date, orders.adress_order
FROM orders
JOIN flowers ON orders.id_flower = flowers.id_flower;
- тиць )



CREATE TABLE order_details (
    id_order INT PRIMARY KEY,
    id_delivery INT,
    id_employee INT,
    id_addition INT,
    FOREIGN KEY (id_order) REFERENCES orders(id_order),
    FOREIGN KEY (id_delivery) REFERENCES deliveries(id_delivery),
    FOREIGN KEY (id_employee) REFERENCES employees(id_employee),
    FOREIGN KEY (id_addition) REFERENCES additions(id_additions)
);

INSERT INTO order_details (id_order, id_delivery, id_employee, id_addition)
VALUES
    (1, 1, 1, 1),
    (2, 2, 2, 2),
    (3, 3, 3, 3),
    (4, 4, 4, 4),
    (5, 5, 5, 5),
    (6, 1, 1, 6),
    (7, 2, 2, 7),
    (8, 3, 3, 1),
    (9, 4, 4, 2),
    (10, 5, 5, 3),
    (11, 1, 1, 4);

SELECT * FROM order_details;
- тиць )   


SELECT 
    od.id_order,
    f.name_flower,
    o.price,
    d.delivery_company,
    e.name_employee,
    e.level_employee,
    a.additions_name
FROM 
    order_details od
JOIN 
    orders o ON od.id_order = o.id_order
JOIN 
    flowers f ON o.id_flower = f.id_flower
JOIN 
    deliveries d ON od.id_delivery = d.id_delivery
JOIN 
    employees e ON od.id_employee = e.id_employee
JOIN 
    additions a ON od.id_addition = a.id_additions;

   
 

   
   
------ ЗАВДАННЯ)))
 
WITH order_summary AS (
    SELECT 
        f.name_flower,
        o.price,
        e.name_employee
    FROM 
        orders o
    JOIN 
        flowers f ON o.id_flower = f.id_flower
    JOIN 
        order_details od ON o.id_order = od.id_order
    JOIN 
        employees e ON od.id_employee = e.id_employee
    WHERE 
        o.price <= 1000

    UNION ALL

    SELECT 
        f.name_flower,
        o.price,
        e.name_employee
    FROM 
        orders o
    JOIN 
        flowers f ON o.id_flower = f.id_flower
    JOIN 
        order_details od ON o.id_order = od.id_order
    JOIN 
        employees e ON od.id_employee = e.id_employee
    WHERE 
        o.price > 1000
)
SELECT
  name_flower,
  COUNT(*) AS total_orders,
  SUM(price) AS total_revenue,
  GROUP_CONCAT(DISTINCT name_employee ORDER BY name_employee SEPARATOR ', ') AS employees_involved
FROM
  order_summary
WHERE
  price > 500
GROUP BY
  name_flower
ORDER BY
  total_revenue DESC;
   
 
 

