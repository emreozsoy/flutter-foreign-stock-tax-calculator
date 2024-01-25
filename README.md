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

[Merkez Bankası API Kayıt Linki](https://evds2.tcmb.gov.tr/index.php?/evds/login) 

- Daha sonra aşağıda 'calculate_screen.dart' dosyası içerisinde yer alan 'yourAPI' değişkenini kendi API anahtarınızla değiştirin. 

```
   String yourAPI= "";
```

 ***Bu adımdan sonra uygulamayı dilediğiniz gibi kullanabilirsiniz. Yazının devamı uygulamanın gelişimini merak edenler ve düzenlemeyi düşünenler için***

### Dolar Kuru ve YÜFE Verisine Erişim

- Bu kısımda YÜFE verisine erişmek için API kullanmak yerine web kazıması (web scraping) yaparak istediğimiz verilere ulaşacağız.
- Bunun için "https://www.hakedis.org/endeksler/yi-ufe-yurtici-uretici-fiyat-endeksi" websitesi üzerinden tablo haline getirilmiş hazır YÜFE veri setini çekeceğiz.
- Aşağıda da yer alan calculate_screen class'ı içerisindeki 'fetchYufeIndex' fonksiyonu ile bu işlemi gerçekleştiriyoruz.
  
  ```
  Future<String> fetchYufeIndex(DateTime selectedDate) async {
    final url =
        'https://www.hakedis.org/endeksler/yi-ufe-yurtici-uretici-fiyat-endeksi';
    final response = await http.get(Uri.parse(url));
    const List<String> monthConvert = [
      'OCAK',
      'ŞUBAT',
      'MART',
      'NİSAN',
      'MAYIS',
      'HAZİRAN',
      'TEMMUZ',
      'AĞUSTOS',
      'EYLÜL',
      'EKİM',
      'KASIM',
      'ARALIK'
    ];
    if (response.statusCode == 200) {
      int year = whichYear(selectedDate);
      final htmlData = response.body;
      final document = parser.parse(htmlData);

      // İlgili tablonun HTML yapısını inceleyerek verileri çekin

      final yi_ufes = document.querySelector('body > section > div > div > div > div > table > tbody > tr:nth-child($year)')?.children;

      final months = document.querySelector('body > section > div > div > div > div > table > thead > tr')?.children;

      //Seçilen tarihin bir önceki ayını al. Eğer Ocak ise seçilen ay, Geçen yılın 12. ayını al
      if (selectedDate.month != 1) {
        return yi_ufes![selectedDate.month].text;
      } else {
        final yi_ufes = document.querySelector('body > section > div > div > div > div > table > tbody > tr:nth-child(${year - 1})')?.children;
        return yi_ufes![selectedDate.month + 10].text;
      }
    } else {
      throw Exception('Failed to fetch UFE data');
    }
  }
  ```
- Son olarak işlem yapıldığı günün dolar kurunu çekmek için gerekli kodları ekliyoruz.

    ```
  Future<String> fetchExchangeRate(DateTime date) async {
    date = date.subtract(Duration(days: 1));
    final formattedDate =
        '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
    final url =
        'https://evds2.tcmb.gov.tr/service/evds/series=TP.DK.USD.A&startDate=$formattedDate&endDate=$formattedDate&type=json&key=${yourAPI}';
    final response = await http.get(Uri.parse(url));

    //Dolar kurunu çekme işlemi
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['items'] != null && data['items'].isNotEmpty) {
        final exchangeRate = data['items'][0]['TP_DK_USD_A'];

        if (exchangeRate == "null" || exchangeRate == null) {
          fetchExchangeRate(date);
        } else {
          open = true;
          return exchangeRate.toString();
        }
      }
    }
    return fetchExchangeRate(date);
  }
    ```

##  Kullanıcı Veri Girişi

- Kullanıcıdan alınan veriler.

| Parametre | Tür     |   
| :-------- | :------- | 
| `buyStockPrice`      | `double` |
| `buyStockQuantity`      | `double` |
| `_buySelectedDate`      | `DateTime` |

| Parametre | Tür     |   
| :-------- | :------- | 
| `sellStockPrice`      | `double` |
| `sellStockQuantity`      | `double` |
| `_sellSelectedDate`      | `DateTime` |

## Tasarım Aşamaları
<div style="display:flex; justify-content: space-between; align-items: center;">
  
- Uygulamayı öncelikle alınacak verileri düşünerek paint üzerinden basit bir tasarım yaptım. Sonrasında Figma'yı kullanarak ilk kullanıcı arayüzünü hazırladım.

<img src="https://github.com/emreozsoy/flutter-foreign-stock-tax-calculator/blob/main/Design_number0_tr_page.png" alt="Text" width="250" height="600">
 <img src="https://github.com/emreozsoy/flutter-foreign-stock-tax-calculator/blob/main/Design_number1_tr_page.png" alt="alt text" width="250" height="600">

- Figma'yı kullanarak kullanıcı arayüzü tasarımını geliştirdim. Geliştirdiğim son tasarımımı uygulamak üzere Flutter'ın özelliklerini de kullanarak son haline getirdim.
<img src="https://github.com/emreozsoy/flutter-foreign-stock-tax-calculator/blob/main/Design_number2_tr_page.jpg" alt="alt text" width="250" height="600">
<img src="https://github.com/emreozsoy/flutter-foreign-stock-tax-calculator/blob/main/Design_number3_tr_page.png" alt="alt text" width="250" height="600">
</div>




## Authors

- [@emreozsoy](https://www.github.com/emreozsoy)



