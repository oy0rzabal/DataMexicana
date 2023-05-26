-- ********************************************************************
-- Crear query que ingeste los datos de customers provenientes de la tabla test.rawdata a la tabla de bi_data.customers
-- Las queries obtienen el mismo resultado, por lo que podemos decir que un customer siempre tien un mismo segmento
SELECT COUNT(*) FROM (
SELECT DISTINCT Customer_ID, Customer_Name, Segment
FROM test.rawdata) AS Customers;
SELECT  COUNT(DISTINCT Customer_ID) AS Customers
FROM test.rawdata;
-- seguimos con las querys para obtener los datos faltantes para la tabla de bi_data.customers que se obtendran de la union de
-- las tablas test.rawdata y test.data_customers
WITH Customers AS (
    SELECT Customer_ID, Customer_Name, Segment, ROW_NUMBER() over (ORDER BY Customer_ID) AS Customer_ID2
    FROM test.rawdata
    GROUP BY Customer_ID, Customer_Name, Segment)

SELECT Customer_ID, Customer_Name, Segment, email, gender, CONCAT(country, ' ', city, ' ', state, '', address) AS cust_address, phone
FROM Customers C
INNER JOIN test.data_customers DC
ON C.Customer_ID2 = DC.id;
-- crear la query para ingestar los datos a la tabla de bi_data.customers
INSERT INTO bi_data.customers (cust_id, cust_name, cust_seg, cust_email, cust_gender, cust_address, cust_phone)
SELECT Customer_ID, Customer_Name, Segment, email, gender, CONCAT(country, ' ', city, ' ', state, '', address) AS cust_address, phone
FROM (
    SELECT Customer_ID, Customer_Name, Segment, ROW_NUMBER() over (ORDER BY Customer_ID) AS Customer_ID2
    FROM test.rawdata
    GROUP BY Customer_ID, Customer_Name, Segment) AS C
INNER JOIN test.data_customers DC
ON C.Customer_ID2 = DC.id;
-- verificar que los datos se hayan ingresado correctamente
SELECT * FROM bi_data.customers;



-- ********************************************************************
-- Crear query que consulte los datos de orders provenientes de la tabla test.rawdata
SELECT DISTINCT Sub_Category, Category
FROM test.rawdata;
-- Crear query que ingeste los datos de orders provenientes de la tabla test.rawdata a la tabla de bi_data.sub_categories
INSERT INTO bi_data.sub_categories (sub_category_name, category )
SELECT DISTINCT Sub_Category, Category
FROM test.rawdata;
-- verificar que los datos se hayan ingresado correctamente
SELECT * FROM bi_data.sub_categories;

-- ********************************************************************
-- Validar que el numero de productos sea el mismo que en la tabla de test.rawdata 1862
SELECT  COUNT(Product_ID) AS Products
FROM (
SELECT Product_ID , sub_category_id, MAX(Product_Name) AS Product_Name, MAX(ROUND(Profit/Quantity, 2)) AS Profit, Max(ROUND(((Sales / (1.0 - Discount)) / Quantity), 2)) AS Precio
FROM test.rawdata AS R
JOIN bi_data.sub_categories AS SC ON R.Sub_Category = SC.sub_category_name
GROUP BY Product_ID, sub_category_id) AS P;
SELECT COUNT(DISTINCT Product_ID) AS Products
FROM test.rawdata;
-- Crear query que ingeste los datos de products provenientes de la tabla test.rawdata a la tabla de bi_data.products
INSERT INTO bi_data.products (prod_id, sub_category_id, prod_name, prod_profit, prod_price)
SELECT Product_ID , sub_category_id, MAX(Product_Name) AS Product_Name, MAX(ROUND(Profit/Quantity, 2)) AS Profit, Max(ROUND(((Sales / (1.0 - Discount)) / Quantity), 2)) AS Precio
FROM test.rawdata AS R
JOIN bi_data.sub_categories AS SC ON R.Sub_Category = SC.sub_category_name
GROUP BY Product_ID, sub_category_id;
-- verificar que los datos se hayan ingresado correctamente
SELECT * FROM bi_data.products;

