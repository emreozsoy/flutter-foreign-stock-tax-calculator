import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart' as parser;
import 'package:intl/intl.dart';

class Calculate_Screen extends StatefulWidget {
  final int whichShare;
  Calculate_Screen({required this.whichShare});
  @override
  _Calculate_ScreenState createState() => _Calculate_ScreenState();
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // runApp(Calculate_Screen());
}

class _Calculate_ScreenState extends State<Calculate_Screen> {
  //İngilizce DİL DESTEĞİ İÇİN 2 FARKLI TEXT LİSTESİ OLUŞTURUP DURUMA GÖRE HANGİSİNİN VERİLMESİ GEREKTİĞİNİ YAZ
  //FAZLA BÜYÜK SAYI GİRİLMESİNE UYARI SİSTEMİ EKLE
  //EKRANI BAŞKA BİR FLUTTER PROJESİNDE TASARLA
  //NOT BIRAKMAYI UNUTMA ÇOK İŞE YARIYORLAR

  int? _buyProcess = 1;
  String? selectedValue;
  int firstBuyStock=0;

  bool open = false;
  List<double> buyStockPrice = <double>[0, 0, 0];
  List<double> buyStockCount = <double>[0, 0, 0];

  List<double> sellStockPrice = <double>[0, 0, 0];
  List<double> sellStockCount = <double>[0, 0, 0];

  var _selectedDate = <DateTime>[
    DateTime(2023, 5, 1),
    DateTime(2023, 5, 2),
    DateTime(2023, 5, 3),
    DateTime(2023, 5, 4),
    DateTime(2023, 5, 5),
  ];

  var _buyExchangeRate = <String>["", "", "", "", "", "", "", "", "", ""];
  var _sellExchangeRate = <String>["", "", "", "", "", "", "", "", "", ""];

  var _buyUfeIndex = <double>[0, 0, 0, 0, 0, 0, 0];
  var _sellUfeIndex = <double>[0, 0, 0, 0, 0, 0];

  static List<int> list = <int>[1, 2, 3, 4, 5];
  late int bDropDownValue=1;
  int? buyDropDownValue ;
  int sellDropDownValue = 1;

