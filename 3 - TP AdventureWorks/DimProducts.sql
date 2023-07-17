SELECT
 product.ProductID,
 product.Name AS ProductName,
 product.ProductNumber,
 product.ListPrice,
 productcategory.Name AS CategoryName,
 productsubcategory.Name AS SubcategoryName
 
 FROM adventureworks2017.product
 
 LEFT JOIN adventureworks2017.productsubcategory ON product.ProductSubcategoryID = productsubcategory.ProductSubcategoryID
 LEFT JOIN adventureworks2017.productcategory ON productsubcategory.ProductCategoryID = productcategory.ProductCategoryID