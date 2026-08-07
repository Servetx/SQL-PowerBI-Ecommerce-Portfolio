/* =============================================================
   05 - STORED PROCEDURES
   Parametreli raporlar ve hata kontrollü güncelleme
   ============================================================= */

-- İş Sorusu 1:
-- Kullanıcının verdiği şehre göre müşteri siparişlerini getir.
CREATE OR ALTER PROCEDURE portfolio.usp_GetOrdersByCity
    @City NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        c.customer_id,
        c.customer_name,
        c.city,
        o.order_id,
        o.order_date,
        o.order_status
    FROM portfolio.Customers c
    JOIN portfolio.OrderHeaders o
        ON c.customer_id = o.customer_id
    WHERE c.city = @City
    ORDER BY
        o.order_date DESC,
        o.order_id;
END;
GO

EXEC portfolio.usp_GetOrdersByCity
    @City = N'İstanbul';
GO


-- İş Sorusu 2:
-- Kullanıcının seçtiği kategori için ürün bazında net geliri getir.
CREATE OR ALTER PROCEDURE portfolio.usp_GetCategoryRevenue
    @Category NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        p.product_id,
        p.product_name,
        p.category,
        SUM(
            ol.quantity * ol.unit_price * (1 - ol.discount_rate / 100.0)
        ) AS total_revenue
    FROM portfolio.Products p
    JOIN portfolio.OrderLines ol
        ON p.product_id = ol.product_id
    JOIN portfolio.OrderHeaders o
        ON ol.order_id = o.order_id
    WHERE p.category = @Category
      AND o.order_status <> N'İptal'
    GROUP BY
        p.product_id,
        p.product_name,
        p.category
    ORDER BY
        total_revenue DESC,
        p.product_id;
END;
GO

EXEC portfolio.usp_GetCategoryRevenue
    @Category = N'Elektronik';
GO


-- İş Sorusu 3:
-- Belirli bir siparişin durumunu kontrollü biçimde güncelle.
-- Hatalı durum adı veya bulunmayan sipariş numarası kabul edilmez.
CREATE OR ALTER PROCEDURE portfolio.usp_UpdateOrderStatus
    @OrderId INT,
    @NewStatus NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF @NewStatus NOT IN (
        N'Onaylandı',
        N'Hazırlanıyor',
        N'Kargoda',
        N'Teslim Edildi',
        N'İptal'
    )
        THROW 50002, N'Geçersiz sipariş durumu.', 1;

    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE portfolio.OrderHeaders
        SET order_status = @NewStatus
        WHERE order_id = @OrderId;

        IF @@ROWCOUNT = 0
            THROW 50003, N'Sipariş bulunamadı.', 1;

        COMMIT TRANSACTION;

        SELECT
            order_id,
            customer_id,
            order_status
        FROM portfolio.OrderHeaders
        WHERE order_id = @OrderId;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END;
GO

-- Bu çağrı kalıcı veri değiştirdiği için bilinçli olarak yorumda bırakılmıştır.
-- EXEC portfolio.usp_UpdateOrderStatus
--     @OrderId = 1014,
--     @NewStatus = N'Kargoda';

