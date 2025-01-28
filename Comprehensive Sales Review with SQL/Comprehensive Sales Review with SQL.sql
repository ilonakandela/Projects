-- What is the range of order dates?
SELECT 
    MIN([OrderDate]) AS min_date, 
    MAX([OrderDate]) AS max_date
FROM [dbo].[Orders];



-- Which products had the lowest profit margins in 2020, and how do their revenues and costs compare?
WITH calc_quantity AS (
    SELECT 
        p.ProductID, 
        SUM(t.Quantity) AS total_quantity,
        ROUND(p.ProductPrice, 0) AS price, 
        ROUND(p.ProductCost, 0) AS cost
    FROM [dbo].[Products] p 
		JOIN [dbo].[Transactions] t ON p.ProductID = t.ProductID
		JOIN [dbo].[Orders] o ON t.OrderNumber = o.OrderNumber
    WHERE 
        o.OrderDate >= '2020-01-01' 
        AND o.OrderDate < '2021-01-01'
    GROUP BY 
        p.ProductID, 
        p.ProductPrice, 
        p.ProductCost
),
price_cost AS (
    SELECT 
        *,
        total_quantity * price AS revenue,
        total_quantity * cost AS total_cost
    FROM calc_quantity
)
SELECT 
    *,
    ROUND(revenue - total_cost, 0) AS profit,
    ROUND(
		CASE WHEN revenue > 0 THEN (revenue - total_cost) / revenue * 100
        ELSE 0 
    END, 0) AS profit_margin
FROM price_cost
ORDER BY profit_margin;



-- What is the total profit for each product category in the years 2016-2020, and how has it evolved over time?
SELECT 
	ProductCategory,
	ROUND(SUM(CASE WHEN YEAR(o.OrderDate) = 2016 THEN (t.Quantity * p.ProductPrice) - (t.Quantity * p.ProductCost) ELSE 0 END), 0) AS profit_2016,
	ROUND(SUM(CASE WHEN YEAR(o.OrderDate) = 2017 THEN (t.Quantity * p.ProductPrice) - (t.Quantity * p.ProductCost) ELSE 0 END), 0) AS profit_2017,
	ROUND(SUM(CASE WHEN YEAR(o.OrderDate) = 2018 THEN (t.Quantity * p.ProductPrice) - (t.Quantity * p.ProductCost) ELSE 0 END), 0) AS profit_2018,
	ROUND(SUM(CASE WHEN YEAR(o.OrderDate) = 2019 THEN (t.Quantity * p.ProductPrice) - (t.Quantity * p.ProductCost) ELSE 0 END), 0) AS profit_2019,
	ROUND(SUM(CASE WHEN YEAR(o.OrderDate) = 2020 THEN (t.Quantity * p.ProductPrice) - (t.Quantity * p.ProductCost) ELSE 0 END), 0) AS profit_2020
FROM 
    [dbo].[Categories] c
	JOIN [dbo].[Subcategories] sc ON c.ProductCategoryID = sc.ProductCategoryID
	JOIN [dbo].[Products] p ON sc.ProductSubcategoryID = p.ProductSubcategoryID
	JOIN [dbo].[Transactions] t ON p.ProductID = t.ProductID
	JOIN [dbo].[Orders] o ON t.OrderNumber = o.OrderNumber
WHERE YEAR(o.OrderDate) < 2021
GROUP BY ProductCategory
ORDER BY ProductCategory;



-- What is the comparison of the monthly number of orders between 2019 and 2020?
SELECT 
	MONTH(OrderDate) AS month,
	SUM(CASE WHEN YEAR(OrderDate) = 2019 THEN 1 ELSE 0 END) AS order_2019,
    SUM(CASE WHEN YEAR(OrderDate) = 2020 THEN 1 ELSE 0 END) AS order_2020
FROM [dbo].[Orders] o 
	JOIN [dbo].[Transactions] t ON o.OrderNumber = t.OrderNumber
GROUP BY MONTH(OrderDate)
ORDER BY month;



-- What is the distribution of profit per square meter for physical stores during 2020?
WITH profit_store AS (
	SELECT 
		s.StoreID,
		StoreSqMeters,
		StoreState,
		Country,
		ROUND(SUM(t.Quantity * p.ProductPrice), 0) AS profit
	FROM [dbo].[Stores] s
		JOIN [dbo].[Orders] o ON s.StoreID = o.StoreID
		JOIN [dbo].[Transactions] t ON o.OrderNumber = t.OrderNumber
		JOIN [dbo].[Products] p ON t.ProductID = p.ProductID
		JOIN [dbo].[Countries] c ON s.CountryId = c.CountryId
	WHERE 
		o.OrderDate >= '2020-01-01' 
		AND o.OrderDate < '2021-01-01'
	GROUP BY s.StoreID, StoreSqMeters, StoreState, Country
)
SELECT *,
	CASE 
		WHEN StoreSqMeters > 0 THEN ROUND(profit / StoreSqMeters , 0)
		ELSE NULL
	END AS profit_per_sqm,
	CASE
		WHEN StoreSqMeters = 0 THEN 'online'
		ELSE 'physical'
	END AS store_type
FROM profit_store
ORDER BY profit_per_sqm DESC;



-- What are the most frequently purchased product pairs?
WITH product_pairs AS (
    SELECT 
        t1.ProductID AS ProductA,
        t2.ProductID AS ProductB,
        COUNT(DISTINCT t1.OrderNumber) AS pair_count
    FROM [dbo].[Transactions] t1
    INNER JOIN [dbo].[Transactions] t2 
        ON t1.OrderNumber = t2.OrderNumber 
        AND t1.ProductID < t2.ProductID 
    GROUP BY t1.ProductID, t2.ProductID
),
total_orders AS (
    SELECT COUNT(DISTINCT OrderNumber) AS total_orders
    FROM [dbo].[Transactions]
)
SELECT 
    pp.ProductA,
    pp.ProductB,
    pp.pair_count
