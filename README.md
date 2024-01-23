<div style="display:flex; justify-content: space-between; align-items: center;">

[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://choosealicense.com/licenses/mit/) [![en](https://img.shields.io/badge/lang-en-blue.svg)](https://github.com/jonatasemidio/multilanguage-readme-pattern/blob/master/README.md) [![tr](https://img.shields.io/badge/lang-tr-red.svg)](https://github.com/jonatasemidio/multilanguage-readme-pattern/blob/master/README.md)

</div>

# Yabancı Borsalardan Elde Edilen Kazançlardan Vergi Hesaplanması

Merhabalar! Projenin amacı yurtdışı borsalarında yapılan hisse senedi alım/satım işlemlerinde elde edilen kazançlardan ödenmesi gereken verginin hesaplanmasını kolaylaştıran bir uygulama geliştirmektir. 

Böylece yurtdışı borsalarında küçük miktarlarda alım/satım yapan bireylerin muhasebeciye gerek duymadan kendi vergi işlemlerini kolaylıkla kontrol edebilirmelerine olanak sağlanması amaçlanmıştır.

# Teknolojiler

- Flutter
- Figma
- [intl](https://pub.dev/packages/intl)
- [html](https://pub.dev/packages/html/install)
- [dropdown_button2](https://pub.dev/packages/dropdown_button2)
- [awesome_snacbar_content](https://pub.dev/packages/awesome_snackbar_content)
- [google_fonts](https://pub.dev/packages/google_fonts)

## Başlangıç
- Öncelikle kullancıdan alıcağımız veriler dışında internetten ulaşmamız gereken YÜFE ve hisse alım/satım işlemlerinin yapıldığı günlerdeki dolar kuruna ulaşmamız gerekli.
- Dolar kuru verilerini merkez bankasının API'sinden çekmeniz için öncelikle API anahtarna sahip olmalısınız . 
- Aşağıda verdiğim link üzerinden kayıt olduktan sonra ad ve soyadınız yazan buton üzerinden profil kısmına ulaşarak API'nize erişim sağlayabilirsiniz. 

[Merkez Bankası API Kayıt Linki](https://evds2.tcmb.gov.tr/index.php?/evds/login) Daha sonra aşağıda belirttiğim 
```
   String yourAPI= "";
```

 ***Bu adımdan sonra uygulamayı dilediğiniz gibi kullanabilirsiniz. Yazının devamı uygulamayı geliştirmeyi ve düzenlemeyi düşünenler için***

## YÜFE Verisine Erişim

- Bu kısımda YÜFE verisine erişmek için API kullanmak yerine web kazıması (web scraping) yaparak istediğimiz verilere ulaşacağız.
- Bunun için

##  Kullanım

- Kullanıcıdan alınan veriler.

| Parameter | Type     |   
| :-------- | :------- | 
| `buyStockPrice`      | `double` |
| `buyStockQuantity`      | `double` |
| `_buySelectedDate`      | `DateTime` |

| Parameter | Type     |   
| :-------- | :------- | 
| `sellStockPrice`      | `double` |
| `sellStockQuantity`      | `double` |
| `_sellSelectedDate`      | `DateTime` |

# Tasarım
- Figma'yı kullanarak ilk kullanıcı arayüzünü hazırladım.
<div style="display:flex; justify-content: space-between; align-items: center;">
  
<img src="https://github.com/emreozsoy/flutter-foreign-stock-tax-calculator/blob/main/Design_number0_tr_page.png" alt="alt text" width="250" height="600">

<img src="https://github.com/emreozsoy/flutter-foreign-stock-tax-calculator/blob/main/Design_number1_tr_page.png" alt="alt text" width="250" height="600">

<img src="https://github.com/emreozsoy/flutter-foreign-stock-tax-calculator/blob/main/Design_number2_tr_page.jpg" alt="alt text" width="250" height="600">

</div>


## Authors

- [@emreozsoy](https://www.github.com/emreozsoy)



