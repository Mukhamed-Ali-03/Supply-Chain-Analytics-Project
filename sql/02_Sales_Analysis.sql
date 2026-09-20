USE dataco_supply_chain;

-- OVERALL SALES PERFORMANCE
SELECT
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit,
    ROUND(
        SUM(`Order Profit Per Order`)
        / NULLIF(SUM(`Sales`), 0) * 100,
        2
    ) AS profit_margin_percentage,
    COUNT(DISTINCT `Order Id`) AS total_orders,
    COUNT(DISTINCT `Order Customer Id`) AS total_customers,
    ROUND(
        SUM(`Sales`)
        / NULLIF(COUNT(DISTINCT `Order Id`), 0),
        2
    ) AS average_order_value
FROM datacosupplychaindataset;

-- SALES BY ORDER TYPE
SELECT
    `Type` AS order_type,
    COUNT(DISTINCT `Order Id`) AS total_orders,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit,
    ROUND(
        SUM(`Order Profit Per Order`)
        / NULLIF(SUM(`Sales`), 0) * 100,
        2
    ) AS profit_margin_percentage
FROM datacosupplychaindataset
GROUP BY `Type`
ORDER BY total_sales DESC;

-- SALES BY MARKET
SELECT
    `Market`,
    COUNT(DISTINCT `Order Id`) AS total_orders,
    COUNT(DISTINCT `Order Customer Id`) AS total_customers,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit,
    ROUND(
        SUM(`Order Profit Per Order`)
        / NULLIF(SUM(`Sales`), 0) * 100,
        2
    ) AS profit_margin_percentage
FROM datacosupplychaindataset
GROUP BY `Market`
ORDER BY total_sales DESC;

-- MARKET SALES CONTRIBUTION
SELECT
    `Market`,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(
        SUM(`Sales`) * 100.0 /
        (SELECT SUM(`Sales`)
         FROM datacosupplychaindataset),
        2
    ) AS sales_contribution_percentage
FROM datacosupplychaindataset
GROUP BY `Market`
ORDER BY total_sales DESC;

-- SALES BY REGION
SELECT
    `Order Region` AS region,
    COUNT(DISTINCT `Order Id`) AS total_orders,
    COUNT(DISTINCT `Order Customer Id`) AS customers,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit,
    ROUND(
        SUM(`Order Profit Per Order`)
        / NULLIF(SUM(`Sales`), 0) * 100,
        2
    ) AS profit_margin_percentage
FROM datacosupplychaindataset
GROUP BY `Order Region`
ORDER BY total_sales DESC;

-- TOP 10 COUNTRIES BY SALES
SELECT
    `Order Country` AS country,
    COUNT(DISTINCT `Order Id`) AS total_orders,
    COUNT(DISTINCT `Order Customer Id`) AS customers,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit
FROM datacosupplychaindataset
GROUP BY `Order Country`
ORDER BY total_sales DESC
LIMIT 10;

-- TOP 10 COUNTRIES BY PROFIT
SELECT
    `Order Country` AS country,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit,
    ROUND(
        SUM(`Order Profit Per Order`)
        / NULLIF(SUM(`Sales`), 0) * 100,
        2
    ) AS profit_margin_percentage
FROM datacosupplychaindataset
GROUP BY `Order Country`
ORDER BY total_profit DESC
LIMIT 10;

-- SALES BY CUSTOMER SEGMENT
SELECT
    `Customer Segment` AS customer_segment,
    COUNT(DISTINCT `Order Customer Id`) AS customers,
    COUNT(DISTINCT `Order Id`) AS orders,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit,
    ROUND(
        SUM(`Order Profit Per Order`)
        / NULLIF(SUM(`Sales`), 0) * 100,
        2
    ) AS profit_margin_percentage
FROM datacosupplychaindataset
GROUP BY `Customer Segment`
ORDER BY total_sales DESC;

