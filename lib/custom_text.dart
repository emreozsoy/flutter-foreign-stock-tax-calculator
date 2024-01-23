import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ElevatedText extends StatelessWidget {
  final String text;
  final double phoneHeight;
  final double phoneWidth;

  ElevatedText({required this.text, required this.phoneHeight, required this.phoneWidth});

  static TextStyle buildJosefinSans(double lttrSpace, double fontSize) {
    return GoogleFonts.josefinSans(
      textStyle: TextStyle(
        letterSpacing: lttrSpace,
        fontSize: fontSize,
        color: Colors.black,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: phoneHeight * 0.06,
      width: phoneWidth * 0.6,
      margin: EdgeInsets.fromLTRB(phoneWidth * 0.05, phoneHeight * 0.01, phoneWidth * 0.05, phoneHeight * 0.01),
      decoration: BoxDecoration(
        color: Color.fromRGBO(26, 188, 156, 0.25), // Set your desired background color
        borderRadius: BorderRadius.circular(16.0), // Set your desired border radius
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0), // Set your desired padding
        child: Center(
          child: Text(
            text,
            style: buildJosefinSans(0.0, 18.0), // Adjust the letterSpacing and fontSize accordingly
          ),
        ),
      ),
    );
  }
}
