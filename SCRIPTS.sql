SELECT * FROM Orders O INNER JOIN [Order Details] OD on O.OrderID = OD.OrderID inner join Products P on OD.ProductID = P.ProductID INNER JOIN Categories C on C.CategoryID = P.CategoryID
INNER JOIN Employees E on E.EmployeeID = O.EmployeeID INNER JOIN Customers CU on CU.CustomerID = O.CustomerID;

-- Clientes con mayor gasto:

SELECT TOP 5
    C.CustomerID,
    C.CompanyName,
    SUM(OD.Quantity * OD.UnitPrice) AS TotalSpent
FROM
    Orders O
    INNER JOIN Customers C ON O.CustomerID = C.CustomerID
    INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
GROUP BY
    C.CustomerID,
    C.CompanyName
ORDER BY
    SUM(OD.Quantity * OD.UnitPrice) DESC;
    
    
-- Empleado con más ventas:

SELECT TOP 1
    E.EmployeeID,
    CONCAT(E.FirstName, ' ', E.LastName) AS EmployeeName,
    SUM(OD.Quantity * OD.UnitPrice) AS TotalSales
FROM
    Orders O
    INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
    INNER JOIN Employees E ON O.EmployeeID = E.EmployeeID
GROUP BY
    E.EmployeeID,
    E.FirstName,
    E.LastName
ORDER BY
    SUM(OD.Quantity * OD.UnitPrice) DESC;
    
-- Total de ventas por categoría:

SELECT
    C.CategoryName,
    SUM(OD.Quantity * OD.UnitPrice) AS TotalSales
FROM
    Orders O
    INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
    INNER JOIN Products P ON OD.ProductID = P.ProductID
    INNER JOIN Categories C ON P.CategoryID = C.CategoryID
GROUP BY
    C.CategoryName
ORDER BY
    SUM(OD.Quantity * OD.UnitPrice) DESC;
    
    
-- Clientes con más órdenes:

SELECT TOP 5
    C.CustomerID,
    C.CompanyName,
    COUNT(*) AS OrderCount
FROM
    Orders O
    INNER JOIN Customers C ON O.CustomerID = C.CustomerID
GROUP BY
    C.CustomerID,
    C.CompanyName
ORDER BY
    COUNT(*) DESC;
    
    
-- Producto más vendido:

SELECT TOP 1
    P.ProductName,
    SUM(OD.Quantity) AS TotalQuantity
FROM
    Orders O
    INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
    INNER JOIN Products P ON OD.ProductID = P.ProductID
GROUP BY
    P.ProductName
ORDER BY
    SUM(OD.Quantity) DESC;
    
    
-- Resumen de ventas por mes:

SELECT
    YEAR(OrderDate) AS Year,
    MONTH(OrderDate) AS Month,
    SUM(TotalSales) AS TotalSales
FROM
    Orders
GROUP BY
    YEAR(OrderDate),
    MONTH(OrderDate)
ORDER BY
    YEAR(OrderDate),
    MONTH(OrderDate);
