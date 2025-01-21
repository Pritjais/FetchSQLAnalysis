-- Closed-ended Question 1: Top 5 brands by receipts scanned among users 21 and over
-- Assumption: User age is calculated using the birth date and current date.
SELECT
    p.BRAND,
    COUNT(t.RECEIPT_ID) AS receipts_scanned
FROM
    TRANSACTION_TAKEHOME t
JOIN
    PRODUCTS_TAKEHOME p
ON
    t.BARCODE = p.BARCODE
JOIN
    USER_TAKEHOME u
ON
    t.USER_ID = u.ID
WHERE
    TIMESTAMPDIFF(YEAR, u.BIRTH_DATE, CURDATE()) >= 21
GROUP BY
    p.BRAND
ORDER BY
    receipts_scanned DESC
LIMIT 5;

-- Open-ended Question 1: Identify Fetch’s power users
-- Assumption: Power users are defined as users with the highest number of transactions.
SELECT
    t.USER_ID,
    COUNT(t.RECEIPT_ID) AS total_transactions
FROM
    TRANSACTION_TAKEHOME t
GROUP BY
    t.USER_ID
ORDER BY
    total_transactions DESC
LIMIT 10;

-- Closed-ended Question 2: Percentage of sales in Health & Wellness by generation
-- Assumption: Generations are derived from birth year ranges (e.g., Millennials: 1981-1996).
SELECT
    CASE
        WHEN YEAR(u.BIRTH_DATE) BETWEEN 1981 AND 1996 THEN 'Millennials'
        WHEN YEAR(u.BIRTH_DATE) BETWEEN 1965 AND 1980 THEN 'Gen X'
        WHEN YEAR(u.BIRTH_DATE) <= 1964 THEN 'Boomers'
        ELSE 'Gen Z'
    END AS generation,
    SUM(CAST(t.FINAL_SALE AS DECIMAL(10,2))) AS total_sales,
    ROUND(
        100 * SUM(CASE WHEN p.CATEGORY_1 = 'Health & Wellness' THEN CAST(t.FINAL_SALE AS DECIMAL(10,2)) ELSE 0 END)
        / SUM(CAST(t.FINAL_SALE AS DECIMAL(10,2))),
        2
    ) AS health_wellness_percentage
FROM
    TRANSACTION_TAKEHOME t
JOIN
    PRODUCTS_TAKEHOME p
ON
    t.BARCODE = p.BARCODE
JOIN
    USER_TAKEHOME u
ON
    t.USER_ID = u.ID
GROUP BY
    generation
ORDER BY
    total_sales DESC;
