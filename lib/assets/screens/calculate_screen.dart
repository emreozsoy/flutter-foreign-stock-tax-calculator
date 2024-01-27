import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart' as parser;
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:get_data/custom_text.dart';

class Calculate_Screen extends StatefulWidget {
  final int whichShare;
  final int processCount;
  late int flagProcessCount;

  Calculate_Screen(
      {required this.whichShare,
      required this.processCount,
      required this.flagProcessCount});
  @override
  _Calculate_ScreenState createState() => _Calculate_ScreenState();
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // runApp(Calculate_Screen());
}

class _Calculate_ScreenState extends State<Calculate_Screen> {
  //FAZLA BÜYÜK SAYI GİRİLMESİNE UYARI SİSTEMİ EKLE

  String yourAPI = "";
  String? selectedValue;
  int firstBuyStock = 0;

  bool open = false;
  List<double> buyStockPrice = <double>[0, 0, 0, 0, 0, 0];
  List<double> buyStockQuantity = <double>[0, 0, 0, 0, 0, 0];

  List<double> sellStockPrice = <double>[0, 0, 0, 0, 0, 0];
  List<double> sellStockQuantity = <double>[0, 0, 0, 0, 0, 0];

  String processDate = "İşlem Tarihi";

  //Seçilen tarihleri göstermek için liste
  // listeden fazla işlem yapılmamalı
  List<DateTime> _buySelectedDate = <DateTime>[
    DateTime(0000, 00, 00),
    DateTime(0000, 00, 00),
    DateTime(0000, 00, 00),
    DateTime(0000, 00, 00),
    DateTime(0000, 00, 00),
    DateTime(0000, 00, 00),
    DateTime(0000, 00, 00),
    DateTime(0000, 00, 00),
    DateTime(0000, 00, 00),
    DateTime(0000, 00, 00),
    DateTime(0000, 00, 00),
    DateTime(0000, 00, 00),
  ];
  List<DateTime> _sellSelectedDate = <DateTime>[
    DateTime(0000, 00, 00),
    DateTime(0000, 00, 00),
    DateTime(0000, 00, 00),
    DateTime(0000, 00, 00),
    DateTime(0000, 00, 00),
    DateTime(0000, 00, 00),
    DateTime(0000, 00, 00),
    DateTime(0000, 00, 00),
    DateTime(0000, 00, 00),
    DateTime(0000, 00, 00),
    DateTime(0000, 00, 00),
    DateTime(0000, 00, 00),
  ];

  var _buyExchangeRate = <String>["", "", "", "", "", "", "", "", "", ""];
  var _sellExchangeRate = <String>["", "", "", "", "", "", "", "", "", ""];

  var _buyUfeIndex = <double>[0, 0, 0, 0, 0, 0, 0];
  var _sellUfeIndex = <double>[0, 0, 0, 0, 0, 0, 0];

  static List<int> list = <int>[1, 2, 3, 4, 5];

  late int bDropDownValue = 1;
  late int sDropDownValue = 1;
  int buyDropDownValue= 1;
  int sellDropDownValue = 1;
  bool _visible = false;


