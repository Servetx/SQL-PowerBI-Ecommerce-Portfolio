/* =============================================================
   01 - BASIC QUERYING
   SELECT, WHERE, ORDER BY, DISTINCT, TOP, LIKE, IN, BETWEEN,
   NULL, tarih ve metin fonksiyonları
   ============================================================= */

-- İş Sorusu 1:
-- Aktif ürünleri fiyatı yüksek olandan başlayarak listele.
SELECT
    product_id,
    product_name,
    category,
    unit_price,
    stock_quantity
FROM portfolio.Products
WHERE is_active = 1
ORDER BY
    unit_price DESC,
    product_id ASC;


-- İş Sorusu 2:
-- Fiyatı en yüksek 5 aktif ürünü getir.
SELECT TOP (5)
    product_id,
    product_name,
    unit_price
FROM portfolio.Products
WHERE is_active = 1
ORDER BY
    unit_price DESC,
    product_id ASC;


-- İş Sorusu 3:
-- Müşterilerin bulunduğu benzersiz şehirleri listele.
SELECT DISTINCT
    city
FROM portfolio.Customers
ORDER BY
    city ASC;


-- İş Sorusu 4:
-- Adında "Klavye" geçen ürünleri bul.
SELECT
    product_id,
    product_name,
    category
FROM portfolio.Products
WHERE product_name LIKE N'%Klavye%';


-- İş Sorusu 5:
-- Teslim edilen veya kargoda olan siparişleri getir.
SELECT
    order_id,
    customer_id,
    order_date,
    order_status
FROM portfolio.OrderHeaders
WHERE order_status IN (N'Teslim Edildi', N'Kargoda')
ORDER BY
    order_date DESC;


-- İş Sorusu 6:
-- Fiyatı 500 ile 2.000 TL arasındaki ürünleri getir.
SELECT
    product_id,
    product_name,
    unit_price
FROM portfolio.Products
WHERE unit_price BETWEEN 500 AND 2000
ORDER BY
    unit_price DESC;


-- İş Sorusu 7:
-- Eksik veya boş kategori bilgisini okunabilir bir etiketle göster.
SELECT
    product_id,
    product_name,
    COALESCE(NULLIF(LTRIM(RTRIM(category)), N''), N'Kategori Girilmemiş') AS category_display
FROM portfolio.Products
ORDER BY
    product_id;


-- İş Sorusu 8:
-- Kategori doluluk durumunu satır bazında etiketle.
SELECT
    product_id,
    product_name,
    CASE
        WHEN category IS NULL THEN N'NULL'
        WHEN LTRIM(RTRIM(category)) = N'' THEN N'Boş Metin'
        ELSE N'Dolu'
    END AS category_status
FROM portfolio.Products
ORDER BY
    product_id;


-- İş Sorusu 9:
-- Müşteri adını büyük harfle, şehir ile birlikte tek alanda göster.
SELECT
    customer_id,
    UPPER(customer_name) AS customer_name_upper,
    CONCAT(customer_name, N' - ', city) AS customer_city_display,
    LEN(LTRIM(RTRIM(customer_name))) AS customer_name_length
FROM portfolio.Customers
ORDER BY
    customer_id;


-- İş Sorusu 10:
-- Siparişlerin yıl, ay ve saat bilgilerini ayrı kolonlarda göster.
SELECT
    order_id,
    order_date,
    CAST(order_date AS DATE) AS order_day,
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    DATEPART(HOUR, order_date) AS order_hour
FROM portfolio.OrderHeaders
ORDER BY
    order_date;


-- İş Sorusu 11:
-- Sipariş ile ödeme arasındaki gün farkını hesapla.
SELECT
    o.order_id,
    o.order_date,
    p.payment_date,
    DATEDIFF(DAY, o.order_date, p.payment_date) AS payment_delay_days
FROM portfolio.OrderHeaders o
JOIN portfolio.Payments p
    ON o.order_id = p.order_id
WHERE p.payment_date IS NOT NULL
ORDER BY
    payment_delay_days DESC,
    o.order_id;


-- Tarih fonksiyonlarının temel kullanımı.
SELECT
    GETDATE() AS current_datetime,
    DATEADD(DAY, -7, GETDATE()) AS seven_days_ago,
    DATEADD(MONTH, 1, GETDATE()) AS one_month_later;