-- CUSTOMER SEGMENT SALES CONTRIBUTION
SELECT
    `Customer Segment` AS customer_segment,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(
        SUM(`Sales`) * 100.0 /
        (SELECT SUM(`Sales`)
         FROM datacosupplychaindataset),
        2
    ) AS sales_contribution_percentage
FROM datacosupplychaindataset
GROUP BY `Customer Segment`
ORDER BY total_sales DESC;

-- MONTHLY SALES TREND
SELECT
    YEAR(`order date (DateOrders)`) AS order_year,
    MONTH(`order date (DateOrders)`) AS order_month,
    DATE_FORMAT(
        `order date (DateOrders)`,
        '%Y-%m'
    ) AS year_month,
    COUNT(DISTINCT `Order Id`) AS total_orders,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit
FROM datacosupplychaindataset
GROUP BY
    YEAR(`order date (DateOrders)`),
    MONTH(`order date (DateOrders)`),
    DATE_FORMAT(
        `order date (DateOrders)`,
        '%Y-%m'
    )
ORDER BY
    order_year,
    order_month;

-- YEARLY SALES PERFORMANCE
SELECT
    YEAR(`order date (DateOrders)`) AS order_year,
    COUNT(DISTINCT `Order Id`) AS total_orders,
    COUNT(DISTINCT `Order Customer Id`) AS customers,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit,
    ROUND(
        SUM(`Order Profit Per Order`)
        / NULLIF(SUM(`Sales`), 0) * 100,
        2
    ) AS profit_margin_percentage
FROM datacosupplychaindataset
GROUP BY YEAR(`order date (DateOrders)`)
ORDER BY order_year;

-- YEAR-OVER-YEAR SALES GROWTH
WITH yearly_sales AS (
    SELECT
        YEAR(`order date (DateOrders)`) AS order_year,
        SUM(`Sales`) AS total_sales
    FROM datacosupplychaindataset
    GROUP BY YEAR(`order date (DateOrders)`)
)
SELECT
    order_year,
    ROUND(total_sales, 2) AS total_sales,
    ROUND(
        LAG(total_sales)
        OVER (ORDER BY order_year),
        2
    ) AS previous_year_sales,
    ROUND(
        (
            total_sales
            - LAG(total_sales)
              OVER (ORDER BY order_year)
        )
        /
        NULLIF(
            LAG(total_sales)
            OVER (ORDER BY order_year),
            0
        ) * 100,
        2
    ) AS yoy_sales_growth_percentage
FROM yearly_sales
ORDER BY order_year;

-- MONTHLY SALES GROWTH
WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(
            `order date (DateOrders)`,
            '%Y-%m'
        ) AS year_month,
        SUM(`Sales`) AS total_sales
    FROM datacosupplychaindataset
    GROUP BY
        DATE_FORMAT(
            `order date (DateOrders)`,
            '%Y-%m'
        )
)
SELECT
    year_month,
    ROUND(total_sales, 2) AS total_sales,
    ROUND(
        LAG(total_sales)
        OVER (ORDER BY year_month),
        2
    ) AS previous_month_sales,
    ROUND(
        (
            total_sales
            - LAG(total_sales)
              OVER (ORDER BY year_month)
        )
        /
        NULLIF(
            LAG(total_sales)
            OVER (ORDER BY year_month),
            0
        ) * 100,
        2
    ) AS mom_sales_growth_percentage
FROM monthly_sales
ORDER BY year_month;

-- QUARTERLY SALES PERFORMANCE
SELECT
    YEAR(`order date (DateOrders)`) AS order_year,
    QUARTER(`order date (DateOrders)`) AS quarter,
    COUNT(DISTINCT `Order Id`) AS total_orders,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit
FROM datacosupplychaindataset
GROUP BY
    YEAR(`order date (DateOrders)`),
    QUARTER(`order date (DateOrders)`)
ORDER BY
    order_year,
    quarter;

-- SALES BY MONTH OF YEAR
SELECT
    MONTH(`order date (DateOrders)`) AS month_number,
    MONTHNAME(`order date (DateOrders)`) AS month_name,
    COUNT(DISTINCT `Order Id`) AS total_orders,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit
