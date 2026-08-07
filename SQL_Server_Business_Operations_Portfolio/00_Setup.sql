/* =============================================================
   SQL SERVER BUSINESS OPERATIONS PORTFOLIO
   00 - SETUP
   Kurgusal veri modeli ve örnek kayıtlar
   ============================================================= */

IF SCHEMA_ID(N'portfolio') IS NULL
    EXEC(N'CREATE SCHEMA portfolio');
GO

DROP VIEW IF EXISTS portfolio.vw_OrderSales;
DROP PROCEDURE IF EXISTS portfolio.usp_GetOrdersByCity;
DROP PROCEDURE IF EXISTS portfolio.usp_GetCategoryRevenue;
DROP PROCEDURE IF EXISTS portfolio.usp_UpdateOrderStatus;
GO

DROP TABLE IF EXISTS portfolio.Payments;
DROP TABLE IF EXISTS portfolio.OrderLines;
DROP TABLE IF EXISTS portfolio.OrderHeaders;
DROP TABLE IF EXISTS portfolio.Products;
DROP TABLE IF EXISTS portfolio.Customers;
DROP TABLE IF EXISTS portfolio.B2BProductSnapshot;
DROP TABLE IF EXISTS portfolio.ErpProductSnapshot;
GO

CREATE TABLE portfolio.Customers (
    customer_id INT NOT NULL PRIMARY KEY,
    customer_name NVARCHAR(100) NOT NULL,
    city NVARCHAR(50) NOT NULL,
    segment NVARCHAR(20) NOT NULL,
    email NVARCHAR(120) NULL,
    created_at DATE NOT NULL
);

CREATE TABLE portfolio.Products (
    product_id INT NOT NULL PRIMARY KEY,
    product_name NVARCHAR(100) NOT NULL,
    category NVARCHAR(50) NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    stock_quantity INT NOT NULL,
    is_active BIT NOT NULL CONSTRAINT DF_Products_IsActive DEFAULT (1),
    CONSTRAINT CK_Products_UnitPrice CHECK (unit_price >= 0),
    CONSTRAINT CK_Products_Stock CHECK (stock_quantity >= 0)
);

CREATE TABLE portfolio.OrderHeaders (
    order_id INT NOT NULL PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATETIME2(0) NOT NULL,
    order_status NVARCHAR(20) NOT NULL,
    channel NVARCHAR(20) NOT NULL,
    CONSTRAINT FK_OrderHeaders_Customers
        FOREIGN KEY (customer_id) REFERENCES portfolio.Customers(customer_id)
);

CREATE TABLE portfolio.OrderLines (
    order_line_id INT NOT NULL PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    discount_rate DECIMAL(5,2) NOT NULL CONSTRAINT DF_OrderLines_Discount DEFAULT (0),
    CONSTRAINT FK_OrderLines_OrderHeaders
        FOREIGN KEY (order_id) REFERENCES portfolio.OrderHeaders(order_id),
    CONSTRAINT FK_OrderLines_Products
        FOREIGN KEY (product_id) REFERENCES portfolio.Products(product_id),
    CONSTRAINT CK_OrderLines_Quantity CHECK (quantity > 0),
    CONSTRAINT CK_OrderLines_UnitPrice CHECK (unit_price >= 0),
    CONSTRAINT CK_OrderLines_Discount CHECK (discount_rate BETWEEN 0 AND 100)
);

CREATE TABLE portfolio.Payments (
    payment_id INT NOT NULL PRIMARY KEY,
    order_id INT NOT NULL,
    payment_type NVARCHAR(30) NOT NULL,
    payment_amount DECIMAL(12,2) NOT NULL,
    payment_date DATETIME2(0) NULL,
    CONSTRAINT FK_Payments_OrderHeaders
        FOREIGN KEY (order_id) REFERENCES portfolio.OrderHeaders(order_id),
    CONSTRAINT CK_Payments_Amount CHECK (payment_amount >= 0)
);

CREATE TABLE portfolio.ErpProductSnapshot (
    product_code NVARCHAR(20) NOT NULL PRIMARY KEY,
    product_name NVARCHAR(100) NOT NULL,
    stock_quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    snapshot_date DATE NOT NULL
);

CREATE TABLE portfolio.B2BProductSnapshot (
    product_code NVARCHAR(20) NOT NULL PRIMARY KEY,
    product_name NVARCHAR(100) NOT NULL,
    stock_quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    snapshot_date DATE NOT NULL
);
GO

