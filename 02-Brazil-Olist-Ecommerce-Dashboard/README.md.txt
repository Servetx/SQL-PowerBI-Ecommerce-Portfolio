# Brazil Olist E-Commerce Dashboard

Bu proje, Olist Brazil E-Commerce veri seti üzerinde geliştirdiğim Power BI dashboard çalışmasıdır.

Dashboard’da müşteri, sipariş, ödeme tutarı, ortalama sipariş değeri, ödeme tipi, kategori ve eyalet bazlı dağılım analiz edilmiştir.

## Dashboard Preview

![Dashboard Preview](images/dashboard-preview.png)

## Dashboard İçeriği

* Customers
* Orders
* Payment Value
* AOV
* Payment Value by Month
* Payment Value by Payment Type
* Payment Value by Customer State
* Category Filter

## Kullanılan DAX Ölçüleri

Dashboard’da temel KPI ölçüleri, önceki ay karşılaştırmaları, büyüme oranları ve seçili ay vurgulama ölçüleri kullanılmıştır.

```dax
Customers =
DISTINCTCOUNT(df_Customers[customer_id])

Orders =
COUNTROWS(df_Orders)

Payment Value =
SUM(df_Payments[payment_value])

AOV =
DIVIDE(
    [Payment Value],
    [Orders]
)
```

Diğer DAX ölçüleri `dax/measures.md` dosyasında yer almaktadır.

## SQL Bağlantısı

Bu dashboard’u destekleyen SQL çalışmaları ana repodaki `SQL-Practice` klasöründe yer almaktadır.

## Proje Amacı

Bu projenin amacı, e-ticaret verisi üzerinden temel iş metriklerini analiz etmek ve bu metrikleri Power BI dashboard üzerinde anlaşılır şekilde sunmaktır.