FROM datacosupplychaindataset
GROUP BY
    MONTH(`order date (DateOrders)`),
    MONTHNAME(`order date (DateOrders)`)
ORDER BY month_number;

-- TOP 10 CATEGORIES BY SALES
SELECT
    `Category Name` AS category,
    COUNT(DISTINCT `Order Id`) AS total_orders,
    SUM(`Order Item Quantity`) AS quantity_sold,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit
FROM datacosupplychaindataset
GROUP BY `Category Name`
ORDER BY total_sales DESC
LIMIT 10;

-- CATEGORY PROFITABILITY
SELECT
    `Category Name` AS category,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit,
    ROUND(
        SUM(`Order Profit Per Order`)
        / NULLIF(SUM(`Sales`), 0) * 100,
        2
    ) AS profit_margin_percentage
FROM datacosupplychaindataset
GROUP BY `Category Name`
ORDER BY total_profit DESC;

-- SALES VS QUANTITY BY CATEGORY
SELECT
    `Category Name` AS category,
    SUM(`Order Item Quantity`) AS quantity_sold,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(
        SUM(`Sales`)
        / NULLIF(SUM(`Order Item Quantity`), 0),
        2
    ) AS sales_per_unit
FROM datacosupplychaindataset
GROUP BY `Category Name`
ORDER BY total_sales DESC;

-- DISCOUNT ANALYSIS
SELECT
    ROUND(AVG(`Order Item Discount`), 2) AS average_discount,
    ROUND(
        AVG(`Order Item Discount Rate`) * 100,
        2
    ) AS average_discount_rate_percentage,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit
FROM datacosupplychaindataset;

-- DISCOUNT RATE VS PROFITABILITY
SELECT
    CASE
        WHEN `Order Item Discount Rate` = 0
            THEN '0% Discount'
        WHEN `Order Item Discount Rate` <= 0.10
            THEN '1-10% Discount'
        WHEN `Order Item Discount Rate` <= 0.20
            THEN '11-20% Discount'
        WHEN `Order Item Discount Rate` <= 0.30
            THEN '21-30% Discount'
        ELSE '30%+ Discount'
    END AS discount_band,
    COUNT(DISTINCT `Order Id`) AS total_orders,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit,
    ROUND(
        SUM(`Order Profit Per Order`)
        / NULLIF(SUM(`Sales`), 0) * 100,
        2
    ) AS profit_margin_percentage
FROM datacosupplychaindataset
GROUP BY discount_band
ORDER BY total_sales DESC;

-- AVERAGE ORDER VALUE BY MARKET
SELECT
    `Market`,
    COUNT(DISTINCT `Order Id`) AS total_orders,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(
        SUM(`Sales`)
        / NULLIF(COUNT(DISTINCT `Order Id`), 0),
        2
    ) AS average_order_value
FROM datacosupplychaindataset
GROUP BY `Market`
ORDER BY average_order_value DESC;

-- AVERAGE ORDER VALUE BY CUSTOMER SEGMENT
SELECT
    `Customer Segment` AS customer_segment,
    COUNT(DISTINCT `Order Id`) AS total_orders,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(
        SUM(`Sales`)
        / NULLIF(COUNT(DISTINCT `Order Id`), 0),
        2
    ) AS average_order_value
FROM datacosupplychaindataset
GROUP BY `Customer Segment`
ORDER BY average_order_value DESC;

-- PROFITABILITY BY MARKET
SELECT
    `Market`,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit,
    ROUND(
        SUM(`Order Profit Per Order`)
        / NULLIF(SUM(`Sales`), 0) * 100,
        2
    ) AS profit_margin_percentage
FROM datacosupplychaindataset
GROUP BY `Market`
ORDER BY profit_margin_percentage DESC;