INSERT INTO portfolio.Customers (
    customer_id, customer_name, city, segment, email, created_at
)
VALUES
    (1,  N'Ada Yılmaz',     N'İstanbul', N'Bireysel', N'ada@example.com',    '2024-10-12'),
    (2,  N'Mert Kaya',      N'Ankara',   N'Kurumsal', N'mert@example.com',   '2024-10-20'),
    (3,  N'Elif Demir',     N'İzmir',    N'Bireysel', N'elif@example.com',   '2024-11-01'),
    (4,  N'Can Çelik',      N'Bursa',    N'Kurumsal', N'can@example.com',    '2024-11-15'),
    (5,  N'Zeynep Arslan',  N'İstanbul', N'Bireysel', N'zeynep@example.com', '2024-12-02'),
    (6,  N'Burak Şahin',    N'Kocaeli',  N'Kurumsal', N'burak@example.com',  '2024-12-18'),
    (7,  N'Deniz Aydın',    N'İstanbul', N'Bireysel', N'ada@example.com',    '2025-01-03'),
    (8,  N'Selin Koç',      N'Ankara',   N'Bireysel', NULL,                  '2025-01-07'),
    (9,  N'Onur Taş',       N'Sakarya',  N'Kurumsal', N'onur@example.com',   '2025-01-10'),
    (10, N'Ece Polat',      N'Gebze',    N'Bireysel', N'ece@example.com',    '2025-01-20');

INSERT INTO portfolio.Products (
    product_id, product_name, category, unit_price, stock_quantity, is_active
)
VALUES
    (101, N'Laptop Standı',       N'Ofis Aksesuarı', 650.00,  35, 1),
    (102, N'Kablosuz Mouse',      N'Elektronik',     450.00,  80, 1),
    (103, N'Mekanik Klavye',      N'Elektronik',    1200.00,  55, 1),
    (104, N'27 İnç Monitör',      N'Elektronik',    6200.00,  12, 1),
    (105, N'USB-C Çoklayıcı',     N'Elektronik',     900.00,  50, 1),
    (106, N'Ofis Koltuğu',        N'Mobilya',       4800.00,  20, 1),
    (107, N'Sert Kapak Defter',   N'Kırtasiye',       75.00, 200, 1),
    (108, N'Bluetooth Kulaklık',  N'Elektronik',    1450.00,  44, 1),
    (109, N'Web Kamera',          NULL,             1800.00,  18, 1),
    (110, N'USB-C Kablo',         N'',               250.00, 120, 1),
    (111, N'Lazer Yazıcı',        N'Elektronik',    3200.00,   8, 0);

INSERT INTO portfolio.OrderHeaders (
    order_id, customer_id, order_date, order_status, channel
)
VALUES
    (1001, 1, '2025-01-05T09:15:00', N'Teslim Edildi', N'Web'),
    (1002, 2, '2025-01-08T11:40:00', N'Teslim Edildi', N'Satış'),
    (1003, 1, '2025-01-09T16:05:00', N'İptal',         N'Web'),
    (1004, 3, '2025-01-15T13:20:00', N'Teslim Edildi', N'Pazaryeri'),
    (1005, 4, '2025-02-01T10:10:00', N'Kargoda',       N'Satış'),
    (1006, 5, '2025-02-03T14:35:00', N'Teslim Edildi', N'Web'),
    (1007, 6, '2025-02-07T15:50:00', N'Onaylandı',     N'Satış'),
    (1008, 2, '2025-02-10T08:45:00', N'Teslim Edildi', N'Web'),
    (1009, 7, '2025-02-15T17:30:00', N'Hazırlanıyor',  N'Pazaryeri'),
    (1010, 8, '2025-03-01T12:05:00', N'Teslim Edildi', N'Web'),
    (1011, 9, '2025-03-05T09:55:00', N'Teslim Edildi', N'Satış'),
    (1012, 3, '2025-03-08T18:10:00', N'Teslim Edildi', N'Pazaryeri'),
    (1013, 5, '2025-03-12T10:25:00', N'Kargoda',       N'Web'),
    (1014, 6, '2025-03-15T11:15:00', N'Onaylandı',     N'Satış'),
    (1015, 4, '2025-03-20T14:00:00', N'Hazırlanıyor',  N'B2B');

