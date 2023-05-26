##
create database clientes;

CREATE TABLE clientes.usuarios(
	user_id INT PRIMARY KEY AUTO_INCREMENT,
	nombre VARCHAR(50),
	telefono nvarchar(10) INT);

INSert to clientes.usuarios values('00032', 'jorge', 8231738293)

SELECT * FROM usuarios;