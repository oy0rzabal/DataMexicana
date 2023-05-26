
#Cuál es el método de envío más rápido y cuál es el más lento?
SELECT COUNT(Ship_Mode)
FROM rawdata;

#¿Cuáles son los días y horas con la mayor cantidad de pedidos realizados?
SELECT *  FROM rawdata;



#Departamento Financiero:
#¿Cuántas ventas se han realizado en total?
SELECT COUNT(DISTINCT Sales) AS sales from rawdata;



#¿Cuál es la cantidad total de productos vendidos?
SELECT
COUNT(DISTINCT Product_ID) AS cantidad_total,
COUNT(Sales)
FROM rawdata;



#¿Cuál es la ganancia total generada por las ventas?
SELECT SUM(Sales) AS ganancias_totales 
FROM rawdata;



#
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


#Echo
#¿Qué porcentaje de los pedidos tienen descuentos? #Falta como sacar el porecentaje
SELECT DISTINCT Order_ID,ROUND(AVG(Discount), 1)  FROM rawdata
WHERE Discount >= '0.1'
GROUP BY Order_ID;



#Echo
#¿Cuál es el descuento promedio en términos de porcentaje y cantidad?
SELECT DISTINCT Quantity,
ROUND(AVG(Discount), 1)
FROM rawdata
GROUP BY `Quantity`;

#Echa
#¿Qué porcentaje de las ventas se realiza en cada categoría de productos?
SELECT DISTINCT Category,
    ROUND (COUNT (Discount))
    FROM rawdata
    GROUP BY Category;

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

#Echo
#¿Cuál es el porcentaje de descuento promedio para cada subcategoría de productos vendidos en la ciudad de "New York"?
SELECT 
City,
Sub_Category,
ROUND(AVG(Discount), 4)
FROM rawdata
WHERE City = 'New York City'
GROUP BY City,Sub_Category;


#producto, subcategori, City = NewYork, Discount


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



#¿Cuál es el total de ganancias obtenidas en cada provincia y en qué porcentaje contribuye cada subcategoría de productos a ese total?
SELECT State_Province, Sub_Category FROM rawdata;


#¿Cuál es la tasa de envío promedio para cada segmento de mercado y categoría de producto?
SELECT Category,Segment,AVG(Ship_Date) 
FROM (
    SELECT Category,Segment,Ship_Date
    FROM rawdata
    GROUP BY Category, Ship_Date
) AS CSS
GROUP BY Category, Segment;
