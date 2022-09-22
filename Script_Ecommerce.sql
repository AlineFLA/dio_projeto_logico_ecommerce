/****(1)****/
/*======================================================*/
/*Criação do banco de dados para o cenário de E-commerce*/
/*======================================================*/
DROP DATABASE IF EXISTS ECOMMERCE;

CREATE DATABASE IF NOT EXISTS ECOMMERCE;

USE ECOMMERCE;

/*======================================================*/
/*Criação de tabelas do banco ECOMMERCE*/

/*CLIENTES*/
CREATE TABLE IF NOT EXISTS clients
	(
	idClient int auto_increment primary KEY,
	Fname varchar(10),
	Minit char(3),
	Lname varchar(20),
	CPF char(11) not null,
	adress varchar(30),
	constraint unique_cpf_client unique (CPF)
	);
    
ALTER TABLE clients auto_increment=1;

/*PRODUTOS*/
CREATE TABLE IF NOT EXISTS product
	(
	idProduct int auto_increment primary KEY,
	Pname varchar(255),
	classification_kids bool default false,
    category enum ('Eletrônico', 'Vestimenta', 'Brinquedos', 'Alimentos', 'Móveis') not null,
    avaliacao float default 0,
    size varchar(10)
	);

/*PEDIDOS*/
CREATE TABLE IF NOT EXISTS orders
	(
	idOrder int auto_increment primary KEY,
	idOrderClient int,
	orderStatus enum ('Cancelado', 'Confirmado', 'Em processamento') default 'Em processamento',
    orderDescription varchar(255),
    sendvalue float default 10,
    paymentCash bool default false,
	constraint fk_order_client foreign key (idOrderClient) references clients (idClient)
    on update cascade
	);
    
/*PAGAMENTOS*/
CREATE TABLE IF NOT EXISTS payments
	(
	idClient int,
	idPayment int,
	typePaymet enum ('Dinheiro', 'Cartão', 'Dois cartões'),
    orderDescription varchar(255),
    limitAvailable float,
    primary KEY (idClient, idPayment),
	constraint fk_payment_client foreign key (idClient) references clients (idClient)
	);

/*ESTOQUE*/
CREATE TABLE IF NOT EXISTS productStorage
	(
	idprodStorage int auto_increment primary KEY,
	storageLocation varchar(255),
    quantity int default 0
	);

/*FORNECEDOR*/
CREATE TABLE IF NOT EXISTS supplier
	(
	idSupplier int auto_increment primary KEY,
	socialName varchar(255) not null,
    CNPJ char(15) not null,
    contact char(11) not null,
 	constraint unique_supplier unique (CNPJ)
	);

/*VENDEDOR*/
CREATE TABLE IF NOT EXISTS seller
	(
	idSeller int auto_increment primary KEY,
	socialName varchar(255) not null,
	AbstName varchar(255),
    CNPJ char(15) not null,
	CPF char(11),
	location varchar(255),
    contact char(11) not null,
 	constraint unique_cnpj_seller unique (CNPJ),
	constraint unique_cpf_seller unique (CPF)
	);

/*PRODUTOS DO VENDEDOR*/
CREATE TABLE IF NOT EXISTS productSeller
	(
	idPseller int,
	idPproduct int,
	prodQuantity int default 1,
    primary KEY (idPseller, idPproduct),
	constraint fk_product_seller foreign key (idPseller) references seller (idSeller),
	constraint fk_product_product foreign key (idPproduct) references product (idProduct)
	);

/*PRODUTOS DO PEDIDO*/
CREATE TABLE IF NOT EXISTS productOrder
	(
	idPOproduct int,
	idPOorder int,
	poQuantity int default 1,
	poStatus enum ('Disponível', 'Sem Estoque') default 'Sem Estoque',
    primary KEY (idPOproduct, idPOorder),
	constraint fk_productorder_seller foreign key (idPOorder) references orders (idOrder),
	constraint fk_productorder_product foreign key (idPOproduct) references product (idProduct)
	);

/*LOCALIZAÇÃO NO ESTOQUE*/
CREATE TABLE IF NOT EXISTS storageLocation
	(
	idLproduct int,
	idLstorage int,
	location varchar(255),
    primary KEY (idLproduct, idLstorage),
	constraint fk_storage_location_storage foreign key (idLstorage) references productStorage (idprodStorage),
	constraint fk_storage_location_product foreign key (idLproduct) references product (idProduct)
	);

