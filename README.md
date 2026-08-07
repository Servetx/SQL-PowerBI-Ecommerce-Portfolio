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
- Aylık satış ve ödeme yöntemi analizleri
- Ürün ve ülke bazlı görseller
- DAX ile önceki ay karşılaştırması ve büyüme oranları
- Slicer, koşullu biçimlendirme ve dinamik ay vurgulama

[Proje README](01-Training-Ecommerce-Dashboard) · [Dashboard PDF](01-Training-Ecommerce-Dashboard/dashboard.pdf.pdf) · [DAX ölçüleri](01-Training-Ecommerce-Dashboard/dax/DAX_Measures.md)

### [Brazil Olist E-Commerce Dashboard](02-Brazil-Olist-Ecommerce-Dashboard)

Olist Brazil e-ticaret veri seti üzerinde müşteri, sipariş ve ödeme performansını inceleyen Power BI çalışmasıdır.

- KPI kartları: Customers, Orders, Payment Value ve AOV
- Aylık ödeme tutarı analizi
- Ödeme tipi ve müşteri eyaleti dağılımı
- Kategori ve ay filtreleri
- DAX ile önceki ay karşılaştırması ve dinamik vurgulama

[Proje README](02-Brazil-Olist-Ecommerce-Dashboard) · [Dashboard PDF](02-Brazil-Olist-Ecommerce-Dashboard/dashboard.pdf.pdf) · [DAX ölçüleri](02-Brazil-Olist-Ecommerce-Dashboard/dax/DAX_Measures.md)

## Kullanılan Teknolojiler

- Microsoft SQL Server
- Stored procedure ve transaction işlemleri
- VIEW, geçici tablo ve indeks kullanımı
- Power BI Desktop
- DAX
- Veri modelleme
- Veri temizleme ve kalite kontrolü
- KPI ve dashboard tasarımı

## Depo Yapısı

```text
SQL-PowerBI-Ecommerce-Portfolio/
├── SQL_Server_Business_Operations_Portfolio/ # Kapsamlı SQL Server iş senaryoları
├── Ecommerce_Business_SQL_Analysis/          # İş odaklı e-ticaret SQL projesi
├── SQL_Practice_Queries/                      # SQL öğrenme ve pratik dosyaları
├── 01-Training-Ecommerce-Dashboard/           # Power BI eğitim dashboardu
├── 02-Brazil-Olist-Ecommerce-Dashboard/      # Olist Power BI dashboardu
└── README.md                                  # Ana portföy yönlendirmesi
```

## Proje Notu

Bu çalışmalar gerçek şirket deneyimi iddiası taşımaz. Öğrenilen SQL ve Power BI konularını iş senaryolarına uygulamak amacıyla hazırlanmış portföy projeleridir.

## İletişim

- [GitHub profili](https://github.com/Servetx)