-- ********************************************************************
-- Crear query que ingeste los datos de ship_modes provenientes de la tabla test.rawdata a la tabla de bi_data.ship_modes
INSERT INTO bi_data.ship_modes (ship_mode_name)
SELECT DISTINCT Ship_Mode
FROM test.rawdata;
-- verificar que los datos se hayan ingresado correctamente
SELECT * FROM bi_data.ship_modes;

-- ********************************************************************
-- Query para crear la tabla en test.centers_data
/*
CREATE TABLE test.centers_data (
    manager VARCHAR(255),
    region VARCHAR(255)
);
*/
-- La tabla se ha cargado por el sistema de datagrip
-- pueden generar sus propios scripts para cargar los datos
-- o utilizar el sistema de mysql workbench
-- ingestamos los datos de la tabla de test.centers_data a bi_data.dist_center
INSERT INTO bi_data.dist_center(dc_name, dc_manager)
SELECT DISTINCT region, manager
FROM test.centers_data;
-- verificar que los datos se hayan ingresado correctamente
SELECT * FROM bi_data.dist_center;

-- ********************************************************************
-- Crear query que ingeste los datos de orders provenientes de la tabla test.rawdata a la tabla de bi_data.orders
-- Se identifica 2 Order_ID que tienen diferentes customer_id para la entrega esto esta mal
-- se debe analizar el problema y corregirlo, por lo pronto no se ingestaran estos numeros de orden
SELECT *
FROM (
SELECT Order_ID, Order_Date, ROUND(SUM(Sales), 2) AS Sales, Customer_ID
FROM test.rawdata
GROUP BY Order_ID, Order_Date, Customer_ID) AS O
WHERE Order_ID IN ('CA-2021-121465', 'CA-2022-130494');
-- Crear query que ingeste los datos de orders provenientes de la tabla test.rawdata a la tabla de bi_data.orders
INSERT INTO bi_data.orders (order_id, order_date, sales, cust_id)
SELECT Order_ID, Order_Date, ROUND(SUM(Sales), 2) AS Sales, Customer_ID
FROM test.rawdata
WHERE Order_ID NOT IN ('CA-2021-121465', 'CA-2022-130494')
GROUP BY Order_ID, Order_Date, Customer_ID;
-- verificar que los datos se hayan ingresado correctamente
SELECT * FROM bi_data.orders;

-- ********************************************************************
-- Crear query que ingeste los datos de order_details provenientes de la tabla test.rawdata a la tabla de bi_data.order_details
INSERT INTO bi_data.orders_details (order_id, order_quantity, order_discount, prod_id)
SELECT Order_ID, Quantity, Discount, Product_ID
FROM test.rawdata
WHERE Order_ID NOT IN ('CA-2021-121465', 'CA-2022-130494');
-- verificar que los datos se hayan ingresado correctamente
SELECT * FROM bi_data.orders_details;

-- ********************************************************************
-- Crear query que ingeste los datos de ships provenientes de la tabla test.rawdata a la tabla de bi_data.ships
INSERT INTO bi_data.ships (order_id, ship_date, ship_region, ship_city, ship_state_province, ship_pc, ship_mode_id, dc_id)
SELECT DISTINCT Order_ID, Ship_Date, Region, City, State_Province, Postal_Code, SM.ship_mode_id, DC.dc_id
FROM rawdata AS R
LEFT JOIN bi_data.ship_modes AS SM ON R.Ship_Mode = SM.ship_mode_name
LEFT JOIN bi_data.dist_center AS DC ON R.Region = DC.dc_name
WHERE Order_ID NOT IN ('CA-2021-121465', 'CA-2022-130494');
-- verificar que los datos se hayan ingresado correctamente
SELECT * FROM bi_data.ships;

TRUNCATE TABLE bi_data.ships;





