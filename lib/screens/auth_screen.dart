import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sungka/core/services/firebase_auth_service.dart';
import 'package:sungka/core/services/firebase_firestore_service.dart';
import 'package:sungka/screens/home_screen.dart';


class AuthScreen extends StatefulWidget {
  AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final authService = FirebaseAuthService();
  final firestoreService = FirebaseFirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                onPressed: () {
                  authService.logout();
                },
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
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              ),
            ),
          ),
          Gap(25),
          TextButton(
            onPressed: signInAsGuest,
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

  void signInAsGuest() async {
    try {
      final userCredential = await authService.signInAsGuest();
      final user = userCredential.user;

      if (user != null) {
        await firestoreService.saveUser(user.uid, null);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    } catch (e) {
      print(e);
    }
  }
}
