-- Comento la línea 2 porque el Schema ya lo habia creado. De lo contrario, habría que incluir la linea 2 al ejecutar el Procedure:
-- CREATE SCHEMA  adwdatawarehouse;

USE adwdatawarehouse;

-- Creamos la vista de la tabla dimensional de Clientes:

DROP VIEW IF EXISTS Dim_Customer;

CREATE VIEW Dim_Customer AS

SELECT 
 customer.CustomerID,
 customer.PersonID,
 person.FirstName,
 person.LastName,
 person.EmailPromotion,
 CASE WHEN ISNULL(store.Name) THEN 'Compra On Line'
                              ELSE store.Name 
                              END AS StoreName
 
FROM adventureworks2017.customer 
LEFT JOIN adventureworks2017.person ON customer.PersonID = person.BusinessEntityID
LEFT JOIN adventureworks2017.store ON customer.StoreID = store.BusinessEntityID;

-- Creamos la vista de la tabla dimensional de Productos:

DROP VIEW IF EXISTS Dim_Product;

CREATE VIEW  Dim_Product AS

SELECT
 product.ProductID,
 product.Name AS ProductName,
 product.ProductNumber,
 product.ListPrice,
 productcategory.Name AS CategoryName,
 productsubcategory.Name AS SubcategoryName
 
 FROM adventureworks2017.product
 
 LEFT JOIN adventureworks2017.productsubcategory ON product.ProductSubcategoryID = productsubcategory.ProductSubcategoryID
 LEFT JOIN adventureworks2017.productcategory ON productsubcategory.ProductCategoryID = productcategory.ProductCategoryID;
 

-- Creamos la vista de la Fact table de Ventas:

DROP VIEW IF EXISTS Fact_Sales;

CREATE VIEW Fact_Sales AS

SELECT
T1.SalesOrderID,
T2.OrderDate,
T2.ShipDate,
T2.CustomerID,
T1.ProductID,
T2.OnlineOrderFlag,
T1.OrderQty,
T1.UnitPrice,
T1.UnitPriceDiscount,
T1.LineTotal,
coalesce(T2.SalesPersonID,0) AS Sales_Person_ID,
YEAR(T2.OrderDate) AS anio,
(T1.UnitPrice * T1.OrderQty) AS Venta_Bruta,
((T1.UnitPrice - T1.UnitPriceDiscount) * T1.OrderQty) AS Venta_Neta,
DATEDIFF(T2.ShipDate, T2.OrderDate) AS demora_envio,
CASE WHEN DATEDIFF(T2.ShipDate, T2.OrderDate) IS NULL THEN 'Sin Enviar'
	ELSE 'Enviado'
    END AS Status_Envio,
CASE WHEN T2.OnlineOrderFlag = 0 THEN 'Tienda'
	ELSE  'Online'
	END AS Canal_de_venta
FROM adventureworks2017.salesorderdetail AS T1 INNER JOIN adventureworks2017.salesorderheader AS T2 
ON  T1.SalesOrderID=T2.SalesOrderID
;
-- LIMIT 10;



-- Creamos la Vista Principal, haciendo join de las 3 anteriores Vistas:

DROP VIEW IF EXISTS view_vistaprincipal;


CREATE VIEW view_vistaprincipal AS

SELECT
	Fact_Sales.*,

-- 	Dim_Customer.CustomerID,
	Dim_Customer.PersonID,
	Dim_Customer.FirstName,
	Dim_Customer.LastName,
	Dim_Customer.EmailPromotion,
	Dim_Customer.StoreName,
 
-- 	Dim_Product.ProductID,
	Dim_Product.ProductName,
	Dim_Product.ProductNumber,
	Dim_Product.ListPrice,
	Dim_Product.CategoryName,
	Dim_Product.SubcategoryName
 
FROM Fact_Sales
LEFT JOIN Dim_Customer ON Fact_Sales.CustomerID = Dim_Customer.CustomerID
LEFT JOIN Dim_Product ON Fact_Sales.ProductID = Dim_Product.ProductID;


