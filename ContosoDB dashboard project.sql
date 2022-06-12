/*Query for total sales plus total margin of bussiness by year*/
SELECT Year, Total_Revenue, Total_Cost, (Total_Revenue - Total_Cost)/Total_Revenue AS Margin
FROM
(
    SELECT 
    YEAR([FactSales].[DateKey]) AS Year,
    SUM([SalesAmount]) AS Total_Revenue,
    SUM([TotalCost]) AS Total_Cost
    FROM [ContosoRetailDW].[dbo].[FactSales]
    GROUP BY YEAR([FactSales].[DateKey])
) AS AccountingTable
ORDER BY Year ASC;

/*Query for total sales by day. Includes both online and in store*/
SELECT 
CONVERT(date, [DateKey]) AS Date,
ROUND(SUM([SalesAmount]),2) AS Total_sales
FROM [ContosoRetailDW].[dbo].[FactSales]
GROUP BY [DateKey]
ORDER BY Date ASC;

/*Query to find total sales for stores vs online sales by year.*/
SELECT 
Year,
(Total_Revenue - Online_Revenue) AS Store_Revenue,
Online_Revenue
FROM
(
    SELECT 
    [Sales].[DateKey] AS Year,
    ROUND([Sales].[Total_Revenue],2) AS Total_Revenue,
    ROUND([OnlineSales].[Online_Revenue],2) AS Online_Revenue
    FROM
        (
            SELECT 
            YEAR([FactSales].[DateKey]) AS Datekey,
            SUM([SalesAmount]) AS Total_Revenue,
            SUM([TotalCost]) AS Store_Cost
            FROM [ContosoRetailDW].[dbo].[FactSales]
            GROUP BY YEAR([FactSales].[DateKey])
        ) AS Sales
    JOIN 
        (
            SELECT 
            YEAR([FactOnlineSales].[DateKey]) AS DateKey,
            SUM([SalesAmount]) AS Online_Revenue,
            SUM([TotalCost]) AS Online_Cost
            FROM [ContosoRetailDW].[dbo].[FactOnlineSales]
            GROUP BY YEAR([FactOnlineSales].[DateKey])
        ) AS OnlineSales
            ON [Sales].[DateKey] = [OnlineSales].[DateKey]
) AS RevenueTable
ORDER BY Year;

/*Query for sales by location all time.*/
SELECT 
SUM([FactSales].[SalesAmount]) AS SalesAmount,
[DimGeography].[RegionCountryName]
FROM [ContosoRetailDW].[dbo].[FactSales]
JOIN [ContosoRetailDW].[dbo].[DimStore] 
    ON [FactSales].[StoreKey] = [DimStore].[StoreKey]
JOIN [ContosoRetailDW].[dbo].[DimGeography]
    ON [DimGeography].GeographyKey = [DimStore].GeographyKey
GROUP BY [DimGeography].RegionCountryName
ORDER BY [SalesAmount] DESC;
