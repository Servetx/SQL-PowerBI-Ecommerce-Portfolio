/* =============================================================
   06 - TEMP TABLE, VIEW AND INDEX
   Geçici rapor tablosu, tekrar kullanılabilir görünüm
   ve sorgu performansı için indeks
   ============================================================= */

-- İş Sorusu 1:
-- Müşteri gelirlerini geçici tabloya al ve en yüksek 5 müşteriyi getir.
DROP TABLE IF EXISTS #CustomerRevenue;

SELECT
    c.customer_id,
    c.customer_name,
    c.city,
    SUM(
        ol.quantity * ol.unit_price * (1 - ol.discount_rate / 100.0)
    ) AS total_revenue
INTO #CustomerRevenue
FROM portfolio.Customers c
JOIN portfolio.OrderHeaders o
    ON c.customer_id = o.customer_id
JOIN portfolio.OrderLines ol
    ON o.order_id = ol.order_id
WHERE o.order_status <> N'İptal'
GROUP BY
    c.customer_id,
    c.customer_name,
    c.city;

SELECT TOP (5)
    customer_id,
    customer_name,
    city,
    total_revenue
FROM #CustomerRevenue
ORDER BY
    total_revenue DESC,
    customer_id;


GO

-- İş Sorusu 2:
-- Sık kullanılan sipariş satış özetini VIEW olarak oluştur.
CREATE OR ALTER VIEW portfolio.vw_OrderSales
AS
    SELECT
        o.order_id,
        o.order_date,
        o.order_status,
        o.channel,
        c.customer_id,
        c.customer_name,
        c.city,
        COALESCE(SUM(ol.quantity), 0) AS total_quantity,
        COALESCE(
            SUM(
                ol.quantity * ol.unit_price * (1 - ol.discount_rate / 100.0)
            ),
            0
        ) AS sales_amount
    FROM portfolio.OrderHeaders o
    JOIN portfolio.Customers c
        ON o.customer_id = c.customer_id
    LEFT JOIN portfolio.OrderLines ol
        ON o.order_id = ol.order_id
    GROUP BY
        o.order_id,
        o.order_date,
        o.order_status,
        o.channel,
        c.customer_id,
        c.customer_name,
        c.city;
GO

-- VIEW hazırlandıktan sonra normal bir tablo gibi sorgulanabilir.
SELECT
    order_id,
    customer_name,
    city,
    order_status,
    total_quantity,
    sales_amount
FROM portfolio.vw_OrderSales
WHERE order_status <> N'İptal'
ORDER BY
    sales_amount DESC,
    order_id;


-- İş Sorusu 3:
-- Müşteri ve tarih üzerinden yapılan sipariş aramalarını hızlandıracak indeks.
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = N'IX_OrderHeaders_CustomerDate'
      AND object_id = OBJECT_ID(N'portfolio.OrderHeaders')
)
BEGIN
    CREATE INDEX IX_OrderHeaders_CustomerDate
        ON portfolio.OrderHeaders (customer_id, order_date)
        INCLUDE (order_status, channel);
END;
GO

-- Sipariş kalemi JOIN ve ürün filtrelerini destekleyen indeks.
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = N'IX_OrderLines_OrderProduct'
      AND object_id = OBJECT_ID(N'portfolio.OrderLines')
)
BEGIN
    CREATE INDEX IX_OrderLines_OrderProduct
        ON portfolio.OrderLines (order_id, product_id)
        INCLUDE (quantity, unit_price, discount_rate);
END;
GO

-- İndeksin desteklediği örnek sorgu.
SELECT
    order_id,
    customer_id,
    order_date,
    order_status
FROM portfolio.OrderHeaders
WHERE customer_id = 2
  AND order_date >= '2025-01-01'
  AND order_date <  '2025-04-01'
ORDER BY
    order_date;

