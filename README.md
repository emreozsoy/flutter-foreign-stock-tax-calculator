<div style="display:flex; justify-content: space-between; align-items: center;">
   
 ![MIT License](https://img.shields.io/badge/License-MIT-green.svg) [![tr](https://img.shields.io/badge/lang-tr-red.svg)](https://github.com/emreozsoy/flutter-foreign-stock-tax-calculator/blob/main/README.tr.md)

</div>


# Tax Calculation on Gains from Foreign Stock Exchanges

Hello! The purpose of this project is to develop an application that facilitates the calculation of taxes on gains from stock trading on foreign exchanges. 

The goal is to provide individuals who engage in small-scale buying and selling on foreign exchanges with the ability to easily track and manage their tax obligations without the need for an accountant.

# Technologies

- Flutter
- Figma
- [intl](https://pub.dev/packages/intl)
- [html](https://pub.dev/packages/html/install)
- [dropdown_button2](https://pub.dev/packages/dropdown_button2)
- [awesome_snacbar_content](https://pub.dev/packages/awesome_snackbar_content)
- [google_fonts](https://pub.dev/packages/google_fonts)

## Getting Started
- Apart from the data we will obtain from the user, we need to fetch the Consumer Price Index (CPI) and the exchange rate on the days of stock trading from the internet.
- To fetch the exchange rate data, you need to have an API key from the Central Bank. After registering through the link provided below, you can access your API key by going to the profile section.

[Central Bank API Registration Link](https://evds2.tcmb.gov.tr/index.php?/evds/login) 

- After obtaining the API key, replace the 'yourAPI' variable in the 'calculate_screen.dart' file with your own API key.

```dart
   String yourAPI= "";
```

 ***After this step, you can use the application as you wish. The rest of the text is for those who are curious about the development of the application and those who plan to make edits.***

### Accessing Exchange Rate and CPI Data

- In this section, instead of using an API to access the CPI data, we will use web scraping to extract the required data from a table on the website "https://www.hakedis.org/endeksler/yi-ufe-yurtici-uretici-fiyat-endeksi".
- The 'fetchYufeIndex' function in the calculate_screen.dart class file handles this process.
  
  ```dart
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
- Lastly, we add the necessary code to fetch the exchange rate on the day the transaction was made.

    ```dart
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

##  User Data Input

- User-input data.

| Parameter | Type     |   
| :-------- | :------- | 
| `buyStockPrice`      | `double` |
| `buyStockQuantity`      | `double` |
| `_buySelectedDate`      | `DateTime` |

| Parametre | Tür     |   
| :-------- | :------- | 
| `sellStockPrice`      | `double` |
| `sellStockQuantity`      | `double` |
| `_sellSelectedDate`      | `DateTime` |

## Design Stages

<div style="display:flex; justify-content: space-between; align-items: center;">
  
- Initially, I created a simple design using paint by considering the data to be acquired. Then, using Figma, I created the initial user interface.
<img src="https://github.com/emreozsoy/flutter-foreign-stock-tax-calculator/blob/main/Design_number0_tr_page.png" alt="Text" width="250" height="600">
 <img src="https://github.com/emreozsoy/flutter-foreign-stock-tax-calculator/blob/main/Design_number1_tr_page.png" alt="alt text" width="250" height="600">

- I designed the user interface using Figma and finalized it by implementing the features of Flutter to bring it to its final form.
<img src="https://github.com/emreozsoy/flutter-foreign-stock-tax-calculator/blob/main/Design_number2_tr_page.jpg" alt="alt text" width="250" height="600">
<img src="https://github.com/emreozsoy/flutter-foreign-stock-tax-calculator/blob/main/Design_number3_tr_page.png" alt="alt text" width="250" height="600">
</div>

## Authors

- [@emreozsoy](https://www.github.com/emreozsoy)



