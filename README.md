# SQL, Power BI ve Veri Analizi Portföyü

Bu depo, e-ticaret ve iş operasyonları verileri üzerinde hazırladığım **SQL veri analizi çalışmalarını** ve **Power BI dashboard projelerini** içerir.

Çalışmaların amacı; iş sorularını SQL sorgularına dönüştürmek, veri kalitesi kontrolleri yapmak, temel performans göstergelerini hesaplamak ve sonuçları anlaşılır raporlara dönüştürmektir.

## Portföyü İncelemeye Buradan Başlayın

| Proje | İçerik | Bağlantı |
| --- | --- | --- |
| SQL Server İş Operasyonları Portföyü | İş senaryoları, DML, transaction, stored procedure, view, index ve ERP/B2B mutabakatı | [Projeyi incele](SQL_Server_Business_Operations_Portfolio) |
| E-Ticaret İşletmesi SQL Analizi | İş soruları, JOIN, CTE, pencere fonksiyonları ve veri kalite kontrolleri | [Projeyi incele](Ecommerce_Business_SQL_Analysis) |
| SQL Uygulama Sorguları | Temel SQL, aggregate, JOIN, subquery, CTE ve window function pratikleri | [Çalışmaları incele](SQL_Practice_Queries) |
| Training E-Commerce Dashboard | Eğitim sonrasında bağımsız olarak yeniden kurulan Power BI dashboard çalışması | [Dashboard projesini incele](01-Training-Ecommerce-Dashboard) |
| Brazil Olist E-Commerce Dashboard | Olist e-ticaret verileriyle hazırlanan iş odaklı Power BI raporu | [Dashboard projesini incele](02-Brazil-Olist-Ecommerce-Dashboard) |

## Öne Çıkan SQL Projesi

### [SQL Server İş Operasyonları Portföyü](SQL_Server_Business_Operations_Portfolio)

Bu proje, kurgusal bir B2B e-ticaret işletmesinin müşteri, ürün, sipariş, ödeme ve stok verileri üzerinde hazırlanmış kapsamlı bir SQL Server çalışmasıdır.

Projede yer alan başlıca çalışmalar:

- Temel sorgulama, filtreleme, tarih ve metin fonksiyonları
- JOIN, aggregate fonksiyonlar ve veri kalite kontrolleri
- Subquery, CTE, derived table ve window functions
- INSERT, UPDATE, DELETE ve güvenli transaction işlemleri
- Parametreli stored procedure örnekleri
- Geçici tablo, VIEW ve INDEX kullanımı
- Cursor ve set-based yaklaşım karşılaştırması
- ERP ile B2B stok ve fiyat kayıtlarının mutabakatı

[SQL Server proje açıklamasını ve dosyalarını görüntüle](SQL_Server_Business_Operations_Portfolio)

## E-Ticaret SQL Analizi

### [E-Ticaret İşletmesi SQL Analizi](Ecommerce_Business_SQL_Analysis)

Bu projede müşteri, sipariş, ürün, satıcı ve ödeme tabloları kullanılarak gerçekçi iş sorularına SQL ile cevap verilmiştir.

Öne çıkan analizler:

- Müşteri ve sipariş sayıları
- Şehir ve eyalet bazında satış geliri
- Kategori ve satıcı performansı
- Ödeme türüne göre toplam ödeme tutarı
- Müşteri harcama sıralamaları
- Tekrarlanan kimlik, boş kategori ve hatalı tutar kontrolleri
- Sayısal analiz öncesinde veri tipi temizliği

Kullanılan başlıca SQL yapıları:

`SELECT` · `WHERE` · `GROUP BY` · `HAVING` · `CASE WHEN` · `JOIN` · `CTE` · `ROW_NUMBER` · `COUNT` · `SUM` · `AVG`

[SQL proje açıklamasını ve dosyalarını görüntüle](Ecommerce_Business_SQL_Analysis)

## Power BI Dashboard Projeleri

### [Training E-Commerce Dashboard](01-Training-Ecommerce-Dashboard)

Eğitimde öğrenilen dashboard yapısının videoya bakmadan yeniden kurulduğu pratik çalışmasıdır.

- KPI kartları: Customers, Orders, Sales ve AOV
