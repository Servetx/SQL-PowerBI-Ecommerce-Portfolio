/* =============================================================
   08 - ERP / B2B RECONCILIATION
   İki sistem arasındaki eksik kayıt, stok ve fiyat farkları
   ============================================================= */

-- İş Sorusu 1:
-- ERP'de bulunan fakat B2B sisteminde bulunmayan ürünleri getir.
SELECT
    e.product_code,
    e.product_name,
    e.stock_quantity AS erp_stock,
    e.unit_price AS erp_price
FROM portfolio.ErpProductSnapshot e
LEFT JOIN portfolio.B2BProductSnapshot b
    ON e.product_code = b.product_code
WHERE b.product_code IS NULL
ORDER BY
    e.product_code;


-- İş Sorusu 2:
-- B2B sisteminde bulunan fakat ERP'de bulunmayan ürünleri getir.
SELECT
    b.product_code,
    b.product_name,
    b.stock_quantity AS b2b_stock,
    b.unit_price AS b2b_price
FROM portfolio.B2BProductSnapshot b
LEFT JOIN portfolio.ErpProductSnapshot e
    ON b.product_code = e.product_code
WHERE e.product_code IS NULL
ORDER BY
    b.product_code;


-- İş Sorusu 3:
-- İki sistemi tam olarak karşılaştır ve her ürüne kontrol sonucu ver.
SELECT
    COALESCE(e.product_code, b.product_code) AS product_code,
    COALESCE(e.product_name, b.product_name) AS product_name,
    e.stock_quantity AS erp_stock,
    b.stock_quantity AS b2b_stock,
    e.unit_price AS erp_price,
    b.unit_price AS b2b_price,
    CASE
        WHEN e.product_code IS NULL THEN N'ERP Kaydı Yok'
        WHEN b.product_code IS NULL THEN N'B2B Kaydı Yok'
        WHEN e.stock_quantity <> b.stock_quantity
         AND ABS(e.unit_price - b.unit_price) >= 0.01
            THEN N'Stok ve Fiyat Farkı'
        WHEN e.stock_quantity <> b.stock_quantity
            THEN N'Stok Farkı'
        WHEN ABS(e.unit_price - b.unit_price) >= 0.01
            THEN N'Fiyat Farkı'
        ELSE N'Eşleşiyor'
    END AS reconciliation_status
FROM portfolio.ErpProductSnapshot e
FULL OUTER JOIN portfolio.B2BProductSnapshot b
    ON e.product_code = b.product_code
ORDER BY
    product_code;


-- İş Sorusu 4:
-- Mutabakat sonuçlarını durum bazında say.
WITH reconciliation AS (
    SELECT
        COALESCE(e.product_code, b.product_code) AS product_code,
        CASE
            WHEN e.product_code IS NULL THEN N'ERP Kaydı Yok'
            WHEN b.product_code IS NULL THEN N'B2B Kaydı Yok'
            WHEN e.stock_quantity <> b.stock_quantity
             AND ABS(e.unit_price - b.unit_price) >= 0.01
                THEN N'Stok ve Fiyat Farkı'
            WHEN e.stock_quantity <> b.stock_quantity
                THEN N'Stok Farkı'
            WHEN ABS(e.unit_price - b.unit_price) >= 0.01
                THEN N'Fiyat Farkı'
            ELSE N'Eşleşiyor'
        END AS reconciliation_status
    FROM portfolio.ErpProductSnapshot e
    FULL OUTER JOIN portfolio.B2BProductSnapshot b
        ON e.product_code = b.product_code
)
SELECT
    reconciliation_status,
    COUNT(*) AS product_count
FROM reconciliation
GROUP BY
    reconciliation_status
ORDER BY
    product_count DESC,
    reconciliation_status;