-- TOP 10 ORDERS BY SALES
SELECT
    `Order Id`,
    `Order Customer Id`,
    `Market`,
    `Order Region`,
    ROUND(SUM(`Sales`), 2) AS order_sales,
    ROUND(
        SUM(`Order Profit Per Order`),
        2
    ) AS order_profit
FROM datacosupplychaindataset
GROUP BY
    `Order Id`,
    `Order Customer Id`,
    `Market`,
    `Order Region`
ORDER BY order_sales DESC
LIMIT 10;

-- TOP 10 CUSTOMERS BY SALES
SELECT
    `Order Customer Id` AS customer_id,
    COUNT(DISTINCT `Order Id`) AS total_orders,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit
FROM datacosupplychaindataset
GROUP BY `Order Customer Id`
ORDER BY total_sales DESC
LIMIT 10;

-- SALES BY ORDER STATUS
SELECT
    `Order Status`,
    COUNT(DISTINCT `Order Id`) AS total_orders,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit
FROM datacosupplychaindataset
GROUP BY `Order Status`
ORDER BY total_sales DESC;

-- SALES BY SHIPPING MODE
SELECT
    `Shipping Mode`,
    COUNT(DISTINCT `Order Id`) AS total_orders,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit,
    ROUND(
        SUM(`Order Profit Per Order`)
        / NULLIF(SUM(`Sales`), 0) * 100,
        2
    ) AS profit_margin_percentage
FROM datacosupplychaindataset
GROUP BY `Shipping Mode`
ORDER BY total_sales DESC;

-- SALES BY DEPARTMENT
SELECT
    `Department Name` AS department,
    COUNT(DISTINCT `Order Id`) AS total_orders,
    SUM(`Order Item Quantity`) AS quantity_sold,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit
FROM datacosupplychaindataset
GROUP BY `Department Name`
ORDER BY total_sales DESC;

-- SALES BY PRODUCT CATEGORY
SELECT
    `Category Name` AS category,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(
        SUM(`Sales`) * 100.0 /
        (SELECT SUM(`Sales`)
         FROM datacosupplychaindataset),
        2
    ) AS sales_contribution_percentage
FROM datacosupplychaindataset
GROUP BY `Category Name`
ORDER BY total_sales DESC;

-- HIGH SALES + LOW PROFIT MARGIN CATEGORIES
SELECT
    `Category Name` AS category,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit,
    ROUND(
        SUM(`Order Profit Per Order`)
        / NULLIF(SUM(`Sales`), 0) * 100,
        2
    ) AS profit_margin_percentage
FROM datacosupplychaindataset
GROUP BY `Category Name`
HAVING total_sales > 100000
ORDER BY profit_margin_percentage ASC;

-- SALES CONCENTRATION - TOP PRODUCTS
WITH product_sales AS (
    SELECT
        `Product Name`,
        SUM(`Sales`) AS total_sales
    FROM datacosupplychaindataset
    GROUP BY `Product Name`
),
ranked_products AS (
    SELECT
        `Product Name`,
        total_sales,
        RANK() OVER (
            ORDER BY total_sales DESC
        ) AS sales_rank
    FROM product_sales
)
SELECT
    sales_rank,
    `Product Name`,
    ROUND(total_sales, 2) AS total_sales
FROM ranked_products
WHERE sales_rank <= 10
ORDER BY sales_rank;

-- FINAL SALES SUMMARY
SELECT
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(
        SUM(`Order Profit Per Order`),
        2
    ) AS total_profit,
    ROUND(
        SUM(`Order Profit Per Order`)
        / NULLIF(SUM(`Sales`), 0) * 100,
        2
    ) AS profit_margin_percentage,
    COUNT(DISTINCT `Order Id`) AS total_orders,
    COUNT(DISTINCT `Order Customer Id`) AS total_customers,
    ROUND(
        SUM(`Sales`)
        / NULLIF(COUNT(DISTINCT `Order Id`), 0),
        2
    ) AS average_order_value,
    SUM(`Order Item Quantity`) AS quantity_sold
FROM datacosupplychaindataset;