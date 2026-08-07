/* =============================================================
   02 - JOINS AND AGGREGATIONS
   INNER JOIN, LEFT JOIN, COUNT, SUM, AVG, MIN, MAX,
   GROUP BY, HAVING ve veri kalite kontrolleri
   ============================================================= */

-- İş Sorusu 1:
-- Siparişleri müşteri adı ve şehir bilgisiyle birlikte göster.
SELECT
    o.order_id,
    o.order_date,
    o.order_status,
    c.customer_id,
    c.customer_name,
    c.city
FROM portfolio.OrderHeaders o
JOIN portfolio.Customers c
    ON o.customer_id = c.customer_id
ORDER BY
    o.order_date DESC;


-- İş Sorusu 2:
-- Satılmayan ürünler dahil tüm ürünlerin satış miktarını göster.
SELECT
    p.product_id,
    p.product_name,
    SUM(COALESCE(ol.quantity, 0)) AS total_quantity_sold
FROM portfolio.Products p
LEFT JOIN portfolio.OrderLines ol
    ON p.product_id = ol.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY
    total_quantity_sold DESC,
    p.product_id;


-- İş Sorusu 3:
-- İptal edilmeyen siparişlerde şehir bazında net ürün gelirini hesapla.
SELECT
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
    c.city
ORDER BY
    total_revenue DESC;


-- İş Sorusu 4:
-- Kategori bazında satılan ürün miktarını ve net geliri getir.
SELECT
    COALESCE(NULLIF(LTRIM(RTRIM(p.category)), N''), N'Kategori Girilmemiş') AS category,
    SUM(ol.quantity) AS total_quantity,
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
    COALESCE(NULLIF(LTRIM(RTRIM(p.category)), N''), N'Kategori Girilmemiş')
ORDER BY
    total_revenue DESC;


-- İş Sorusu 5:
-- Ödeme türü bazında ödeme kaydı sayısını ve toplam tutarı göster.
SELECT
    payment_type,
    COUNT(*) AS payment_record_count,
    SUM(payment_amount) AS total_payment_amount,
    AVG(payment_amount) AS average_payment_amount,
    MIN(payment_amount) AS minimum_payment_amount,
    MAX(payment_amount) AS maximum_payment_amount
FROM portfolio.Payments
GROUP BY
    payment_type
ORDER BY
    total_payment_amount DESC;


-- İş Sorusu 6:
-- Toplam net geliri 5.000 TL'den yüksek kategorileri getir.
SELECT
    COALESCE(NULLIF(LTRIM(RTRIM(p.category)), N''), N'Kategori Girilmemiş') AS category,
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
    COALESCE(NULLIF(LTRIM(RTRIM(p.category)), N''), N'Kategori Girilmemiş')
HAVING
    SUM(
        ol.quantity * ol.unit_price * (1 - ol.discount_rate / 100.0)
    ) > 5000
ORDER BY
    total_revenue DESC;


-- İş Sorusu 7:
-- Her müşterinin toplam sipariş sayısını getir.
-- LEFT JOIN sayesinde hiç sipariş vermeyen müşteri de listede kalır.
SELECT
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS total_order_count
FROM portfolio.Customers c
LEFT JOIN portfolio.OrderHeaders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.customer_name
ORDER BY
    total_order_count DESC,
    c.customer_id;


-- İş Sorusu 8:
-- Aynı e-posta adresinin birden fazla müşteride kullanılıp kullanılmadığını kontrol et.
SELECT
    email,
    COUNT(*) AS duplicate_count
FROM portfolio.Customers
WHERE email IS NOT NULL
GROUP BY
    email
HAVING
    COUNT(*) > 1
ORDER BY
    duplicate_count DESC;


-- İş Sorusu 9:
-- COUNT(*) ile COUNT(category) arasındaki farkı göster.
-- COUNT(*) tüm ürün satırlarını, COUNT(category) ise NULL olmayan kategorileri sayar.
SELECT
    COUNT(*) AS total_product_rows,
    COUNT(category) AS non_null_category_rows,
    COUNT(*) - COUNT(category) AS null_category_rows
FROM portfolio.Products;


-- İş Sorusu 10:
-- Sipariş kalemi bulunmayan siparişleri tespit et.
SELECT
    o.order_id,
    o.customer_id,
    o.order_status
FROM portfolio.OrderHeaders o
LEFT JOIN portfolio.OrderLines ol
    ON o.order_id = ol.order_id
WHERE ol.order_id IS NULL
ORDER BY
    o.order_id;


-- İş Sorusu 11:
-- Sipariş durumlarının dağılımını tek sorguda özetle.
SELECT
    COUNT(*) AS total_orders,
    SUM(CASE WHEN order_status = N'Teslim Edildi' THEN 1 ELSE 0 END) AS delivered_orders,
    SUM(CASE WHEN order_status = N'İptal' THEN 1 ELSE 0 END) AS cancelled_orders,
    SUM(CASE WHEN order_status NOT IN (N'Teslim Edildi', N'İptal') THEN 1 ELSE 0 END) AS open_orders
FROM portfolio.OrderHeaders;

