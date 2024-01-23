import 'package:get_data/assets/screens/calculate_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';


const ws = const Color(0xFFB74093);
enum SampleItem { Turkish, English }
void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Header", //IS IT OKAY?
      theme: ThemeData(
        primaryColor: Colors.amber,
        //  primarySwatch: myColor,
      ),

      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  SampleItem? selectedMenu;
  final Widget? language_icon =  Icon(
    Icons.language,
    color: Colors.white,
    size: 24.0,
    semanticLabel: 'Text to announce in accessibility modes',
  );

 


  @override
  Widget build(BuildContext context) {
    double phoneHeight = MediaQuery.of(context ).size.height;
    double phoneWidth = MediaQuery.of(context ).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(26, 204, 113, 1),
        title: Text('Vergini Hesapla'),
        actions: [
          Padding(
            padding: EdgeInsets.fromLTRB(phoneWidth*0.02,phoneHeight*0.013,phoneWidth*0.02,phoneHeight*0.01),
            child: PopupMenuButton<SampleItem>(
              //color:Colors.white10, //Change Language Selection Background Color

                icon: language_icon,
                initialValue: selectedMenu,
                // Callback that sets the selected popup menu item.
                onSelected: (SampleItem item) {
                  setState(() {
                    selectedMenu = item;
                  });
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
                  PopupMenuItem<SampleItem>(
                    value: SampleItem.Turkish,
                    child:Row(
                      children: [
                        Container(
                          height:25,
                          width: 25,
                          child:Image.asset("lib/assets/images/turkey.png", width:10, height:10,),
                        ),
                       
                        Padding(
                          padding: EdgeInsets.all(phoneWidth * 0.02),
                            child: Text("Türkçe"))
                      ],
                    ) 
                  ),
                   PopupMenuItem<SampleItem>(
                    value: SampleItem.English,
                    child: Row(
                      children: [
                        Container(
                          height:25,
                          width: 25,
                          child:Image.asset("lib/assets/images/united_kingdom.png", width:10, height:10,),
                        ),

                        Padding(
                            padding: EdgeInsets.all(phoneWidth * 0.02),
                            child: Text("İngilizce"))
                      ],
                    ) ,
                  )]
            )
          ),
        ],
      ),
      body: Container(
        color:Color.fromRGBO(26, 188, 156, 0.25),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white10),
                  borderRadius: BorderRadius.circular(75),
                  color: Color.fromRGBO(46, 204, 113, 1),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.05,
                        horizontal: MediaQuery.of(context).size.width * 0.1,
                      ),
                      child: ElevatedButton.icon(
                        icon: Icon(
                          // <-- Icon
                          Icons.arrow_forward_ios,
                          color: Colors.black,
                          size: 24.0,
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context) //Close Info Pop-Up
                            ..hideCurrentSnackBar();

                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: Duration(milliseconds: 500),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                return SlideTransition(
                                  position: animation.drive(
                                    Tween(
                                        begin: Offset(1.0, 0.0),
                                        end: Offset.zero)
                                        .chain(
                                      CurveTween(curve: Curves.easeOut),
                                    ),
                                  ),
                                  child: child,
                                );
                              },
                              pageBuilder:
                                  (context, animation, secondaryAnimation) {
                                return Calculate_Screen(whichShare: 1,processCount: 1,flagProcessCount: 1,);
                              },
                            ),
                          );
                        },
                        style: ButtonStyle(
                          shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.white10))),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromRGBO(209, 222, 225, 1)),
                          minimumSize: MaterialStateProperty.all<Size>(
                            Size(MediaQuery.of(context).size.width * 0.5, 60),
                          ),
                        ),
                        label: Text('Vergini Hesapla',
                            style: TextStyle(color: Colors.black, fontSize: 16)),
                      ),

                    ),
                    ElevatedButton.icon(
                      icon: Icon(
                        // <-- Icon
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                        size: 24.0,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context) //Close Info Pop-Up
                          ..hideCurrentSnackBar();

                      },
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.white10))),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromRGBO(209, 222, 225, 1)),
                        minimumSize: MaterialStateProperty.all<Size>(
                          Size(MediaQuery.of(context).size.width * 0.3, 60),
                        ),
                      ),
                      label: Text('Bilgilendirme',
                          style: TextStyle(color: Colors.black, fontSize: 16)),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(phoneWidth * 0.01, phoneHeight * 0.4, phoneWidth * 0.01, phoneHeight* 0.05),
                child: ElevatedButton(
                  onPressed: () {


                    final snackBar = SnackBar(
                      /// need to set following properties for best effect of awesome_snackbar_content
                      elevation: 0,
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      content: AwesomeSnackbarContent(
                        title: '   toerlinx@gmail.com',
                        message: "     ~ToerLinx Studio",

                        /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                        contentType: ContentType.failure,
                      ),
                    );

                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(snackBar);
                  },
                  child: Text("İletişim Bilgileri"),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.white10))),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromRGBO(238, 59, 59, 0.6980392156862745)),
                    minimumSize: MaterialStateProperty.all<Size>(
                      Size(MediaQuery.of(context).size.width * 0.3, 60),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


