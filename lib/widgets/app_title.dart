import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class AppTitle extends StatelessWidget {
  const AppTitle({
    super.key,
    required this.screenHeight,
  });

  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Container(
        height: screenHeight * 0.25,
        width: double.infinity,
        color: Colors.teal,
        child: Center(
          child: Row(
            children: [
              Expanded(
                child: Lottie.asset('assets/images/chat.json', repeat: false),
              ),
              Expanded(
                child: Text(
                  'Chat Z',
                  style: TextStyle(
                    fontFamily: GoogleFonts.lato().fontFamily,
                    color: Colors.black,
                    fontSize: 40.0,
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
