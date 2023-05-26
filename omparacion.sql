#-------------------------------------------------------------------------------#
#Cuál es el método de envío más rápido y cuál es el más lento?
SELECT COUNT(Ship_Mode)
FROM rawdata;

SELECT *
FROM ship_modes;

#-------------------------------------------------------------------------------#
#¿Cuáles son los días y horas con la mayor cantidad de pedidos realizados?
SELECT *  FROM rawdata;

#-------------------------------------------------------------------------------#
#Departamento Financiero:
#¿Cuántas ventas se han realizado en total?
SELECT DISTINCT `Product_ID`,
COUNT(Sales) from rawdata;

SELECT DISTINCT prod_id, COUNT(prod_price)
FROM products;

#-------------------------------------------------------------------------------#
#¿Cuál es la cantidad total de productos vendidos?
SELECT
COUNT(DISTINCT Product_ID) AS cantidad_total,
COUNT(Sales)
FROM rawdata;

SELECT COUNT(DISTINCT prod_id) AS cantidad_total,
COUNT(prod_price) FROM products;


#-------------------------------------------------------------------------------#
#¿Cuál es la ganancia total generada por las ventas?
SELECT SUM(DISTINCT Sales) AS ganancias_totales 
FROM rawdata;

SELECT SUM(DISTINCT prod_price) as price
FROM products;


#Otras preguntas
####-------------------------------------------------------------------------------####
#¿Cuál es el producto más vendido en términos de ventas y cantidad?
SELECT DISTINCT
    Product_Name,
    MAX(Quantity),
    Sales
FROM (
        SELECT
            Product_Name,
        Quantity,
        Sales
        FROM rawdata
        GROUP BY
            Product_Name,
            Quantity
    ) AS td
GROUP BY Product_Name,Sales;


SELECT MAX(DISTINCT order_quantity), order_id
FROM (SELECT order_quantity, order_id
FROM  orders_details
GROUP BY order_quantity, order_id) as td
GROUP BY order_quantity, order_id;


#-------------------------------------------------------------------------------#
#Echo
#¿Cuál es el segmento de clientes que genera la mayor cantidad de ventas?
SELECT
    `Segment`,
    MAX(Sales)
FROM (
        SELECT
            `Segment`,
            AVG(Sales) AS sales
        FROM rawdata
        GROUP BY
            `Segment`
    ) AS td
GROUP BY `Segment`;


SELECT customer.cust_seg, products.prod_price, MAX(*) as total
FROM customer, products
WHERE customer.id = products.id
GROUP BY customer.cust_seg
HAVING total > 1;

SELECT cust_seg.customer, MAX(prod_price.products) FROM ( SELECT
cust_seg.customer, AVG(prod_price.products) as sales
FROM products
GROUP BY cust_seg) AS td
GROUP BY cust_seg;

#-------------------------------------------------------------------------------#
#Echo
#¿Qué porcentaje de los pedidos tienen descuentos? #Falta como sacar el porecentaje
SELECT DISTINCT Order_ID,ROUND(AVG(Discount), 1)  FROM rawdata
WHERE Discount >= '0.1'
GROUP BY Order_ID;

SELECT DISTINCT order_id, ROUND(AVG(order_discount),1) FROM orders_details
WHERE order_discount >= '0.1'
GROUP BY order_id;

#-------------------------------------------------------------------------------#
#Echo
#¿Cuál es el descuento promedio en términos de porcentaje y cantidad?
SELECT DISTINCT Quantity,
ROUND(AVG(Discount), 1)
FROM rawdata
GROUP BY `Quantity`;

SELECT DISTINCT order_quantity,
ROUND(AVG(order_discount), 1)
FROM orders_details
GROUP BY order_quantity;

#-------------------------------------------------------------------------------#
#Echa
#¿Qué porcentaje de las ventas se realiza en cada categoría de productos?
SELECT DISTINCT Category,
    ROUND (COUNT (Discount))
    FROM rawdata
    GROUP BY Category;

SELECT DISTINCT 

#------------------------------------------------------------------------------------------------------------------------------------------#
#Echo
#¿Cuál es el promedio de ventas diarias para cada categoría de productos en la base de datos?
SELECT
    Category,
    Order_Date,
    AVG(Sales)
FROM (
        SELECT
            Category,
            Order_Date,
            Order_ID,
            SUM(Sales) AS sales
        FROM rawdata
        GROUP BY
            Category,
            Order_Date,
            Order_ID
    ) AS td
GROUP BY Category, Order_Date;

SELECT
Category,
Order_Date,
Order_ID,
SUM(Sales) AS sales
FROM rawdata
GROUP BY Category, Order_Date, Order_ID;

#-------------------------------------------------------------------------------#
#Echo
#¿Cuál es el porcentaje de descuento promedio para cada subcategoría de productos vendidos en la ciudad de "New York"?
SELECT 
City,
Sub_Category,
ROUND(AVG(Discount), 4)
FROM rawdata
WHERE City = 'New York City'
GROUP BY City,Sub_Category;


SELECT 


#producto, subcategori, City = NewYork, Discount

#-------------------------------------------------------------------------------#
#Echo
#¿Cuántas ventas se realizaron por cada cliente en su respectivo segmento de mercado?
WITH CSO AS (
        SELECT
            DISTINCT Customer_ID,
            Segment,
            Order_ID
        FROM rawdata
    )
SELECT Customer_ID,
Segment,
COUNT(`Order_ID`)
from CSO
GROUP BY `Customer_ID`, `Segment`;

#-------------------------------------------------------------------------------#
#¿Cuál es el total de ganancias obtenidas en cada provincia y en qué porcentaje contribuye cada subcategoría de productos a ese total?
SELECT State_Province, Sub_Category FROM rawdata;

#-------------------------------------------------------------------------------#
#¿Cuál es la tasa de envío promedio para cada segmento de mercado y categoría de producto?
SELECT Category,Segment,AVG(Ship_Date) 
FROM (
    SELECT Category,Segment,Ship_Date
    FROM rawdata
    GROUP BY Category, Ship_Date
) AS CSS
GROUP BY Category, Segment;

SELECT users.name, products.name, orders.date
FROM users
JOIN orders ON users.id = orders.user_id
JOIN products ON orders.product_id = products.id
WHERE users.id = 1;

SELECT category.sub_categories, ship_date.ships, cust_seg.customers
FROM sub_categories
JOIN ship_date ON sub_categories.
JOIN cust_seg ON