  Future<String> fetchBuyYufeIndex(DateTime selectedDate) async {
    final url =
        'https://www.hakedis.org/endeksler/yi-ufe-yurtici-uretici-fiyat-endeksi';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      int year = whichYear(selectedDate);
      final htmlData = response.body;
      final document = parser.parse(htmlData);

      // İlgili tablonun HTML yapısını inceleyerek verileri çekin

      final yi_ufes = document
          .querySelector(
              'body > section > div > div > div > div > table > tbody > tr:nth-child($year)')
          ?.children;

    //  final months = document.querySelector('body > section > div > div > div > div > table > thead > tr')?.children;

      //Seçilen tarihin bir önceki ayını al. Eğer Ocak ise seçilen ay, Geçen yılın 12. ayını al
      if (selectedDate.month != 1) {
        return yi_ufes![selectedDate.month].text;
      } else {
        final yi_ufes = document
            .querySelector(
                'body > section > div > div > div > div > table > tbody > tr:nth-child(${year - 1})')
            ?.children;
        return yi_ufes![selectedDate.month + 10].text;
      }
    } else {
      throw Exception('Failed to fetch UFE data');
    }
  }

  Future<String> fetchSellYufeIndex(DateTime selectedDate) async {
    final url =
        'https://www.hakedis.org/endeksler/yi-ufe-yurtici-uretici-fiyat-endeksi';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      int year = whichYear(selectedDate);
      final htmlData = response.body;
      final document = parser.parse(htmlData);

      // İlgili tablonun HTML yapısını inceleyerek verileri çekin

      final yi_ufes = document
          .querySelector(
          'body > section > div > div > div > div > table > tbody > tr:nth-child($year)')
          ?.children;

      //  final months = document.querySelector('body > section > div > div > div > div > table > thead > tr')?.children;

      //Seçilen tarihin bir önceki ayını al. Eğer Ocak ise seçilen ay, Geçen yılın 12. ayını al
      if (selectedDate.month != 1) {
        return yi_ufes![selectedDate.month].text;
      } else {
        final yi_ufes = document
            .querySelector(
            'body > section > div > div > div > div > table > tbody > tr:nth-child(${year - 1})')
            ?.children;
        return yi_ufes![selectedDate.month + 10].text;
      }
    } else {
      throw Exception('Failed to fetch UFE data');
    }
  }

  //refactor this code part
  //not eligible  to use in the future
  int whichYear(DateTime year) {
    switch (year.year) {
      case 2024:
        return 1;
      case 2023:
        return 3;
      case 2022:
        return 5;
      case 2021:
        return 7;
      case 2020:
        return 9;
      case 2019:
        return 11;
      case 2018:
        return 13;
      case 2017:
        return 15;
      case 2016:
        return 17;
      case 2015:
        return 19;
      case 2014:
        return 21;
      case 2013:
        return 23;
      case 2012:
        return 25;
      case 2011:
        return 27;
      case 2010:
        return 29;
      case 2009:
        return 31;
      case 2008:
        return 33;
      case 2007:
        return 35;
      case 2006:
        return 37;
      case 2005:
        return 39;
      default:
        return 0;
    }
  }

  Future<String> fetchExchangeRate(DateTime date) async {
    final formattedDate =
        '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
    final url =
        'https://evds2.tcmb.gov.tr/service/evds/series=TP.DK.USD.A&startDate=$formattedDate&endDate=$formattedDate&type=json&key=${yourAPI}';
    final response = await http.get(Uri.parse(url));

    //Dolar kurun çek
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

/*
  Future<String> fetchFridayExchangeRate(DateTime date) async {
    DateTime fridayDate = date;
    while (fridayDate.weekday != DateTime.friday) {
      fridayDate = fridayDate.subtract(Duration(days: 1));
    }
    return fetchExchangeRate(fridayDate);
  }
*/
  void getBuyUFEIndex(DateTime selectedDate, int i) {
    DateTime holdDate;
    holdDate = selectedDate.subtract(Duration(days: 30));

    fetchBuyYufeIndex(holdDate).then((ufeIndex) {
      setState(() {
        final numberFormat = NumberFormat
            .decimalPattern(); // Sayı biçimlendirme için NumberFormat kullanılır
        final parsedValue = numberFormat.parse(ufeIndex);
        _buyUfeIndex[i] = parsedValue.toDouble();

        print("Ufe değeri atandı $i: ${_buyUfeIndex[i]}");
      });
    });
  }



  void getSellUFEIndex(DateTime selectedDate, int i) {
    DateTime holdDate;
    holdDate = selectedDate.subtract(Duration(days: 30));

    fetchSellYufeIndex(holdDate).then((ufeIndex) {
      setState(() {
        final numberFormat = NumberFormat
            .decimalPattern(); // Sayı biçimlendirme için NumberFormat kullanılır
        final parsedValue = numberFormat.parse(ufeIndex);
        _sellUfeIndex[i] = parsedValue.toDouble();

        print("Ufe değeri atandı $i: ${_buyUfeIndex[i]}");
      });
    });
  }

  void getBuyExchangeRate(DateTime selectedDate, int i) async {
    _buyExchangeRate[i] = await fetchExchangeRate(selectedDate);
    if (_buyExchangeRate[i] == "null" || _buyExchangeRate[i] == "") {
      selectedDate = selectedDate.subtract(Duration(days: 1));
      _buyExchangeRate[i] = await fetchExchangeRate(selectedDate);
    }
    setState(() {});
  }

  void getSellExchangeRate(DateTime selectedDate, int i) async {
    _sellExchangeRate[i] = await fetchExchangeRate(selectedDate);
    if (_sellExchangeRate[i] == "null" || _sellExchangeRate[i] == "") {
      selectedDate = selectedDate.subtract(Duration(days: 1));
      _sellExchangeRate[i] = await fetchExchangeRate(selectedDate);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double phoneHeight = MediaQuery.of(context).size.height;
    double phoneWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            //TextInput açıldıktan sonra geri butonuna tıklandığında, telefon klavyesini kapatması için
            SystemChannels.textInput
                .invokeMethod('TextInput.hide')
                .then((value) => Navigator.of(context).pop());
          },
        ),
        backgroundColor: Color.fromRGBO(46, 204, 113, 1),
        title: Text('${widget.processCount}. Hisse İşlemleri',
            textAlign: TextAlign.start,
            style: GoogleFonts.cabin()), //CHECK THAT START TEXT
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            color: Color.fromRGBO(26, 188, 156, 0.25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: phoneHeight * 0.008),
                ElevatedText(
                  text: 'Alım İşlemleri',
                  phoneHeight: phoneHeight,
                  phoneWidth: phoneWidth,
                ),
                SizedBox(height: phoneHeight * 0.005),
                Visibility(
                  visible: widget.whichShare == 1,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        //l,t,r,b
                        phoneWidth * 0.09,
                        phoneHeight * 0.01,
                        phoneWidth * 0.08,
                        phoneHeight * 0.01),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Container(
                            height: 50.0,
                            width: 150.0,
                            child: DropdownButtonFormField2<String>(
                              isExpanded: true,
                              decoration: InputDecoration(
                                hoverColor: Colors.green,
                                filled: true,
                                fillColor: CupertinoColors.systemGrey4,
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                // Diğer dekorasyon ayarlarını burada ekleyin
                              ),
                              hint: Text(
                                'İşlem Yapılan Hisse Sayısı',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                textAlign: TextAlign.center,
                                style: (ElevatedText.buildJosefinSans(0.5, 16)),
                              ),
                              items: list
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item.toString(),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            item.toString(),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              validator: (value) {
                                if (value == null) {
                                  return 'İşlem Yapılan Hisse Sayısı';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                widget.flagProcessCount = int.parse(value!);
                              },
                              onSaved: (value) {
                                selectedValue = value.toString();
                              },
                              buttonStyleData: const ButtonStyleData(
                                padding: EdgeInsets.only(right: 3),
                              ),
                              iconStyleData: const IconStyleData(
                                icon: Icon(
                                  Icons.keyboard_arrow_down_sharp,
                                  color: Colors.black,
                                ),
                                iconSize: 32,
                              ),
                              dropdownStyleData: DropdownStyleData(
                                decoration: BoxDecoration(
                                  color: CupertinoColors.systemGrey5,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(phoneWidth * 0.025),
                          child: Image(
                            image: AssetImage(
                                'lib/assets/images/icon _bar chart_.png'), // Eklemek istediğiniz resmin yolunu belirtin
                            width: 48, // Resmin genişliği
                            height: 48, // Resmin yüksekliği
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                    visible: widget.whichShare == 1,
                    child: Image.asset('lib/assets/images/Line2.png')),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      phoneWidth * 0.09,
                      phoneHeight * 0.01,
                      phoneWidth * 0.08,
                      phoneHeight * 0.01),
                  child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            height: 50.0,
                            width: 150.0,
                            child: DropdownButtonFormField<int>(
                              isExpanded: true,
                              decoration: InputDecoration(
                                hoverColor: Colors.green,
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                filled: true,
                                fillColor: CupertinoColors.systemGrey4,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                // Adjust the height to center the hint text vertically
                                isDense: true,
                              ),
                              value: buyDropDownValue,
                              icon: Icon(
                                Icons.keyboard_arrow_down_sharp,
                                color: Colors.black,
                                size: 32,
                              ),
                              elevation: 16,
                              style: (ElevatedText.buildJosefinSans(0.5, 16)),
                              onChanged: (int? value) {
                                // This is called when the user selects an item.
                                setState(() {
                                  //Playing Visible animation
                                  if (value! > 1) {
                                    _visible = true;
                                  } else {
                                    _visible = false;
                                  }
                                  buyDropDownValue = value;
                                  bDropDownValue = buyDropDownValue!;
                                });
                              },
                              hint: Padding(
                                padding: EdgeInsets.fromLTRB(
                                    phoneWidth * 0.05, 0, 0, 0),
                                child: Text(
                                  'Satın Alınan Hisse Sayısı', //??fix center problem
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  textAlign: TextAlign.center,
                                  style: ElevatedText.buildJosefinSans(0.5, 16),
                                ),
                              ),
                              items:
                                  list.map<DropdownMenuItem<int>>((int value) {
                                return DropdownMenuItem<int>(
                                  alignment: Alignment.center,
                                  value: value,
                                  child: Text(
                                    value.toString(),
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              }).toList(),
                              dropdownColor: CupertinoColors.systemGrey5,
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.fromLTRB(phoneWidth * 0.025, 0, 0, 0),
                          child: Image(
                            // EĞER DİLİ EN İSE RESİM DEĞİŞMELİ !!!!
                            image: changeIcon(0),

                            width: 56, // Resmin genişliği
                            height: 56, // Resmin yüksekliği),
                          ),
                        )
                      ]),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      phoneWidth * 0.01,
                      phoneHeight * 0.01,
                      phoneWidth * 0.01,
                      phoneHeight * 0.01),
                  child: Container(
                    width: phoneWidth * 0.9,
                    height: phoneHeight * 0.35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          90), // Reduced border radius for a more subtle curve
                      color: Color.fromRGBO(46, 204, 113, 1),
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          phoneWidth * 0.08,
                          phoneHeight * 0.01,
                          phoneWidth * 0.08,
                          phoneWidth *
                              0.08), // Added padding for better spacing
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text("1. Alım İşlemi",
                                  style: ElevatedText.buildJosefinSans(0.5, 24),
                                  textAlign: TextAlign.center)
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: phoneHeight * 0.01),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2005),
                                      lastDate: DateTime.now(),
                                    ).then((selectedDate) async {
                                      if (selectedDate != null) {
                                        getBuyUFEIndex(selectedDate, 0);
                                        getBuyExchangeRate(selectedDate, 0);
                                        _buySelectedDate[0] = selectedDate;
                                        //LİSTE OLUŞTUR eğer gönderilen getExchangeRate e 1 ise buna ver değer fln filan
                                      }
                                    });
                                  },
                                  style: ButtonStyle(
                                    elevation: MaterialStateProperty.all(0),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            15), // Adjusted button border radius
                                      ),
                                    ),
                                    backgroundColor: MaterialStateProperty.all(
                                        CupertinoColors.systemGrey4),
                                    minimumSize: MaterialStateProperty.all(Size(
                                        phoneWidth * 0.5,
                                        phoneHeight *
                                            0.05)), // Adjusted the minimum size for the button
                                  ),
                                  child: showDateText(_buySelectedDate[0]),
                                ),
                                Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Image.asset(
                                      "lib/assets/images/icon_date.png",
                                      width: 48,
                                      height: 48,
                                    ))
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    labelText: ('Hisse Değerini Girin: '),
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 16.0),
                                    filled: true,
                                    fillColor: CupertinoColors.systemGrey4,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true),
                                  onChanged: (value) {
                                    setState(() {
                                      final numberFormat =
                                          NumberFormat.decimalPattern();
                                      final parsedValue =
                                          numberFormat.parse(value);
                                      buyStockPrice[0] = parsedValue.toDouble();
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: TextField(
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    labelText: ('Hisse Miktarını Girin: '),
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 20.0),
                                    filled: true,
                                    fillColor: CupertinoColors.systemGrey4,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true),
                                  onChanged: (value) {
                                    setState(() {
                                      final numberFormat =
                                          NumberFormat.decimalPattern();
                                      final parsedValue =
                                          numberFormat.parse(value);
                                      buyStockQuantity[0] =
                                          parsedValue.toDouble();
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.0),
                        ],
                      ),
                    ),
                  ),
                ),
                AnimatedOpacity(
                  // If the widget is visible, animate to 0.0 (invisible).
                  // If the widget is hidden, animate to 1.0 (fully visible).
                  opacity: _visible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 750),
                  // The green box must be a child of the AnimatedOpacity widget.
                  child:
                      createBuyProcess(bDropDownValue, phoneWidth, phoneHeight),
                ),
                Container(
                    child:
                        Image.asset("lib/assets/images/img_dividetwopart.png")),
                ElevatedText(
                  text: 'Satış İşlemleri',
                  phoneHeight: phoneHeight,
                  phoneWidth: phoneWidth,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      phoneWidth * 0.1,
                      phoneHeight * 0.01,
                      phoneWidth * 0.15,
                      phoneHeight * 0.01),
                  child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            isExpanded: true,
                            decoration: InputDecoration(
                              hoverColor: Colors.green,
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 12),
                              filled: true,
                              fillColor: CupertinoColors.systemGrey4,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(32),
                              ),
                              // Adjust the height to center the hint text vertically
                              isDense: true,
                            ),
                            value: sellDropDownValue,
                            icon: Icon(
                              Icons.keyboard_arrow_down_sharp,
                              color: Colors.black,
                              size: 32,
                            ),
                            elevation: 16,
                            style: (ElevatedText.buildJosefinSans(0.5, 16)),
                            onChanged: (int? value) {
                              // This is called when the user selects an item.
                              setState(() {
                                //Playing Visible animation

                                sellDropDownValue = value!;
                                sDropDownValue = sellDropDownValue;
                              });
                            },
                            hint: Padding(
                              padding: EdgeInsets.fromLTRB(
                                  phoneWidth * 0.05, 0, 0, 0),
                              child: Text(
                                'Satılan Hisse Sayısı', //??fix center problem
                                textAlign: TextAlign.center,
                                style: ElevatedText.buildJosefinSans(0.5, 16),
                              ),
                            ),
                            items: list.map<DropdownMenuItem<int>>((int value) {
                              return DropdownMenuItem<int>(
                                alignment: Alignment.center,
                                value: value,
                                child: Text(
                                  value.toString(),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            }).toList(),
                            dropdownColor: CupertinoColors.systemGrey5,
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.fromLTRB(phoneWidth * 0.025, 0, 0, 0),
                          child: Image(
                            // EĞER DİLİ EN İSE RESİM DEĞİŞMELİ !!!!
                            image: changeIcon(0),

                            width: 56, // Resmin genişliği
                            height: 56, // Resmin yüksekliği),
                          ),
                        ),
                      ]),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      phoneWidth * 0.01,
                      phoneHeight * 0.01,
                      phoneWidth * 0.01,
                      phoneHeight * 0.01),
                  child: Container(
                    width: phoneWidth * 0.9,
                    height: phoneHeight * 0.35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          90), // Reduced border radius for a more subtle curve
                      color: Color.fromRGBO(46, 204, 113, 1),
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          phoneWidth * 0.08,
                          phoneHeight * 0.01,
                          phoneWidth * 0.08,
                          phoneWidth *
                              0.08), // Added padding for better spacing
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text("1. Satış İşlemi",
                                  style: ElevatedText.buildJosefinSans(0.5, 24),
                                  textAlign: TextAlign.center)
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: phoneHeight * 0.01),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2005),
                                      lastDate: DateTime.now(),
                                    ).then((mselectedDate) async {
                                      if (mselectedDate != null) {
                                        getBuyUFEIndex(mselectedDate, 0);
                                        getSellExchangeRate(mselectedDate, 0);
                                        _sellSelectedDate[0] = mselectedDate;
                                      }
                                    });
                                  },
                                  style: ButtonStyle(
                                    elevation: MaterialStateProperty.all(0),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            15), // Adjusted button border radius
                                      ),
                                    ),
                                    backgroundColor: MaterialStateProperty.all(
                                        CupertinoColors.systemGrey4),
                                    minimumSize: MaterialStateProperty.all(Size(
                                        phoneWidth * 0.5,
                                        phoneHeight *
                                            0.05)), // Adjusted the minimum size for the button
                                  ),
                                  child: showDateText(_sellSelectedDate[0]),
                                ),
                                Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Image.asset(
                                      "lib/assets/images/icon_date.png",
                                      width: 48,
                                      height: 48,
                                    ))
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    labelText: ('Hisse Değerini Girin: '),
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 16.0),
                                    filled: true,
                                    fillColor: CupertinoColors.systemGrey4,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true),
                                  onChanged: (value) {
                                    setState(() {
                                      final numberFormat =
                                          NumberFormat.decimalPattern();
                                      final parsedValue =
                                          numberFormat.parse(value);
                                      sellStockPrice[0] =
                                          parsedValue.toDouble();
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: TextField(
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    labelText: ('Hisse Miktarını Girin: '),
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 20.0),
                                    filled: true,
                                    fillColor: CupertinoColors.systemGrey4,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true),
                                  onChanged: (value) {
                                    setState(() {
                                      final numberFormat =
                                          NumberFormat.decimalPattern();
                                      final parsedValue =
                                          numberFormat.parse(value);
                                      sellStockQuantity[0] =
                                          parsedValue.toDouble();
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.0),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                createSellProcess(sDropDownValue, phoneWidth, phoneHeight),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.all(20),
        child: FloatingActionButton(
          onPressed: () {
             calculateTax();

            setState(() {
              //Sonuç Ekranı tasarlayıp çıktıyı göster

              if (widget.processCount == widget.flagProcessCount) {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: Duration(milliseconds: 500),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return SlideTransition(
                        position: animation.drive(
                          Tween(begin: Offset(1.0, 0.0), end: Offset.zero)
                              .chain(
                            CurveTween(curve: Curves.easeOut),
                          ),
                        ),
                        child: child,
                      );
                    },
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return Calculate_Screen(
                        whichShare: 1,
                        processCount: widget.processCount,
                        flagProcessCount: widget.flagProcessCount,
                      );
                    },
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: Duration(milliseconds: 500),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return SlideTransition(
                        position: animation.drive(
                          Tween(begin: Offset(1.0, 0.0), end: Offset.zero)
                              .chain(
                            CurveTween(curve: Curves.easeOut),
                          ),
                        ),
                        child: child,
                      );
                    },
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return Calculate_Screen(
                        whichShare: 1,
                        processCount: widget.processCount,
                        flagProcessCount: widget.flagProcessCount,
                      );
                    },
                  ),
                );
              }
            });
          },
          backgroundColor: Colors.black38,
          child: Container(
            width: 108.0,
            height: 108.0,
            child: Icon(Icons.arrow_forward_ios_outlined),
          ),
        ),
      ),
    );
  }

  //calculate taxi ikiye böl biri alış işlemleri için diğeri satış işlemleri için olsun
  //en son tüm hesaplamalar için de ayrı bir fonskiyonda bunları çağır
  //fix calculate function

  void calculateTax() {
    double buySum = 0;
    double sellSum = 0;

    // Alış işlemleri
    for (int i = 0; i < bDropDownValue; i++) {


      double buyMaliyet = buyStockPrice[i] * buyStockQuantity[i] *  double.parse(_buyExchangeRate[i]);

      // Alış maliyetini enflasyon ile endeksleme
      if (_buyUfeIndex[i] > 1.1) {
        double inflationRate =  (_buyUfeIndex[i]) * 100; // Yİ-ÜFE artış oranı hesaplama
        buyMaliyet *= inflationRate / 100; // Alış maliyetini endeksleme
      }

      buySum += buyMaliyet;

    }


    // Satış işlemleri
    for (int i = 0; i < sDropDownValue; i++) {
      double sellMaliyet = sellStockPrice[i] * sellStockQuantity[i] * double.parse(_sellExchangeRate[i]);
      sellSum += sellMaliyet;
    }
    print("Sell Sum: $sellSum");

    double karZarar = sellSum - buySum;

    // Vergi hesaplama ve yazdırma
    if (karZarar > 0) {
      double vergi = karZarar * 0.15; // %15 vergi oranı

      print('Kazanç: $karZarar TL');
      print('Vergi Borcu: $vergi TL');
    } else {
      print('Kazanç yok');
      print('Vergi Borcunuz $karZarar TL ');
    }
  }

  AssetImage changeIcon(int language) {
    if (language == 0) {
      return AssetImage('lib/assets/images/icon_stock_biref_case.png');
    } else {
      return AssetImage('lib/assets/images/icon_stock_brief_case_tr.png');
    }
  }

  Text showDateText(DateTime selectDate) {
    setState(() {});
    if (selectDate != DateTime(0000, 00, 00)) {
      return Text(
        "${selectDate.day}/${selectDate.month}/${selectDate.year}",
        style: TextStyle(
          color: Colors.black,
        ),
      );
    } else {
      return Text(
        processDate,
        style: TextStyle(
          color: Colors.black,
        ),
      );
    }
  }

  Widget createSellProcess(
      int dropdown, double phoneWidth, double phoneHeight) {
    List<Widget> columns = [];

    if (dropdown > 1) {
      for (int i = 1; i < dropdown; i++) {
        columns.add(
          Column(
            children: [
              Container(child: Image.asset("lib/assets/images/image-next.png")),
              Padding(
                padding: EdgeInsets.fromLTRB(phoneWidth * 0.01,
                    phoneHeight * 0.01, phoneWidth * 0.01, phoneHeight * 0.01),
                child: Container(
                  width: phoneWidth * 0.9,
                  height: phoneHeight * 0.35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        90), // Reduced border radius for a more subtle curve
                    color: Color.fromRGBO(46, 204, 113, 1),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        phoneWidth * 0.08,
                        phoneHeight * 0.01,
                        phoneWidth * 0.08,
                        phoneWidth * 0.08),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text("${(i + 1)}. Satım İşlemi",
                                style: ElevatedText.buildJosefinSans(0.5, 24),
                                textAlign: TextAlign.center)
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: phoneHeight * 0.01),
                          child: Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2005),
                                    lastDate: DateTime.now(),
                                  ).then((mselectedDate) async {
                                    if (mselectedDate != null) {
                                      setState(() {
                                        _sellSelectedDate[i] = mselectedDate;
                                        getBuyUFEIndex(mselectedDate, i);
                                        getSellExchangeRate(mselectedDate, i);
                                      });
                                    }
                                  });
                                },
                                style: ButtonStyle(
                                  elevation: MaterialStateProperty.all(0),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          15), // Adjusted button border radius
                                    ),
                                  ),
                                  backgroundColor: MaterialStateProperty.all(
                                      CupertinoColors.systemGrey4),
                                  minimumSize: MaterialStateProperty.all(Size(
                                      phoneWidth * 0.5,
                                      phoneHeight *
                                          0.05)), // Adjusted the minimum size for the button
                                ),
                                child: showDateText(_sellSelectedDate[i]),
                              ),
                              Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    "lib/assets/images/icon_date.png",
                                    width: 48,
                                    height: 48,
                                  ))
                            ],
                          ),
                        ),
                        /* SizedBox(height: 20),
                      open
                          ? Text(
                              'Exchange Rate: ${_buyExchangeRate[i]}',
                              style: TextStyle(fontSize: 20),
                            )
                          : Text('Boş'),
                      SizedBox(height: 20),
                      Text(
                        'Yİ-ÜFE Endeks Değeri: ${_buyUfeIndex[i]}',
                        style: TextStyle(fontSize: 20),
                      ),*/
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  labelText: ('Hisse Değerini Girin'),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 16.0),
                                  filled: true,
                                  fillColor: CupertinoColors.systemGrey4,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                onChanged: (value) {
                                  setState(() {
                                    final numberFormat =
                                        NumberFormat.decimalPattern();
                                    final parsedValue =
                                        numberFormat.parse(value);
                                    sellStockPrice[i] = parsedValue.toDouble();
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: TextField(
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  labelText: 'Hisse Miktarı Girin',
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 20.0),
                                  filled: true,
                                  fillColor: CupertinoColors.systemGrey4,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                onChanged: (value) {
                                  setState(() {
                                    final numberFormat =
                                        NumberFormat.decimalPattern();
                                    final parsedValue =
                                        numberFormat.parse(value);
                                    sellStockQuantity[i] =
                                        parsedValue.toDouble();
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
      return Column(
        children: columns,
      );
    } else {
      return SizedBox.shrink(); // Returns an empty widgets (unvisible)
    }
  }

  Widget createBuyProcess(int dropdown, double phoneWidth, double phoneHeight) {
    List<Widget> columns = [];

    if (dropdown > 1) {
      for (int i = 1; i < dropdown; i++) {
        columns.add(
          Column(
            children: [
              Container(child: Image.asset("lib/assets/images/image-next.png")),
              Padding(
                padding: EdgeInsets.fromLTRB(phoneWidth * 0.01,
                    phoneHeight * 0.01, phoneWidth * 0.01, phoneHeight * 0.01),
                child: Container(
                  width: phoneWidth * 0.9,
                  height: phoneHeight * 0.35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        90), // Reduced border radius for a more subtle curve
                    color: Color.fromRGBO(46, 204, 113, 1),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        phoneWidth * 0.08,
                        phoneHeight * 0.01,
                        phoneWidth * 0.08,
                        phoneWidth * 0.08),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text("${(i + 1)}. Alış İşlemi",
                                style: ElevatedText.buildJosefinSans(0.5, 24),
                                textAlign: TextAlign.center)
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: phoneHeight * 0.01),
                          child: Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2005),
                                    lastDate: DateTime.now(),
                                  ).then((mselectedDate) async {
                                    if (mselectedDate != null) {
                                      setState(() {
                                        _buySelectedDate[i] = mselectedDate;
                                        getBuyUFEIndex(mselectedDate, i);
                                        getBuyExchangeRate(mselectedDate, i);
                                      });
                                    }
                                  });
                                },
                                style: ButtonStyle(
                                  elevation: MaterialStateProperty.all(0),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          15), // Adjusted button border radius
                                    ),
                                  ),
                                  backgroundColor: MaterialStateProperty.all(
                                      CupertinoColors.systemGrey4),
                                  minimumSize: MaterialStateProperty.all(Size(
                                      phoneWidth * 0.5,
                                      phoneHeight *
                                          0.05)), // Adjusted the minimum size for the button
                                ),
                                child: showDateText(_buySelectedDate[i]),
                              ),
                              Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    "lib/assets/images/icon_date.png",
                                    width: 48,
                                    height: 48,
                                  ))
                            ],
                          ),
                        ),
                        /* SizedBox(height: 20),
                      open
                          ? Text(
                              'Exchange Rate: ${_buyExchangeRate[i]}',
                              style: TextStyle(fontSize: 20),
                            )
                          : Text('Boş'),
                      SizedBox(height: 20),
                      Text(
                        'Yİ-ÜFE Endeks Değeri: ${_buyUfeIndex[i]}',
                        style: TextStyle(fontSize: 20),
                      ),*/
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  labelText: ('Hisse Değerini Girin'),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 16.0),
                                  filled: true,
                                  fillColor: CupertinoColors.systemGrey4,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                onChanged: (value) {
                                  setState(() {
                                    final numberFormat =
                                        NumberFormat.decimalPattern();
                                    final parsedValue =
                                        numberFormat.parse(value);
                                    buyStockQuantity[i] =
                                        parsedValue.toDouble();
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: TextField(
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  labelText: 'Hisse Miktarı Girin',
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 20.0),
                                  filled: true,
                                  fillColor: CupertinoColors.systemGrey4,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                onChanged: (value) {
                                  setState(() {
                                    final numberFormat =
                                        NumberFormat.decimalPattern();
                                    final parsedValue =
                                        numberFormat.parse(value);
                                    buyStockQuantity[i] =
                                        parsedValue.toDouble();
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
      return Column(
        children: columns,
      );
    } else {
      return SizedBox.shrink(); // Returns an empty widgets (unvisible)
    }
  }
}
