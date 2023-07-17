SELECT 
	H.SalesOrderID,
	H.OrderDate,
	H.CustomerID,
	D.ProductID,
	H.OnlineOrderFlag,
	D.OrderQty,
	D.UnitPrice,
	D.UnitPriceDiscount,
	D.LineTotal
FROM adw2017.salesorderheader H
INNER JOIN adw2017.salesorderdetail D ON D.SalesOrderID=H.SalesOrderID