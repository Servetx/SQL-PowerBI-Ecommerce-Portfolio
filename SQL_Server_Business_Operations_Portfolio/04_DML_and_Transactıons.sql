/* =============================================================
   04 - DML AND TRANSACTIONS
   INSERT, UPDATE, DELETE, INSERT SELECT, UPDATE JOIN,
   DELETE JOIN ve transaction güvenliği
   ============================================================= */

-- Bu dosyadaki ilk örnekler geçici tablolar üzerinde çalışır.
-- SQL Server oturumu kapandığında # ile başlayan tablolar silinir.

DROP TABLE IF EXISTS #OrderPractice;

CREATE TABLE #OrderPractice (
    order_id INT NOT NULL PRIMARY KEY,
    order_status NVARCHAR(20) NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL
);


-- 1. Yeni kayıt ekleme
INSERT INTO #OrderPractice (
    order_id,
    order_status,
    total_amount
)
VALUES
    (1, N'Yeni',      100.00),
    (2, N'Yeni',      250.00),
    (3, N'İptal',      80.00),
    (4, N'Onaylandı', 500.00);

SELECT *
FROM #OrderPractice
ORDER BY order_id;


-- 2. Yalnızca seçilen kaydı güncelleme
UPDATE #OrderPractice
SET order_status = N'Onaylandı'
WHERE order_id = 2;

SELECT *
FROM #OrderPractice
WHERE order_id = 2;


-- 3. Yalnızca seçilen kaydı silme
DELETE FROM #OrderPractice
WHERE order_id = 3;

SELECT *
FROM #OrderPractice
ORDER BY order_id;


-- 4. INSERT SELECT:
-- Kalıcı sipariş tablosundaki teslim edilmiş kayıtları geçici tabloya aktar.
DROP TABLE IF EXISTS #DeliveredOrders;

CREATE TABLE #DeliveredOrders (
    order_id INT NOT NULL,
    customer_id INT NOT NULL,
    order_status NVARCHAR(20) NOT NULL
);

INSERT INTO #DeliveredOrders (
    order_id,
    customer_id,
    order_status
)
SELECT
    order_id,
    customer_id,
    order_status
FROM portfolio.OrderHeaders
WHERE order_status = N'Teslim Edildi';

SELECT *
FROM #DeliveredOrders
ORDER BY order_id;


-- 5. UPDATE JOIN:
-- Geçici müşteri kontrol tablosundaki sipariş sayılarını güncelle.
DROP TABLE IF EXISTS #CustomerReview;

CREATE TABLE #CustomerReview (
    customer_id INT NOT NULL PRIMARY KEY,
    customer_name NVARCHAR(100) NOT NULL,
    order_count INT NOT NULL DEFAULT (0)
);

INSERT INTO #CustomerReview (
    customer_id,
    customer_name
)
SELECT
    customer_id,
    customer_name
FROM portfolio.Customers;

UPDATE cr
SET cr.order_count = order_counts.total_order_count
FROM #CustomerReview cr
JOIN (
    SELECT
        customer_id,
        COUNT(*) AS total_order_count
    FROM portfolio.OrderHeaders
    GROUP BY customer_id
) AS order_counts
    ON cr.customer_id = order_counts.customer_id;

SELECT *
FROM #CustomerReview
ORDER BY order_count DESC, customer_id;


-- 6. DELETE JOIN:
-- Deneme amacıyla hiç sipariş vermeyen müşterileri geçici listeden sil.
DELETE cr
FROM #CustomerReview cr
LEFT JOIN portfolio.OrderHeaders o
    ON cr.customer_id = o.customer_id
WHERE o.customer_id IS NULL;

SELECT *
FROM #CustomerReview
ORDER BY customer_id;


-- 7. TRANSACTION:
-- Stok güncellemesini dene, sonucu göster ve kalıcı değişiklik yapmadan geri al.
BEGIN TRY
    BEGIN TRANSACTION;

    UPDATE portfolio.Products
    SET stock_quantity = stock_quantity - 1
    WHERE product_id = 104
      AND stock_quantity >= 1;

    IF @@ROWCOUNT = 0
        THROW 50001, N'Ürün bulunamadı veya stok yetersiz.', 1;

    SELECT
        product_id,
        product_name,
        stock_quantity
    FROM portfolio.Products
    WHERE product_id = 104;

    ROLLBACK TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;


-- Rollback sonrasında stok değerinin eski halinde kaldığını doğrula.
SELECT
    product_id,
    product_name,
    stock_quantity
FROM portfolio.Products
WHERE product_id = 104;