  Future<String> fetchUfeIndex(DateTime selectedDate) async {
    final url =
        'https://www.hakedis.org/endeksler/yi-ufe-yurtici-uretici-fiyat-endeksi';
    final response = await http.get(Uri.parse(url));
    List<String> monthConvert = [
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
      final tableRows = document
          .querySelector('body > section > div > div > div > div > table');

      //final yi_ufes= document.querySelector('body > section > div > div > div > div > table > tbody > tr:nth-child(1)')?.children;

      final yi_ufes = document
          .querySelector(
              'body > section > div > div > div > div > table > tbody > tr:nth-child($year)')
          ?.children;

      final months = document
          .querySelector(
              'body > section > div > div > div > div > table > thead > tr')
          ?.children;
      if (yi_ufes != null && months != null) {
        for (final month in months) {
          if (month == monthConvert[selectedDate.month - 1]) {
            print(month.text);
          }
        }
        for (final yi_ufe in yi_ufes) {
          print(yi_ufe.text);
        }
      }

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

    return ''; // Veri bulunamazsa boş bir değer döndür
  }

  int whichYear(DateTime year) {
    print("Bak year ${year.year}");

    switch (year.year) {
      case 2023:
        return 1;
      case 2022:
        return 3;
      case 2021:
        return 5;
      case 2020:
        return 7;
      case 2019:
        return 9;
      case 2018:
        return 11;
      case 2017:
        return 13;
      case 2016:
        return 15;
      case 2015:
        return 17;
      case 2014:
        return 19;
      case 2013:
        return 21;
      case 2012:
        return 23;
      case 2011:
        return 25;
      case 2010:
        return 27;
      case 2009:
        return 29;
      case 2008:
        return 31;
      case 2007:
        return 33;
      case 2006:
        return 35;
      case 2005:
        return 37;
      default:
        return 0;
    }
  }

  Future<String> fetchExchangeRate(DateTime date) async {
    date = date.subtract(Duration(days: 1));
    final formattedDate =
        '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
    final url =
        'https://evds2.tcmb.gov.tr/service/evds/series=TP.DK.USD.A&startDate=$formattedDate&endDate=$formattedDate&type=json&key=3uMaWC6vsa';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['items'] != null && data['items'].isNotEmpty) {
        final exchangeRate = data['items'][0]['TP_DK_USD_A'];

        print("Bu exchange rate${exchangeRate} buda selectedate ${date}");

        if (exchangeRate == "null" || exchangeRate == null) {
          fetchExchangeRate(date);
        } else {
          open = true;
          print("Haklı mıyım${exchangeRate.toString()}");
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
  void getUFEIndex(DateTime selectedDate, int i) {
    DateTime holdDate;
    final year = selectedDate.year;
    final month = selectedDate.month;
    holdDate = selectedDate.subtract(Duration(days: 30));

    fetchUfeIndex(holdDate).then((ufeIndex) {
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

    fetchUfeIndex(holdDate).then((ufeIndex) {
      setState(() {
        final numberFormat = NumberFormat
            .decimalPattern(); // Sayı biçimlendirme için NumberFormat kullanılır
        final parsedValue = numberFormat.parse(ufeIndex);
        _sellUfeIndex[i] = parsedValue.toDouble();

        print("Ufe değeri atandı $i: ${_buyUfeIndex[i]}");
      });
    });
  }

  void getExchangeRate(DateTime selectedDate, int i) async {
    _buyExchangeRate[i] = await fetchExchangeRate(selectedDate);
    print("Değeri ne : ${_buyExchangeRate[i]}");
    if (_buyExchangeRate[i] == "null" || _buyExchangeRate[i] == null) {
      print("çalıştı mı?");
      selectedDate = selectedDate.subtract(Duration(days: 1));
      _buyExchangeRate[i] = await fetchExchangeRate(selectedDate);
    }
    setState(() {});
  }

  void getSellExchangeRate(DateTime selectedDate, int i) async {
    _sellExchangeRate[i] = await fetchExchangeRate(selectedDate);
    if (_sellExchangeRate[i] == "null" || _sellExchangeRate[i] == null) {
      print("çalıştı mı?");
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
        backgroundColor: Color.fromRGBO(46, 204, 113, 1),
        title: Text('1. Hisse İşlemleri',
            textAlign: TextAlign.start, style: GoogleFonts.cabin()),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: phoneHeight * 0.01),
              Visibility(
                visible: widget.whichShare == 1,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(phoneWidth * 0.1,
                      phoneHeight * 0.01, phoneWidth * 0.15, phoneHeight * 0.01),
                  child: Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField2<String>(
                          isExpanded: true,
                          decoration: InputDecoration(
                            hoverColor: Colors.blue,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                            // Diğer dekorasyon ayarlarını burada ekleyin
                          ),
                          hint: Text(
                            'İşlem Yapılan Hisse Sayısı',
                            textAlign: TextAlign.center,
                            style: buildJosefinSans(0.5, 16),
                          ),
                          items: list
                              .map((item) => DropdownMenuItem<String>(
                                    value: item.toString(),
                                    child: Text(
                                      item.toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 16,
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
                            // Seçilen öğe değiştiğinde yapılacak işlemler
                          },
                          onSaved: (value) {
                            selectedValue = value.toString();
                          },
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.only(right: 8),
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
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(phoneWidth * 0.025),
                        child: Image(
                          image: AssetImage(
                              'lib/assets/images/icon _bar chart_.png'), // Eklemek istediğiniz resmin yolunu belirtin
                          width: 32, // Resmin genişliği
                          height: 32, // Resmin yüksekliği
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
                padding: EdgeInsets.fromLTRB(phoneWidth * 0.1,
                    phoneHeight * 0.01, phoneWidth * 0.15, phoneHeight * 0.01),
                child: DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    hoverColor: Colors.blue,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    // Adjust the height to center the hint text vertically
                    isDense: true,
                  ),
                  value: buyDropDownValue,
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  style: TextStyle(
                    color: Colors.deepPurple,
                  ),
                  onChanged: (int? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      buyDropDownValue = value!;
                      bDropDownValue = buyDropDownValue!;
                    });
                  },
                  hint: Text(
                    '         Satın Alınan Hisse Sayısı', //??fix center problem
                    textAlign: TextAlign.center,
                    style: buildJosefinSans(0.5, 16),
                  ),
                  items: list.map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      alignment: AlignmentDirectional.center,
                      value: value,
                      child: Text(value.toString(), textAlign: TextAlign.center,),
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(phoneWidth * 0.01,
                    phoneHeight * 0.01, phoneWidth * 0.01, phoneHeight * 0.01),
                child: Container(
                  width: phoneWidth * 0.9,
                  height: phoneHeight * 0.35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(90), // Reduced border radius for a more subtle curve
                    color: Color.fromRGBO(46, 204, 113, 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0), // Added padding for better spacing
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                                getUFEIndex(selectedDate, 0);
                                getExchangeRate(selectedDate, 0);
                                //LİSTE OLUŞTUR eğer gönderilen getExchangeRate e 1 ise buna ver değer fln filan
                              }
                            });
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15), // Adjusted button border radius
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all(Colors.white),
                            minimumSize: MaterialStateProperty.all(Size(
                                phoneWidth * 0.5,
                                phoneHeight * 0.05)), // Adjusted the minimum size for the button
                          ),
                          child: Text(
                            'İşlem Tarihi',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            labelText: ('Hisse Değerini Girin: '),
                            contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          onChanged: (value) {
                            setState(() {
                              final numberFormat = NumberFormat.decimalPattern();
                              final parsedValue = numberFormat.parse(value);
                              buyStockPrice[0] = parsedValue.toDouble();
                            });
                          },
                        ),
                        SizedBox(height: 16.0),
                        TextField(
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            labelText: ('Hisse Miktarını Girin: '),
                            contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          onChanged: (value) {
                            setState(() {
                              final numberFormat = NumberFormat.decimalPattern();
                              final parsedValue = numberFormat.parse(value);
                              buyStockCount[0] = parsedValue.toDouble();
                            });
                          },
                        ),
                        SizedBox(height: 16.0),

                      ],
                    ),
                  ),
                ),
              ),
              getItDone(bDropDownValue),
              Text(
                '--------------Satılan Hisse--------------',
                style: TextStyle(fontSize: 30),
              ),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      //_buyProcess =_buyProcess! +1;
                      // getItDone(_buyProcess!);
                    });
                  },
                  child: Text("Ekle")),
              ElevatedButton(
                onPressed: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2005),
                    lastDate: DateTime.now(),
                  ).then((mselectedDate) async {
                    if (mselectedDate != null) {
                      getSellUFEIndex(mselectedDate, 0);

                      getSellExchangeRate(mselectedDate, 0);

                      //LİSTE OLUŞTUR eğer gönderilen getExchangeRate e 1 ise buna ver değer fln filan
                    }
                  });
                },
                child: Text('İşlem Tarihi'),
              ),
              SizedBox(height: 20),
              open
                  ? Text(
                      'Exchange Rate: ${_sellExchangeRate[0]}',
                      style: TextStyle(fontSize: 20),
                    )
                  : Text('Boş'),
              SizedBox(height: 20),
              Text(
                'Yİ-ÜFE Endeks Değeri: ${_sellUfeIndex[0]}',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Hisse Değerini Girin',
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  setState(() {
                    final numberFormat = NumberFormat
                        .decimalPattern(); // Sayı biçimlendirme için NumberFormat kullanılır
                    final parsedValue = numberFormat.parse(value);
                    sellStockPrice[0] = parsedValue.toDouble();
                  });
                },
              ),
              SizedBox(height: 16.0),
              Text(
                'Input value: ${sellStockPrice[0]}',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Hisse Miktarı Girin',
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  setState(() {
                    final numberFormat = NumberFormat
                        .decimalPattern(); // Sayı biçimlendirme için NumberFormat kullanılır
                    final parsedValue = numberFormat.parse(value);
                    sellStockCount[0] = parsedValue.toDouble();
                  });
                },
              ),
              SizedBox(height: 16.0),
              Text(
                'Input value: ${sellStockCount[0]}',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.all(20),
        child: FloatingActionButton(
          onPressed: () {
            double buySum = 0;
            double sellSum = 0;
            /* buySum =  (buyStockCount! * buyStockPrice! * double.parse(_exchangeRate[0]));
              sellSum =  (sellStockCount! * sellStockPrice! * double.parse(_exchangeRate[0]));

              print(sellSum);
              print(buySum);
              double sum = sellSum - buySum;
              String result = sum.toStringAsFixed(4); // virgülden sonra 4 haneyi yazar
              print(result);
              */
            /*while(x<5){
                print("exchangerate[$x] = ${_exchangeRate[x]}");
                print("ufeındex[$x]=${_ufeIndex[x]}");
                x++;
              }
               */

            // Alış işlemleri
            for (int i = 0; i < bDropDownValue; i++) {
              double buyMaliyet = buyStockPrice[i] *
                  buyStockCount[i] *
                  double.parse(_buyExchangeRate[i]);

              // Alış maliyetini enflasyon ile endeksleme
              if (_buyUfeIndex[i] > 1.1) {
                double inflationRate =
                    (_buyUfeIndex[i] - 1) * 100; // Yİ-ÜFE artış oranı hesaplama
                buyMaliyet *= inflationRate / 100; // Alış maliyetini endeksleme
              }

              buySum += buyMaliyet;
            }

            // Satış işlemleri
            for (int i = 0; i < sellDropDownValue; i++) {
              double sellMaliyet = sellStockPrice[i] *
                  sellStockCount[i] *
                  double.parse(_sellExchangeRate[i]);
              sellSum += sellMaliyet;
            }

            double karZarar = sellSum - buySum;

            // Vergi hesaplama ve yazdırma
            if (karZarar > 0) {
              double vergi = karZarar * 0.15; // %15 vergi oranı

              print('Kazanç: $karZarar TL');
              print('Vergi Borcu: $vergi TL');
            } else {
              print('Kazanç yok');
              print('Vergi Borcunuz "0"TL ');
            }
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

  TextStyle buildJosefinSans(double lttrSpace, double fontSize) {
    return GoogleFonts.josefinSans(
      textStyle: TextStyle(letterSpacing: lttrSpace, fontSize: fontSize),
    );
  }

  Widget getItDone(int dropdown) {
    if( dropdown == null){
      dropdown=1;
    }

    List<Widget> columns = [];

    if (dropdown > 1) {
      for (int i = 1; i < dropdown; i++) {
        columns.add(
          Column(
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
                      getUFEIndex(mselectedDate, i);
                      getExchangeRate(mselectedDate, i);
                    }
                  });
                },
                child: Text('İşlem Tarihi'),
              ),
              SizedBox(height: 20),
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
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Hisse Değerini Girin',
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  setState(() {
                    final numberFormat = NumberFormat.decimalPattern();
                    final parsedValue = numberFormat.parse(value);
                    sellStockPrice[i] = parsedValue.toDouble();
                  });
                },
              ),
              SizedBox(height: 16.0),
              Text(
                'Input value: ${sellStockPrice[i]}',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Hisse Miktarı Girin',
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  setState(() {
                    final numberFormat = NumberFormat.decimalPattern();
                    final parsedValue = numberFormat.parse(value);
                    sellStockCount[i] = parsedValue.toDouble();
                  });
                },
              ),
              SizedBox(height: 16.0),
              Text(
                'Input value: ${sellStockCount[i]}',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        );
      }
      return Column(
        children: columns,
      );
    } else {
      return SizedBox
          .shrink(); // Boş bir widget döndür (görünmez) // Returns an empty widgets (unvisible)
    }
  }
}
