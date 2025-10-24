import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class GoogleConnectScreen extends StatelessWidget {
  const GoogleConnectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E1E1E),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/rmbg.png"),
          Text(
            "Sungka Master",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              fontSize: 45,
              color: Colors.white,
            ),
          ),
          Text(
            "Welcome! Sign in to start your Sungka journey.",
            style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
          ),
          Gap(30),
          Padding(
            padding: const EdgeInsets.only(left: 150, right: 150),
            child: Container(
              height: 60,
              child: ElevatedButton(
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/google.png', width: 25, height: 25),
                    Gap(15),
                    Text(
                      "Continue with Google Account.",
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Gap(25),
          TextButton(
            onPressed: () {},
            child: Text(
              "Continue as Guest",
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Color(0xFFE6B428),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
