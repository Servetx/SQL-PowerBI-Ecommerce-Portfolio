/* =============================================================
   07 - CURSOR VS SET-BASED
   Aynı işin satır satır ve toplu yaklaşımla karşılaştırılması
   ============================================================= */

-- İş Senaryosu:
-- Stoku 50 ve üzerindeki aktif ürünler için 5 adet kampanya rezervi ayır.
-- Gerçek ürün tablosu değiştirilmez; işlem geçici kopyada gösterilir.

DROP TABLE IF EXISTS #StockAdjustment;

SELECT
    product_id,
    product_name,
    stock_quantity AS original_stock,
    stock_quantity AS adjusted_stock
INTO #StockAdjustment
FROM portfolio.Products
WHERE is_active = 1;


-- 1. CURSOR YAKLAŞIMI:
-- SQL Server her uygun ürünü tek tek dolaşır.
DECLARE @ProductId INT;

DECLARE product_cursor CURSOR LOCAL FAST_FORWARD FOR
    SELECT product_id
    FROM #StockAdjustment
    WHERE adjusted_stock >= 50;

OPEN product_cursor;

FETCH NEXT FROM product_cursor INTO @ProductId;

WHILE @@FETCH_STATUS = 0
BEGIN
    UPDATE #StockAdjustment
    SET adjusted_stock = adjusted_stock - 5
    WHERE product_id = @ProductId;

    FETCH NEXT FROM product_cursor INTO @ProductId;
END;

CLOSE product_cursor;
DEALLOCATE product_cursor;

SELECT
    product_id,
    product_name,
    original_stock,
    adjusted_stock,
    N'Cursor' AS method
FROM #StockAdjustment
ORDER BY
    product_id;


-- Sonucu başlangıç değerine döndür.
UPDATE #StockAdjustment
SET adjusted_stock = original_stock;


-- 2. SET-BASED YAKLAŞIM:
-- Aynı işlem uygun satırların tamamına tek UPDATE ile uygulanır.
UPDATE #StockAdjustment
SET adjusted_stock = adjusted_stock - 5
WHERE adjusted_stock >= 50;

SELECT
    product_id,
    product_name,
    original_stock,
    adjusted_stock,
    N'Set-Based' AS method
FROM #StockAdjustment
ORDER BY
    product_id;

-- Sonuç:
-- Basit toplu güncellemelerde set-based yaklaşım daha kısa,
-- daha okunabilir ve genellikle daha performanslıdır.

