#Tabla Productos

SELECT Product_ID,Product_Name, Category, Sub_Category
FROM test.rawdata;

#Creacion de la DB Productos
CREATE DATABASE Productos;


#Creacion de la tabla Ventas
CREATE TABLE Productos.product( 
    Product_ID INT PRIMARY KEY AUTO_INCREMENT,
    Product_Name VARCHAR(120) NOT NULL,
    Category VARCHAR(120) NOT NULL,
    Sub_Category VARCHAR(120) NOT NULL
);


#Ahora vamos a unir la informacion con ambas tablas
INSERT INTO Productos.product(Product_ID,Product_Name, Category, Sub_Category)
SELECT DISTINCT Product_ID,Product_Name, Category, Sub_Category
FROM test.rawdata;

SELECT * FROM product;

#Empezaremos con la limpieza de las tablas:
SELECT Product_Name, Category, Sub_Category, COUNT(*)
FROM product
GROUP BY Product_Name, Category, Sub_Category
HAVING COUNT(*) > 1;

#-----------------------------------------------------------------------------------------------------------------------#
#Tabla Clientes
SELECT Customer_ID,Customer_Name , Country_Region, City, State_Province, Postal_code, Segment
FROM test.rawdata;

#Creacion de la DB Clientes
CREATE DATABASE Clientes;


#Creacion de la tabla Ventas
CREATE TABLE Clientes.clientes(
    Customer_ID INT PRIMARY KEY AUTO_INCREMENT,
    Customer_Name VARCHAR(120) NOT NULL,
    Country_Region VARCHAR(120) NOT NULL,
    City VARCHAR(120) NOT NULL,
    State_Province VARCHAR(120) NOT NULL,
    Postal_code VARCHAR(120) NOT NULL,
    Segment VARCHAR(120) NOT NULL
);


#Ahora vamos a unir la informacion con ambas tablas
INSERT INTO Clientes.clientes(Customer_ID, Country_Region, City, State_Province, Postal_code,Customer_Name, Segment)
SELECT DISTINCT Customer_ID, Country_Region, City, State_Province, Postal_code,Customer_Name, Segment
FROM test.rawdata;

SELECT * FROM clientes;

SELECT Customer_ID, Country_Region, City, State_Province, Postal_code,Customer_Name, Segment, COUNT(*)
FROM clientes
GROUP BY Customer_ID, Country_Region, City, State_Province, Postal_code,Customer_Name, Segment
HAVING COUNT(*) > 1;
#-----------------------------------------------------------------------------------------------------------------------#

#Tabla Envios
SELECT Ship_Mode, Ship_Date, Order_ID#Poner Ship_Id como identificador
FROM test.rawdata;

#Creacion de la DB Envios
CREATE DATABASE Envios;

	
DROP TABLE envios;

#Creacion de la tabla Ventas
CREATE TABLE Envios.envios( 
    Ship_ID INT PRIMARY KEY AUTO_INCREMENT,
    Order_ID VARCHAR(120) NOT NULL,
    Ship_Mode VARCHAR(120) NOT NULL,
    Ship_Date DATE
);


DROP DATABASE bi_data;

#Ahora vamos a unir la informacion con ambas tablas
INSERT INTO Envios.envios(Ship_Mode, Ship_Date, Order_ID)
SELECT DISTINCT Ship_Mode, Ship_Date, Order_ID
FROM test.rawdata;

SELECT * FROM envios;

SELECT Ship_Mode, Ship_Date, Order_ID, COUNT(*)
FROM envios
GROUP BY Ship_Mode, Ship_Date, Order_ID
HAVING COUNT(*) > 1;

#-----------------------------------------------------------------------------------------------------------------------#
SELECT Order_Date, Sales, Quantity, Discount FROM data;

#Creacion de la DB VENTAS
CREATE DATABASE Ventas;


#Creacion de la tabla Ventas
CREATE TABLE Ventas.sales(
    Sales_ID INT PRIMARY KEY AUTO_INCREMENT,
    Order_Date DATE,
    Sales VARCHAR(120) NOT NULL,
    Quantity VARCHAR(120) NOT NULL , 
    Discount VARCHAR(120) NOT NULL
);


#Ahora vamos a unir la informacion con ambas tablas
INSERT INTO Ventas.sales(Order_Date,Sales, Quantity, Discount)
SELECT DISTINCT Order_Date,Sales, Quantity, Discount
FROM test.rawdata;

SELECT * FROM sales;


#Conteo de la tabla con fehca, venta, cantidad y descuento.
SELECT Order_Date,Sales, Quantity, Discount, COUNT(*)
FROM sales


SELECT Order_Date,Sales, Quantity, Discount,
ROUND(AVG(Discount), 4)
FROM sales
GROUP BY Order_Date,Sales, Quantity, Discount
having COUNT(*) >0 ;


#Cantidad de Ordenes realizadas junto con las ventas
SELECT Order_Date,Sales, COUNT(*)
FROM rawdata
GROUP BY Order_Date, Sales
HAVING COUNT(*) > 1;

#Conteo de fecha de orden, cantidad y venta
SELECT  Order_date,Quantity,Sales, COUNT(*) 
FROM rawdata
GROUP BY Quantity, Sales
HAVING COUNT(*) > 1;


SELECT * FROM `Clientes`;