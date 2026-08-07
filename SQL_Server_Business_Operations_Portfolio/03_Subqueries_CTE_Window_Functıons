/* =============================================================
   03 - SUBQUERIES, CTE AND WINDOW FUNCTIONS
   Subquery, EXISTS, derived table, CTE, OVER, PARTITION BY,
   ROW_NUMBER, RANK ve kümülatif toplam
   ============================================================= */

-- İş Sorusu 1:
-- Ortalama satış fiyatının üzerindeki sipariş kalemlerini getir.
SELECT
    ol.order_line_id,
    ol.order_id,
    ol.product_id,
    ol.unit_price
FROM portfolio.OrderLines ol
WHERE ol.unit_price > (
    SELECT AVG(unit_price)
    FROM portfolio.OrderLines
)
ORDER BY
    ol.unit_price DESC;


-- İş Sorusu 2:
-- Hiç ödeme kaydı olmayan siparişleri getir.
SELECT
    o.order_id,
    o.customer_id,
    o.order_status
FROM portfolio.OrderHeaders o
WHERE NOT EXISTS (
    SELECT 1
    FROM portfolio.Payments p
    WHERE p.order_id = o.order_id
)
ORDER BY
    o.order_id;


-- İş Sorusu 3:
-- En az bir kez satılmış ürünleri getir.
SELECT
    p.product_id,
    p.product_name,
    p.category
FROM portfolio.Products p
WHERE EXISTS (
    SELECT 1
    FROM portfolio.OrderLines ol
    WHERE ol.product_id = p.product_id
)
ORDER BY
    p.product_id;


-- İş Sorusu 4:
-- Elektronik kategorisinden ürün içeren siparişleri getir.
SELECT
    o.order_id,
    o.customer_id,
    o.order_status
FROM portfolio.OrderHeaders o
WHERE o.order_id IN (
    SELECT ol.order_id
    FROM portfolio.OrderLines ol
    WHERE ol.product_id IN (
        SELECT p.product_id
        FROM portfolio.Products p
        WHERE p.category = N'Elektronik'
    )
)
ORDER BY
    o.order_id;


-- İş Sorusu 5:
-- Toplam net harcaması 5.000 TL'den yüksek müşterileri getir.
SELECT
    customer_totals.customer_id,
    customer_totals.customer_name,
    customer_totals.total_revenue
FROM (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(
            ol.quantity * ol.unit_price * (1 - ol.discount_rate / 100.0)
        ) AS total_revenue
    FROM portfolio.Customers c
    JOIN portfolio.OrderHeaders o
        ON c.customer_id = o.customer_id
    JOIN portfolio.OrderLines ol
        ON o.order_id = ol.order_id
    WHERE o.order_status <> N'İptal'
    GROUP BY
        c.customer_id,
        c.customer_name
) AS customer_totals
WHERE customer_totals.total_revenue > 5000
ORDER BY
    customer_totals.total_revenue DESC;


-- İş Sorusu 6:
-- Her siparişin satış toplamı ile ödeme toplamını güvenli şekilde karşılaştır.
-- Satış ve ödeme önce ayrı ayrı gruplanır; böylece çoklu satırlar birbirini çoğaltmaz.
WITH order_sales AS (
    SELECT
        order_id,
        SUM(
            quantity * unit_price * (1 - discount_rate / 100.0)
        ) AS sales_amount
    FROM portfolio.OrderLines
    GROUP BY
        order_id
),
order_payments AS (
    SELECT
        order_id,
        SUM(payment_amount) AS payment_amount
    FROM portfolio.Payments
    GROUP BY
        order_id
)
SELECT
    o.order_id,
    o.order_status,
    os.sales_amount,
    op.payment_amount,
    COALESCE(op.payment_amount, 0) - COALESCE(os.sales_amount, 0) AS amount_difference,
    CASE
        WHEN os.order_id IS NULL THEN N'Sipariş Kalemi Yok'
        WHEN op.order_id IS NULL THEN N'Ödeme Yok'
        WHEN ABS(op.payment_amount - os.sales_amount) < 0.01 THEN N'Eşleşiyor'
        ELSE N'Tutar Farkı Var'
    END AS reconciliation_status
