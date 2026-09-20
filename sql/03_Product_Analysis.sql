USE dataco_supply_chain;

-- ОБЩАЯ ИНФОРМАЦИЯ О ТОВАРНОМ АССОРТИМЕНТЕ
SELECT
    COUNT(DISTINCT `Product Card Id`) AS total_products,
    COUNT(DISTINCT `Category Name`) AS total_categories,
    SUM(`Order Item Quantity`) AS total_quantity_sold,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit
FROM datacosupplychaindataset;

-- ОБЗОР ПО КАТЕГОРИЯМ
SELECT
    `Category Name` AS category,
    COUNT(DISTINCT `Product Card Id`) AS products,
    COUNT(DISTINCT `Order Id`) AS orders,
    SUM(`Order Item Quantity`) AS quantity_sold,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit,
    ROUND(SUM(`Order Profit Per Order`) / NULLIF(SUM(`Sales`), 0) * 100, 2) AS profit_margin_percentage
FROM datacosupplychaindataset
GROUP BY `Category Name`
ORDER BY total_sales DESC;

-- ТОП-10 КАТЕГОРИЙ ПО ПРОДАЖАМ
SELECT
    `Category Name` AS category,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    SUM(`Order Item Quantity`) AS quantity_sold,
    COUNT(DISTINCT `Order Id`) AS total_orders
FROM datacosupplychaindataset
GROUP BY `Category Name`
ORDER BY total_sales DESC
LIMIT 10;

-- ТОП-10 КАТЕГОРИЙ ПО ПРИБЫЛИ
SELECT
    `Category Name` AS category,
    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Order Profit Per Order`) / NULLIF(SUM(`Sales`), 0) * 100, 2) AS profit_margin_percentage
FROM datacosupplychaindataset
GROUP BY `Category Name`
ORDER BY total_profit DESC
LIMIT 10;

-- ТОП-10 КАТЕГОРИЙ ПО КОЛИЧЕСТВУ ПРОДАННЫХ ТОВАРОВ
SELECT
    `Category Name` AS category,
    SUM(`Order Item Quantity`) AS quantity_sold,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit
FROM datacosupplychaindataset
GROUP BY `Category Name`
ORDER BY quantity_sold DESC
LIMIT 10;

-- ДОЛЯ КАТЕГОРИЙ В ОБЩИХ ПРОДАЖАХ
SELECT
    `Category Name` AS category,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Sales`) * 100.0 / (SELECT SUM(`Sales`) FROM datacosupplychaindataset), 2) AS sales_contribution_percentage
FROM datacosupplychaindataset
GROUP BY `Category Name`
ORDER BY total_sales DESC;

-- ДОЛЯ КАТЕГОРИЙ В ОБЩЕЙ ПРИБЫЛИ
SELECT
    `Category Name` AS category,
    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit,
    ROUND(SUM(`Order Profit Per Order`) * 100.0 / (SELECT SUM(`Order Profit Per Order`) FROM datacosupplychaindataset), 2) AS profit_contribution_percentage
FROM datacosupplychaindataset
GROUP BY `Category Name`
ORDER BY total_profit DESC;