INSERT INTO portfolio.OrderLines (
    order_line_id, order_id, product_id, quantity, unit_price, discount_rate
)
VALUES
    (1,  1001, 101,  2,  650.00,  0.00),
    (2,  1001, 102,  1,  450.00,  0.00),
    (3,  1002, 104,  1, 6200.00,  5.00),
    (4,  1002, 107, 10,   75.00,  0.00),
    (5,  1003, 108,  1, 1450.00,  0.00),
    (6,  1004, 103,  1, 1200.00,  0.00),
    (7,  1004, 105,  2,  900.00,  0.00),
    (8,  1005, 106,  2, 4800.00, 10.00),
    (9,  1006, 102,  3,  450.00,  0.00),
    (10, 1006, 110,  4,  250.00,  0.00),
    (11, 1007, 104,  1, 6200.00,  0.00),
    (12, 1007, 108,  2, 1450.00,  5.00),
    (13, 1008, 101,  5,  650.00, 10.00),
    (14, 1008, 107, 20,   75.00,  0.00),
    (15, 1009, 109,  1, 1800.00,  0.00),
    (16, 1009, 105,  1,  900.00,  0.00),
    (17, 1010, 103,  2, 1200.00,  5.00),
    (18, 1010, 102,  2,  450.00,  0.00),
    (19, 1011, 106,  1, 4800.00,  0.00),
    (20, 1011, 107, 15,   75.00,  0.00),
    (21, 1012, 108,  1, 1450.00,  0.00),
    (22, 1012, 110,  2,  250.00,  0.00),
    (23, 1013, 109,  2, 1800.00, 10.00),
    (24, 1013, 101,  1,  650.00,  0.00),
    (25, 1014, 104,  1, 6200.00,  0.00),
    (26, 1014, 103,  1, 1200.00,  0.00);

INSERT INTO portfolio.Payments (
    payment_id, order_id, payment_type, payment_amount, payment_date
)
VALUES
    (2001, 1001, N'Kredi Kartı', 1000.00, '2025-01-05T09:20:00'),
    (2002, 1001, N'Havale',       750.00, '2025-01-05T09:25:00'),
    (2003, 1002, N'Havale',      6640.00, '2025-01-08T11:45:00'),
    (2004, 1004, N'Kredi Kartı', 3000.00, '2025-01-15T13:25:00'),
    (2005, 1005, N'Havale',      8640.00, '2025-02-01T10:20:00'),
    (2006, 1006, N'Kredi Kartı', 2350.00, '2025-02-03T14:40:00'),
    (2007, 1007, N'Havale',      8955.00, '2025-02-07T16:00:00'),
    (2008, 1008, N'Kredi Kartı', 4425.00, '2025-02-10T08:50:00'),
    (2009, 1009, N'Kredi Kartı', 2700.00, '2025-02-15T17:35:00'),
    (2010, 1010, N'Havale',      3180.00, '2025-03-01T12:10:00'),
    (2011, 1011, N'Kredi Kartı', 5925.00, '2025-03-05T10:00:00'),
    (2012, 1012, N'Kredi Kartı', 1900.00, '2025-03-08T18:15:00'),
    (2013, 1013, N'Kredi Kartı', 3890.00, '2025-03-12T10:30:00'),
    (2014, 1015, N'Havale',       500.00, '2025-03-20T14:05:00');

INSERT INTO portfolio.ErpProductSnapshot (
    product_code, product_name, stock_quantity, unit_price, snapshot_date
)
VALUES
    (N'P-101', N'Laptop Standı',   40,  650.00, '2025-03-31'),
    (N'P-102', N'Kablosuz Mouse',  80,  450.00, '2025-03-31'),
    (N'P-103', N'Mekanik Klavye',  55, 1200.00, '2025-03-31'),
    (N'P-104', N'27 İnç Monitör',  12, 6200.00, '2025-03-31'),
    (N'P-105', N'USB-C Çoklayıcı', 50,  900.00, '2025-03-31');

INSERT INTO portfolio.B2BProductSnapshot (
    product_code, product_name, stock_quantity, unit_price, snapshot_date
)
VALUES
    (N'P-101', N'Laptop Standı',   38,  650.00, '2025-03-31'),
    (N'P-102', N'Kablosuz Mouse',  80,  475.00, '2025-03-31'),
    (N'P-104', N'27 İnç Monitör',  10, 6200.00, '2025-03-31'),
    (N'P-105', N'USB-C Çoklayıcı', 50,  900.00, '2025-03-31'),
    (N'P-106', N'Ofis Koltuğu',    20, 4800.00, '2025-03-31');
GO

SELECT N'Kurulum tamamlandı.' AS setup_status;
SELECT COUNT(*) AS customer_count FROM portfolio.Customers;
SELECT COUNT(*) AS product_count FROM portfolio.Products;
SELECT COUNT(*) AS order_count FROM portfolio.OrderHeaders;
SELECT COUNT(*) AS order_line_count FROM portfolio.OrderLines;
SELECT COUNT(*) AS payment_count FROM portfolio.Payments;

