import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screens/register.dart';

class CustomButton extends StatelessWidget {
  final String text;
  Color btncolor;
  dynamic route;
  CustomButton(
      {Key? key,
      required this.text,
      required this.btncolor,
      this.route = const RegisterScreen()})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: btncolor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => route),
          );
        },
        child: Text(
          text,
          style: GoogleFonts.roboto(
              fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
