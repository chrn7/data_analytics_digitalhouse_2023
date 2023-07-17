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
LEFT JOIN adventureworks2017.store ON customer.StoreID = store.BusinessEntityID
