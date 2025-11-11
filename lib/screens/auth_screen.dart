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
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
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
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  Gap(30),
                  Padding(
                    padding: const EdgeInsets.only(left: 150, right: 150),
                    child: SizedBox(
                      height: 60,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : signInWithGoogle,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/google.png',
                              width: 25,
                              height: 25,
                            ),
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
                    onPressed: _isLoading ? null : signInAsGuest,
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
            ),
          ),
          // Loading overlay
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.7),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 4,
                    ),
                    Gap(20),
                    Text(
                      "Signing in with Google...",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
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

  void signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userCredential = await authService.signInWithGoogle();

      if (userCredential == null) {
        // User canceled the sign-in
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final user = userCredential.user;

      if (user != null) {
        // Save user data to Firestore with their Google display name
        await firestoreService.saveUser(user.uid, user.displayName);

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        }
      }
    } catch (e) {
      print('Error during Google Sign-In: $e');
      setState(() {
        _isLoading = false;
      });
      // Optionally show an error dialog to the user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to sign in with Google. Please try again.'),
          ),
        );
      }
    }
  }
}