/*PRODUTOS DO FORNECEDOR*/
CREATE TABLE IF NOT EXISTS productsupplier
	(
	idPsSupplier int,
	idPsProduct int,
	quantity int not null,
    primary KEY (idPsSupplier, idPsProduct),
	constraint fk_product_supplier_supplier foreign key (idPsSupplier) references supplier (idSupplier),
	constraint fk_product_supplier_product foreign key (idPsProduct) references product (idProduct)
	);

/*COMANDOS DE CONSULTA DE BANCOS E TABELAS*/
SHOW DATABASES;

USE information_schema;

SHOW TABLES;

DESC REFERENTIAL_CONSTRAINTS;



/****(2)****/
/*======================================================*/
/*Inserindo dados no banco de dados ecommerce*/
/*======================================================*/
use ecommerce;

INSERT INTO clients (Fname, Minit, Lname, CPF, adress)
VALUES	('Maria', 'M', 'Silva', '124356789', 'Rua Flores, 43 - São Gonçalo'),
		('João', 'P', 'Santos', '124356863', 'Rua Hortências, 29 - Itaboraí'),
        ('Pedro', 'A', 'Ferreira', '124356954', 'Rua Alburquerque, 78 - Niterói'),
        ('Mariana', 'M', 'Azevedo', '124356689', 'Rua Alfredo, 549 - Maricá'),
        ('Tadeu', 'R', 'Machado', '124356512', 'Avenida João, 43 - São Gonçalo'),
        ('Vitória', 'S', 'Silva', '124356392', 'Estrada Flores, 100 - Niterói');
SELECT *	FROM clients;


INSERT INTO product	(Pname, classification_kids, category, avaliacao, size)
VALUES	('Fone de ouvido', false, 'Eletrônico', 4, null),
		('Sofá retrátil', false, 'Móveis', 3, null),
        ('Barbie Elsa', true, 'Brinquedos', 5, null),
        ('Casaco de couro', true, 'Vestimenta', 2, null),
        ('Bala Finni', false, 'Alimentos', 5, null),
        ('Mesa Helena', true, 'Móveis', 4, null);
SELECT *	FROM product;


INSERT INTO orders	(idOrderClient, orderStatus, orderDescription, sendvalue, paymentCash)
VALUES	(1, default, 'Compra via aplicativo', null, 1),
        (2, default, 'Compra via web', null, 1),
        (3, 'Confirmado', null, null, 1),
        (4, default, 'Compra via web', 150, 1),
        (5, default, 'Compra via aplicativo', 50, 1);
SELECT *	FROM orders;



INSERT INTO productorder	(idPOproduct, idPOorder, poQuantity, poStatus)
VALUES	(1, 1, 2, null),
		(2, 1, 1, null),
        (3, 2, 2, null),
        (5, 3, 10, null),
        (4, 4, 1, null),
		(3, 5, 1, null);
SELECT *	FROM productorder;


INSERT INTO productstorage(storageLocation, quantity)
VALUES	('Rio de Janeiro', 1000),
		('Rio de Janeiro', 500),
        ('São Paulo', 1000),
        ('São Paul', 600),
        ('São Paulo', 100),
        ('Brasília', 100);
SELECT *	FROM productstorage;


INSERT INTO storagelocation	(idLproduct, idLstorage, location)
VALUES	(1, 2,'RJ'),
		(2, 6,'GO'),
        (3, 3,'SP'),
        (4, 2,'MG');
SELECT *	FROM storagelocation;


INSERT INTO supplier	(socialName, CNPJ, contact)
VALUES	('Almeida e Silva', '12300011236666' , '21926014682'),
		('Casa Bahia', '12300011245555' , '21926021563'),
        ('Associados LDTA', '12300011281111' , '21926035698');
SELECT *	FROM supplier;


INSERT INTO productsupplier (idPsSupplier, idPsProduct, quantity)
VALUES	(1, 1, 500),
		(1, 2, 400),
        (2, 4, 600),
        (3, 3, 5),
        (2, 5, 10);
SELECT *	FROM productsupplier;


INSERT INTO seller (socialName, AbstName, CNPJ, CPF, location, contact)
VALUES	('Tecnoligia SA', null, '1245689870001', null, 'Rio de Janeiro', '2126015687'),
		('João Aguiar', null, '1248974560001', '124568987', 'São Paulo', '31986125894'),
        ('Mundo da Criança', null, '1245614560001', null, 'Rio de Janeiro', '2126354555');
SELECT *	FROM seller;


INSERT INTO productseller (idPseller, idPproduct, prodQuantity)
VALUES	(1, 2, 80),
		(2, 5, 10);