FROM product_pairs pp
	CROSS JOIN total_orders
ORDER BY pp.pair_count DESC;



-- What is the cumulative revenue percentage for each brand, and how does it contribute to the overall total revenue for the year 2020?
WITH brand_rev AS (
	SELECT 
		ProductBrand,
		ROUND(SUM(t.Quantity * p.ProductPrice), 0) as revenue
	FROM [dbo].[Brands] b 
		JOIN [dbo].[Products] p ON b.BrandID = p.BrandID
		JOIN [dbo].[Transactions] t ON p.ProductID = t.ProductID
		JOIN [dbo].[Orders] o ON t.OrderNumber = o.OrderNumber
	WHERE o.OrderDate >= '2020-01-01' 
		AND o.OrderDate < '2021-01-01'
	GROUP BY ProductBrand
),
cum_tol_rev AS (
	SELECT *,
		SUM(revenue) OVER (ORDER BY revenue DESC) AS cumulative_revenue,
		SUM(revenue) OVER () AS total_revenue
	FROM brand_rev
)
SELECT *,
	ROUND((cumulative_revenue / total_revenue) * 100, 0) AS cumulative_percentage
FROM cum_tol_rev
ORDER BY cumulative_percentage;



-- What is the total number of customers who made only one order and the number of customers who made more than one order during the given period?
WITH firt_order AS (
	SELECT 
		CustomerID,
		ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS order_rank
	FROM [dbo].[Orders]
)
SELECT 
	COUNT(CASE WHEN order_rank = 1 THEN 1 END) AS one_order,
	COUNT(CASE WHEN order_rank > 1 THEN 1 END) AS more_than_one_order
FROM firt_order;



-- What is the monthly sales change percentage for online store after 2019, compared to the previous month?
WITH prev_sales AS (
	SELECT 
		c.Country AS online_shop,
		YEAR(o.OrderDate) AS order_year,
		MONTH(o.OrderDate) AS order_month,
		SUM(t.Quantity) AS monthly_sales,
		LAG(SUM(t.Quantity)) OVER (PARTITION BY c.Country ORDER BY YEAR(o.OrderDate), MONTH(o.OrderDate)) AS previous_month_sales
	FROM [dbo].[Stores] s 
		JOIN [dbo].[Countries] c ON s.CountryID = c.CountryID
		JOIN [dbo].[Orders] o ON s.StoreID = o.StoreID
		JOIN [dbo].[Transactions] t ON o.OrderNumber = t.OrderNumber
	WHERE YEAR(o.OrderDate) > 2019
	GROUP BY 
		c.Country, 
		YEAR(o.OrderDate), 
		MONTH(o.OrderDate)
),
sales_change AS (
	SELECT *,
		CASE
			WHEN previous_month_sales IS NOT NULL THEN (monthly_sales - previous_month_sales)
			ELSE NULL
		END AS sales_change
	FROM prev_sales
	WHERE online_shop = 'Online'
)
SELECT *,
	ROUND(CAST(sales_change AS FLOAT) / previous_month_sales, 4) AS sales_change_percentage
FROM sales_change;



-- What are the top three most popular product categories in each country based on the total sales in 2020?
WITH orders_cat AS (
	SELECT 
		c.Country AS country,
		cat.ProductCategory AS category,
		COUNT(t.TransactionID) AS total_sales
	FROM [dbo].[Countries] c 
		JOIN [dbo].[Stores] s ON c.CountryId = s.CountryId
		JOIN [dbo].[Orders] o ON s.StoreID = o.StoreID
		JOIN [dbo].[Transactions] t ON o.OrderNumber = t.OrderNumber
		JOIN [dbo].[Products] p ON t.ProductID = p.ProductID
		JOIN [dbo].[Subcategories] sc ON p.ProductSubcategoryID = sc.ProductSubcategoryID
		JOIN [dbo].[Categories] cat ON sc.ProductCategoryID = cat.ProductCategoryID
	WHERE o.OrderDate >= '2020-01-01' 
	GROUP BY c.Country, cat.ProductCategory
)
SELECT *
FROM (
	SELECT 
		*,
		ROW_NUMBER() OVER(PARTITION BY country ORDER BY total_sales DESC) AS popular_category
	FROM orders_cat
) AS ranked
WHERE popular_category < 4;



-- What is the top-performing brand in terms of revenue for each product category from 2020 onwards?
WITH revenue_cat AS (
	SELECT 
		c.ProductCategory AS category,
		b.ProductBrand AS brand,
		ROUND(SUM(t.Quantity * p.ProductPrice), 0) AS revenue
	FROM [dbo].[Brands] b 
		JOIN [dbo].[Products] p ON b.BrandID = p.BrandID
		JOIN [dbo].[Subcategories] sc ON p.ProductSubcategoryID = sc.ProductSubcategoryID
		JOIN [dbo].[Categories] c ON sc.ProductCategoryID = c.ProductCategoryID
		JOIN [dbo].[Transactions] t ON p.ProductID = t.ProductID
		JOIN [dbo].[Orders] o ON t.OrderNumber = o.OrderNumber
	WHERE o.OrderDate >= '2020-01-01' 
	GROUP BY c.ProductCategory, b.ProductBrand
),
brand_order AS (
	SELECT *,
		ROW_NUMBER() OVER (PARTITION BY category ORDER BY revenue DESC) AS brand_rank
	FROM revenue_cat
)
SELECT *
FROM brand_order
WHERE brand_rank = 1
ORDER BY revenue DESC;