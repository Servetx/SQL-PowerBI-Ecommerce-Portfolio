/* =============================================================
   E-TICARET IS ODAKLI SQL ANALIZI
   Dosya: 00_Data_Preparation.sql
   Konu: Veri tipi hazirligi ve temizlik
   Veritabani: SQL Server

   Amac:
   Sayisal analizlerde kullanilacak kolonlarin dogru veri tipinde
   olmasini saglamak.

   Not:
   Bu dosya veri temizligi iceren DDL/DML komutlari barindirir.
   Gercek is ortaminda once yedek alinmali, sonra uygulanmalidir.
   ============================================================= */


/* Is Sorusu:
   product_weight_g kolonu sayisal analiz icin uygun mu?
   Bos veya sayiya cevrilemeyen degerleri kontrol et.
*/
SELECT
    product_weight_g
FROM df_Products
WHERE
    product_weight_g IS NOT NULL
    AND LTRIM(RTRIM(product_weight_g)) <> ''
    AND TRY_CAST(LTRIM(RTRIM(product_weight_g)) AS DECIMAL(18,2)) IS NULL;


/* Islem:
   Bos metin veya sayiya cevrilemeyen agirlik degerlerini NULL olarak isaretle.
   Boylece AVG, MIN, MAX gibi sayisal hesaplar gecerli degerlerle calisir.
*/
UPDATE df_Products
SET product_weight_g = NULL
WHERE
    product_weight_g IS NULL
    OR LTRIM(RTRIM(product_weight_g)) = ''
    OR TRY_CAST(LTRIM(RTRIM(product_weight_g)) AS DECIMAL(18,2)) IS NULL;


/* Islem:
   product_weight_g kolonunu sayisal tipe cevir.
*/
ALTER TABLE df_Products
ALTER COLUMN product_weight_g DECIMAL(18,2) NULL;


/* Kontrol:
   Kolon tipi degisti mi?
*/
SELECT
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE
    TABLE_NAME = 'df_Products'
    AND COLUMN_NAME = 'product_weight_g';


/* Kontrol:
   NULL olarak isaretlenen agirlik kayit sayisini goster.
*/
SELECT
    COUNT(*) AS null_weight_count
FROM df_Products
WHERE
    product_weight_g IS NULL;