-- ПРОДАЖИ В РАСЧЁТЕ НА ЕДИНИЦУ ТОВАРА ПО КАТЕГОРИЯМ
SELECT
    `Category Name` AS category,
    SUM(`Order Item Quantity`) AS quantity_sold,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Sales`) / NULLIF(SUM(`Order Item Quantity`), 0), 2) AS sales_per_unit
FROM datacosupplychaindataset
GROUP BY `Category Name`
ORDER BY sales_per_unit DESC;

-- ПРИБЫЛЬ В РАСЧЁТЕ НА ЕДИНИЦУ ТОВАРА ПО КАТЕГОРИЯМ
SELECT
    `Category Name` AS category,
    SUM(`Order Item Quantity`) AS quantity_sold,
    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit,
    ROUND(SUM(`Order Profit Per Order`) / NULLIF(SUM(`Order Item Quantity`), 0), 2) AS profit_per_unit
FROM datacosupplychaindataset
GROUP BY `Category Name`
ORDER BY profit_per_unit DESC;

-- ПОКАЗАТЕЛИ ПО ОТДЕЛЬНЫМ ТОВАРАМ
SELECT
    `Product Card Id` AS product_id,
    `Product Name` AS product_name,
    `Category Name` AS category,
    COUNT(DISTINCT `Order Id`) AS total_orders,
    SUM(`Order Item Quantity`) AS quantity_sold,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit,
    ROUND(SUM(`Order Profit Per Order`) / NULLIF(SUM(`Sales`), 0) * 100, 2) AS profit_margin_percentage
FROM datacosupplychaindataset
GROUP BY
    `Product Card Id`,
    `Product Name`,
    `Category Name`
ORDER BY total_sales DESC;

-- топ-10 товаров по продажам
SELECT
    `Product Card Id` AS product_id,
    `Product Name` AS product_name,
    `Category Name` AS category,
    COUNT(DISTINCT `Order Id`) AS orders,
    SUM(`Order Item Quantity`) AS quantity_sold,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit
FROM datacosupplychaindataset
GROUP BY
    `Product Card Id`,
    `Product Name`,
    `Category Name`
ORDER BY total_sales DESC
LIMIT 10;

-- топ-10 товаров по прибыли
SELECT
    `Product Card Id` AS product_id,
    `Product Name` AS product_name,
    `Category Name` AS category,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit,
    ROUND(SUM(`Order Profit Per Order`) / NULLIF(SUM(`Sales`), 0) * 100, 2) AS profit_margin_percentage
FROM datacosupplychaindataset
GROUP BY
    `Product Card Id`,
    `Product Name`,
    `Category Name`
ORDER BY total_profit DESC
LIMIT 10;

-- топ-10 товаров по количеству продаж
SELECT
    `Product Card Id` AS product_id,
    `Product Name` AS product_name,
    `Category Name` AS category,
    SUM(`Order Item Quantity`) AS quantity_sold,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit
FROM datacosupplychaindataset
GROUP BY
    `Product Card Id`,
    `Product Name`,
    `Category Name`
ORDER BY quantity_sold DESC
LIMIT 10;

-- топ-10 товаров по марже
SELECT
    `Product Card Id` AS product_id,
    `Product Name` AS product_name,
    `Category Name` AS category,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit,
    ROUND(SUM(`Order Profit Per Order`) / NULLIF(SUM(`Sales`), 0) * 100, 2) AS profit_margin_percentage
FROM datacosupplychaindataset
GROUP BY
    `Product Card Id`,
    `Product Name`,
    `Category Name`
HAVING total_sales > 1000
ORDER BY profit_margin_percentage DESC
LIMIT 10;

-- 10 товаров с наименьшими продажами
SELECT
    `Product Card Id` AS product_id,
    `Product Name` AS product_name,
    `Category Name` AS category,
    SUM(`Order Item Quantity`) AS quantity_sold,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit
FROM datacosupplychaindataset
GROUP BY
    `Product Card Id`,
    `Product Name`,
    `Category Name`
ORDER BY total_sales ASC
LIMIT 10;

-- 10 товаров с наименьшей прибылью
SELECT
    `Product Card Id` AS product_id,
    `Product Name` AS product_name,
    `Category Name` AS category,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit,
    ROUND(SUM(`Order Profit Per Order`) / NULLIF(SUM(`Sales`), 0) * 100, 2) AS profit_margin_percentage
FROM datacosupplychaindataset
GROUP BY
    `Product Card Id`,
    `Product Name`,
    `Category Name`
ORDER BY total_profit ASC
LIMIT 10;

-- товары с высокими продажами и низкой маржой
SELECT
    `Product Card Id` AS product_id,
    `Product Name` AS product_name,
    `Category Name` AS category,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit,
    ROUND(SUM(`Order Profit Per Order`) / NULLIF(SUM(`Sales`), 0) * 100, 2) AS profit_margin_percentage
FROM datacosupplychaindataset
GROUP BY
    `Product Card Id`,
    `Product Name`,
    `Category Name`
HAVING total_sales > 50000
ORDER BY profit_margin_percentage ASC;

-- товары с высокими продажами и отрицательной прибылью
SELECT
    `Product Card Id` AS product_id,
    `Product Name` AS product_name,
    `Category Name` AS category,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit
FROM datacosupplychaindataset
GROUP BY
    `Product Card Id`,
    `Product Name`,
    `Category Name`
HAVING
    total_sales > 50000
    AND total_profit < 0
ORDER BY total_sales DESC;

-- анализ цен на товары
SELECT
    `Category Name` AS category,
    ROUND(AVG(`Product Price`), 2) AS average_product_price,
    ROUND(MIN(`Product Price`), 2) AS minimum_product_price,
    ROUND(MAX(`Product Price`), 2) AS maximum_product_price,
    COUNT(DISTINCT `Product Card Id`) AS products
FROM datacosupplychaindataset
GROUP BY `Category Name`
ORDER BY average_product_price DESC;

-- цена товара и продажи
SELECT
    `Product Card Id` AS product_id,
    `Product Name` AS product_name,
    `Category Name` AS category,
    ROUND(AVG(`Product Price`), 2) AS product_price,
    SUM(`Order Item Quantity`) AS quantity_sold,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit
FROM datacosupplychaindataset
GROUP BY
    `Product Card Id`,
    `Product Name`,
    `Category Name`
ORDER BY total_sales DESC
LIMIT 20;

-- скидки по категориям
SELECT
    `Category Name` AS category,
    ROUND(AVG(`Order Item Discount`), 2) AS average_discount,
    ROUND(AVG(`Order Item Discount Rate`) * 100, 2) AS average_discount_rate_percentage,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit,
    ROUND(SUM(`Order Profit Per Order`) / NULLIF(SUM(`Sales`), 0) * 100, 2) AS profit_margin_percentage
FROM datacosupplychaindataset
GROUP BY `Category Name`
ORDER BY average_discount_rate_percentage DESC;

-- рейтинг категорий по показателям
WITH category_performance AS (
    SELECT
        `Category Name` AS category,
        SUM(`Sales`) AS total_sales,
        SUM(`Order Profit Per Order`) AS total_profit
    FROM datacosupplychaindataset
    GROUP BY `Category Name`
)
SELECT
    category,
    ROUND(total_sales, 2) AS total_sales,
    ROUND(total_profit, 2) AS total_profit,
    RANK() OVER (ORDER BY total_sales DESC) AS sales_rank,
    RANK() OVER (ORDER BY total_profit DESC) AS profit_rank
FROM category_performance
ORDER BY sales_rank;

-- рейтинг товаров по продажам
WITH product_performance AS (
    SELECT
        `Product Card Id` AS product_id,
        `Product Name` AS product_name,
        `Category Name` AS category,
        SUM(`Sales`) AS total_sales,
        SUM(`Order Profit Per Order`) AS total_profit
    FROM datacosupplychaindataset
    GROUP BY
        `Product Card Id`,
        `Product Name`,
        `Category Name`
)
SELECT
    product_id,
    product_name,
    category,
    ROUND(total_sales, 2) AS total_sales,
    ROUND(total_profit, 2) AS total_profit,
    RANK() OVER (ORDER BY total_sales DESC) AS sales_rank,
    RANK() OVER (ORDER BY total_profit DESC) AS profit_rank
FROM product_performance
ORDER BY sales_rank;

-- анализ парето / правило 80/20 по товарам
WITH product_sales AS (
    SELECT
        `Product Card Id` AS product_id,
        `Product Name` AS product_name,
        SUM(`Sales`) AS total_sales
    FROM datacosupplychaindataset
    GROUP BY
        `Product Card Id`,
        `Product Name`
),
ranked_products AS (
    SELECT
        product_id,
        product_name,
        total_sales,
        SUM(total_sales) OVER (ORDER BY total_sales DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_sales,
        SUM(total_sales) OVER () AS overall_sales
    FROM product_sales
)
SELECT
    product_id,
    product_name,
    ROUND(total_sales, 2) AS total_sales,
    ROUND(cumulative_sales, 2) AS cumulative_sales,
    ROUND(cumulative_sales / NULLIF(overall_sales, 0) * 100, 2) AS cumulative_sales_percentage
FROM ranked_products
ORDER BY total_sales DESC;
-- количество товаров, необходимое для 80% продаж
WITH product_sales AS (
    SELECT
        `Product Card Id` AS product_id,
        `Product Name` AS product_name,
        SUM(`Sales`) AS total_sales
    FROM datacosupplychaindataset
    GROUP BY
        `Product Card Id`,
        `Product Name`
),
ranked_products AS (
    SELECT
        product_id,
        product_name,
        total_sales,
        SUM(total_sales) OVER (ORDER BY total_sales DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_sales,
        SUM(total_sales) OVER () AS overall_sales
    FROM product_sales
),
pareto AS (
    SELECT
        product_id,
        product_name,
        total_sales,
        cumulative_sales,
        cumulative_sales / NULLIF(overall_sales, 0) * 100 AS cumulative_percentage
    FROM ranked_products
)
SELECT
    COUNT(*) AS products_needed_for_80_percent_sales
FROM pareto
WHERE cumulative_percentage <= 80;

-- вклад топ-товаров в общие продажи
WITH product_sales AS (
    SELECT
        `Product Card Id` AS product_id,
        `Product Name` AS product_name,
        SUM(`Sales`) AS total_sales
    FROM datacosupplychaindataset
    GROUP BY
        `Product Card Id`,
        `Product Name`
),
ranked_products AS (
    SELECT
        product_id,
        product_name,
        total_sales,
        ROW_NUMBER() OVER (ORDER BY total_sales DESC) AS product_rank
    FROM product_sales
)
SELECT
    product_rank,
    product_name,
    ROUND(total_sales, 2) AS total_sales,
    ROUND(total_sales * 100.0 / (SELECT SUM(total_sales) FROM product_sales), 2) AS sales_contribution_percentage
FROM ranked_products
WHERE product_rank <= 10
ORDER BY product_rank;

-- показатели категорий и товаров
SELECT
    `Category Name` AS category,
    `Product Name` AS product_name,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit,
    SUM(`Order Item Quantity`) AS quantity_sold
FROM datacosupplychaindataset
GROUP BY
    `Category Name`,
    `Product Name`
ORDER BY
    category,
    total_sales DESC;

-- лидирующий товар в каждой категории
WITH product_category_sales AS (
    SELECT
        `Category Name` AS category,
        `Product Name` AS product_name,
        SUM(`Sales`) AS total_sales
    FROM datacosupplychaindataset
    GROUP BY
        `Category Name`,
        `Product Name`
),
ranked_products AS (
    SELECT
        category,
        product_name,
        total_sales,
        ROW_NUMBER() OVER (PARTITION BY category ORDER BY total_sales DESC) AS product_rank
    FROM product_category_sales
)
SELECT
    category,
    product_name,
    ROUND(total_sales, 2) AS total_sales
FROM ranked_products
WHERE product_rank = 1
ORDER BY total_sales DESC;

-- сопоставление рейтингов категорий по продажам и прибыли
WITH category_data AS (
    SELECT
        `Category Name` AS category,
        SUM(`Sales`) AS total_sales,
        SUM(`Order Profit Per Order`) AS total_profit
    FROM datacosupplychaindataset
    GROUP BY `Category Name`
)
SELECT
    category,
    ROUND(total_sales, 2) AS total_sales,
    ROUND(total_profit, 2) AS total_profit,
    RANK() OVER (ORDER BY total_sales DESC) AS sales_rank,
    RANK() OVER (ORDER BY total_profit DESC) AS profit_rank,
    sales_rank - profit_rank AS rank_difference
FROM (
    SELECT
        category,
        total_sales,
        total_profit,
        RANK() OVER (ORDER BY total_sales DESC) AS sales_rank,
        RANK() OVER (ORDER BY total_profit DESC) AS profit_rank
    FROM category_data
) ranked
ORDER BY ABS(rank_difference) DESC;

-- классификация товаров по результативности
WITH product_data AS (
    SELECT
        `Product Card Id` AS product_id,
        `Product Name` AS product_name,
        `Category Name` AS category,
        SUM(`Sales`) AS total_sales,
        SUM(`Order Profit Per Order`) AS total_profit
    FROM datacosupplychaindataset
    GROUP BY
        `Product Card Id`,
        `Product Name`,
        `Category Name`
)
SELECT
    product_id,
    product_name,
    category,
    ROUND(total_sales, 2) AS total_sales,
    ROUND(total_profit, 2) AS total_profit,
    ROUND(total_profit / NULLIF(total_sales, 0) * 100, 2) AS profit_margin_percentage,
    CASE
        WHEN total_sales >= 100000 AND total_profit > 0 THEN 'High Sales - Profitable'
        WHEN total_sales >= 100000 AND total_profit <= 0 THEN 'High Sales - Low/Negative Profit'
        WHEN total_sales < 100000 AND total_profit > 0 THEN 'Low Sales - Profitable'
        ELSE 'Low Sales - Low/Negative Profit'
    END AS product_classification
FROM product_data
ORDER BY total_sales DESC;

-- показатели товаров по рынкам
SELECT
    `Market`,
    `Product Name` AS product_name,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit,
    SUM(`Order Item Quantity`) AS quantity_sold
FROM datacosupplychaindataset
GROUP BY
    `Market`,
    `Product Name`
ORDER BY
    `Market`,
    total_sales DESC;

-- итоговая сводка по товарам и категориям
SELECT
    COUNT(DISTINCT `Product Card Id`) AS total_products,
    COUNT(DISTINCT `Category Name`) AS total_categories,
    SUM(`Order Item Quantity`) AS total_quantity_sold,
    ROUND(SUM(`Sales`), 2) AS total_sales,
    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit,
    ROUND(SUM(`Order Profit Per Order`) / NULLIF(SUM(`Sales`), 0) * 100, 2) AS overall_profit_margin
FROM datacosupplychaindataset;