SELECT *	FROM productseller;


INSERT INTO payments (idClient, idPayment, typePaymet, orderDescription, limitAvailable)
VALUES	(1, 2, 'Cartão', null, 500),
		(2, 2, 'Cartão', null, 1000),
		(3, 1, 'Dinheiro', null, 500),
		(4, 3, 'Dois cartões', null, 600),
		(5, 1, 'Dinheiro', null, 300),
		(6, 3, 'Dois cartões', null, 500);
SELECT *	FROM payments;



/****(3)****/
/*======================================================*/
/*Consultando dados do banco ecommerce*/
/*======================================================*/

SHOW DATABASES;

USE ecommerce;
SHOW TABLES;

SELECT *	FROM clients;
SELECT *	FROM orders;
SELECT *	FROM payments;
SELECT *	FROM product;
SELECT *	FROM productorder;
SELECT *	FROM productseller;
SELECT *	FROM productstorage;
SELECT *	FROM productsupplier;
SELECT *	FROM seller;
SELECT *	FROM storagelocation;
SELECT *	FROM supplier;




-- TOTAL DE CLIENTES CADASTRADOS:
SELECT	COUNT(*)	TOTAL_CLIENTES
FROM	clients;

-- TOTAL DE CLIENTES CADASTRADOS QUE POSSUEM PEDIDO:
SELECT	COUNT(DISTINCT T1.idClient)	TOTAL_CLIENTES_COM_PEDIDO
FROM	clients T1
		INNER JOIN	orders T2
				ON	T1.idClient = T2.idOrderClient;

-- LISTA DE CLIENTES E NÚMERO DOS RESPECTIVOS PEDIDOS:
SELECT	CONCAT(T1.Fname, ' ', T1.Minit, ' ', T1.Lname)	AS CLIENTE
		, T2.idOrder									AS NU_PEDIDO
FROM	clients T1
		INNER JOIN	orders T2
				ON	T1.idClient = T2.idOrderClient
ORDER BY 1;

-- LISTA DE CLIENTES COM SEUS PEDIDOS, PRODUTOS E ALGUMAS INFORMAÇÕES:
SELECT	CONCAT(T1.Fname, ' ', T1.Minit, ' ', T1.Lname)	AS CLIENTE
		, T1.CPF										AS CPF
		, T2.idOrder									AS NU_PEDIDO
		, T2.orderStatus								AS STATUS_PEDIDO
		, T4.Pname										AS PRODUTO
		, T4.category									AS CATEGORIA_PRODUTO
		, T3.poQuantity									AS QT_PRODUTO_PEDIDO
FROM	clients T1
		INNER JOIN	orders T2
				ON	T1.idClient = T2.idOrderClient
		INNER JOIN	productOrder T3
				ON	T2.idOrder = T3.idPOorder
		INNER JOIN	product T4
				ON	T3.idPOproduct = T4.idProduct
ORDER BY 1, 3, 5;

-- LISTA DE CLIENTES COM QUANTIDADE TOTAL DE PRODUTOS EM PEDIDOS:
SELECT	CONCAT(T1.Fname, ' ', T1.Minit, ' ', T1.Lname)	AS CLIENTE
		, SUM(T3.poQuantity)							AS TOTAL_QT_PRODUTO
FROM	clients T1
		INNER JOIN	orders T2
				ON	T1.idClient = T2.idOrderClient
		INNER JOIN	productOrder T3
				ON	T2.idOrder = T3.idPOorder
		INNER JOIN	product T4
				ON	T3.idPOproduct = T4.idProduct
GROUP BY	CONCAT(T1.Fname, ' ', T1.Minit, ' ', T1.Lname)
ORDER BY 1;

-- LISTA DE CLIENTES ONDE A QUANTIDADE TOTAL DE PRODUTOS EM PEDIDOS É IGUAL A 1:
SELECT	CONCAT(T1.Fname, ' ', T1.Minit, ' ', T1.Lname)	AS CLIENTE
		, SUM(T3.poQuantity)							AS TOTAL_QT_PRODUTO
FROM	clients T1
		INNER JOIN	orders T2
				ON	T1.idClient = T2.idOrderClient
		INNER JOIN	productOrder T3
				ON	T2.idOrder = T3.idPOorder
		INNER JOIN	product T4
				ON	T3.idPOproduct = T4.idProduct
GROUP BY	CONCAT(T1.Fname, ' ', T1.Minit, ' ', T1.Lname)
HAVING SUM(T3.poQuantity) = 1
ORDER BY 1;