FROM portfolio.OrderHeaders o
LEFT JOIN order_sales os
    ON o.order_id = os.order_id
LEFT JOIN order_payments op
    ON o.order_id = op.order_id
ORDER BY
    o.order_id;


-- İş Sorusu 7:
-- Her kategoride en yüksek net geliri getiren tek ürünü bul.
WITH product_revenue AS (
    SELECT
        COALESCE(NULLIF(LTRIM(RTRIM(p.category)), N''), N'Kategori Girilmemiş') AS category,
        p.product_id,
        p.product_name,
        SUM(
            ol.quantity * ol.unit_price * (1 - ol.discount_rate / 100.0)
        ) AS total_revenue
    FROM portfolio.Products p
    JOIN portfolio.OrderLines ol
        ON p.product_id = ol.product_id
    JOIN portfolio.OrderHeaders o
        ON ol.order_id = o.order_id
    WHERE o.order_status <> N'İptal'
    GROUP BY
        COALESCE(NULLIF(LTRIM(RTRIM(p.category)), N''), N'Kategori Girilmemiş'),
        p.product_id,
        p.product_name
),
ranked_products AS (
    SELECT
        category,
        product_id,
        product_name,
        total_revenue,
        ROW_NUMBER() OVER (
            PARTITION BY category
            ORDER BY total_revenue DESC, product_id ASC
        ) AS category_rank
    FROM product_revenue
)
SELECT
    category,
    product_id,
    product_name,
    total_revenue,
    category_rank
FROM ranked_products
WHERE category_rank = 1
ORDER BY
    total_revenue DESC;


-- İş Sorusu 8:
-- Müşterileri kendi şehirleri içinde harcamaya göre sırala.
WITH customer_revenue AS (
    SELECT
        c.customer_id,
        c.customer_name,
        c.city,
        SUM(
            ol.quantity * ol.unit_price * (1 - ol.discount_rate / 100.0)
        ) AS total_revenue
    FROM portfolio.Customers c
    JOIN portfolio.OrderHeaders o
        ON c.customer_id = o.customer_id
    JOIN portfolio.OrderLines ol
        ON o.order_id = ol.order_id
    WHERE o.order_status <> N'İptal'
    GROUP BY
        c.customer_id,
        c.customer_name,
        c.city
)
SELECT
    customer_id,
    customer_name,
    city,
    total_revenue,
    RANK() OVER (
        PARTITION BY city
        ORDER BY total_revenue DESC
    ) AS city_revenue_rank
FROM customer_revenue
ORDER BY
    city,
    city_revenue_rank,
    customer_id;


-- İş Sorusu 9:
-- Sipariş kalemlerini korurken her satırda siparişin toplamını göster.
SELECT
    ol.order_id,
    ol.order_line_id,
    ol.product_id,
    ol.quantity,
    ol.unit_price,
    SUM(
        ol.quantity * ol.unit_price * (1 - ol.discount_rate / 100.0)
    ) OVER (
        PARTITION BY ol.order_id
    ) AS order_total_revenue
FROM portfolio.OrderLines ol
ORDER BY
    ol.order_id,
    ol.order_line_id;


-- İş Sorusu 10:
-- Günlük net geliri ve o güne kadar biriken toplam geliri getir.
WITH daily_revenue AS (
    SELECT
        CAST(o.order_date AS DATE) AS order_day,
        SUM(
            ol.quantity * ol.unit_price * (1 - ol.discount_rate / 100.0)
        ) AS daily_revenue
    FROM portfolio.OrderHeaders o
    JOIN portfolio.OrderLines ol
        ON o.order_id = ol.order_id
    WHERE o.order_status <> N'İptal'
    GROUP BY
        CAST(o.order_date AS DATE)
)
SELECT
    order_day,
    daily_revenue,
    SUM(daily_revenue) OVER (
        ORDER BY order_day
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_revenue
FROM daily_revenue
ORDER BY
    order_day;

