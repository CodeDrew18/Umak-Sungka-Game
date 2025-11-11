// import 'package:flutter/material.dart';
// import 'package:flame/game.dart';
// import 'package:sungka/core/services/firebase_auth_service.dart';
// import 'package:sungka/core/services/firebase_firestore_service.dart';
// import 'package:sungka/screens/auth/auth_game.dart';
// import 'package:sungka/screens/start_game_screen.dart';
// import 'package:sungka/screens/username_screen.dart';

// class AuthScreen extends StatefulWidget {
//   final Function(Widget screen) navigateToScreen;
//   final Function(String message) showError;

//   const AuthScreen({
//     super.key,
//     required this.navigateToScreen,
//     required this.showError,
//   });

//   @override
//   State<AuthScreen> createState() => _AuthScreenState();
// }

// class _AuthScreenState extends State<AuthScreen> {
//   final authService = FirebaseAuthService();
//   final firestoreService = FirebaseFirestoreService();
//   late AuthGame authGame;

//   @override
//   void initState() {
//     super.initState();
//     authGame = AuthGame(
//       onGoogleSignIn: _handleGoogleSignIn,
//       onGuestSignIn: _handleGuestSignIn,
//     );
//   }

//   Future<void> _handleGoogleSignIn() async {
//     try {
//       await authService.logout();
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => GameWidget(
//             game: StartMenuGame(
//               navigateToScreen: widget.navigateToScreen,
//               showError: widget.showError,
//             ),
//           ),
//         ),
//       );
//     } catch (e) {
//       print('Google Sign-In Error: $e');
//     }
//   }

//   Future<void> _handleGuestSignIn() async {
//     try {
//       final userCredential = await authService.signInAsGuest();
//       final user = userCredential.user;

//       if (user != null) {
//         await firestoreService.saveUser(user.uid, null);
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => GameWidget(
//               game: UsernameScreen(
//                 navigateToScreen: widget.navigateToScreen,
//                 showError: widget.showError,
//               ),
//             ),
//           ),
//         );
//       }
//     } catch (e) {
//       print('Guest Sign-In Error: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GameWidget(game: authGame),
//     );
//   }

//   @override
//   void dispose() {
//     authGame.removeFromParent();
//     super.dispose();
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flame/game.dart';
// import 'package:sungka/core/services/firebase_auth_service.dart';
// import 'package:sungka/core/services/firebase_firestore_service.dart';
// import 'package:sungka/screens/auth/auth_game.dart';
// import 'package:sungka/screens/start_game_screen.dart';
// import 'package:sungka/screens/username_screen.dart';

// class AuthScreen extends StatefulWidget {
//   final Function(Widget screen) navigateToScreen;
//   final Function(String message) showError;

//   const AuthScreen({
//     super.key,
//     required this.navigateToScreen,
//     required this.showError,
//   });

//   @override
//   State<AuthScreen> createState() => _AuthScreenState();
// }

// class _AuthScreenState extends State<AuthScreen> {
//   final authService = FirebaseAuthService();
//   final firestoreService = FirebaseFirestoreService();
//   late AuthGame authGame;
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     authGame = AuthGame(
//       onGoogleSignIn: signInWithGoogle,
//       onGuestSignIn: _handleGuestSignIn,
//     );
//   }

//  void signInWithGoogle() async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final userCredential = await authService.signInWithGoogle();

//       if (userCredential == null) {
//         // User canceled the sign-in
//         setState(() {
//           _isLoading = false;
//         });
//         return;
//       }

//       final user = userCredential.user;

//       if (user != null) {
//         // Save user data to Firestore with their Google display name
//         await firestoreService.saveUser(user.uid, user.displayName);

//         if (mounted) {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => StartMenuGame(
//               navigateToScreen: widget.navigateToScreen,
//               showError: widget.showError,
//             )),
//           );
//         }
//       }
//     } catch (e) {
//       print('Error during Google Sign-In: $e');
//       setState(() {
//         _isLoading = false;
//       });

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Failed to sign in with Google. Please try again.'),
//           ),
//         );
//       }
//     }
//   }

//   Future<void> _handleGuestSignIn() async {
//     try {
//       final userCredential = await authService.signInAsGuest();
//       final user = userCredential.user;

//       if (user != null) {
//         await firestoreService.saveUser(user.uid, null);

//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => UsernameScreen(
//               // --- FIX APPLIED HERE ---
//               navigateToScreen: widget.navigateToScreen,
//               showError: widget.showError,
//               // ------------------------
//             ),
//           ),
//         );
//       }
//     } catch (e) {
//       print('Guest Sign-In Error: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GameWidget(game: authGame),
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }
// }

import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:sungka/core/services/firebase_auth_service.dart';
import 'package:sungka/core/services/firebase_firestore_service.dart';
import 'package:sungka/screens/auth/auth_game.dart';
import 'package:sungka/screens/start_game_screen.dart';
import 'package:sungka/screens/username_screen.dart';

class AuthScreen extends StatefulWidget {
  final Function(Widget screen) navigateToScreen;
  final Function(String message) showError;

  const AuthScreen({
    super.key,
    required this.navigateToScreen,
    required this.showError,
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final authService = FirebaseAuthService();
  final firestoreService = FirebaseFirestoreService();
  late AuthGame authGame;
  bool _isLoading = false;
  String _loadingMessage = '';

  @override
  void initState() {
    super.initState();
    authGame = AuthGame(
      onGoogleSignIn: signInWithGoogle,
      onGuestSignIn: _handleGuestSignIn,
    );
  }

  void signInWithGoogle() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _loadingMessage = "Signing in with Google...\nPlease wait...";
    });

    final startTime = DateTime.now();

    try {
      final userCredential = await authService.signInWithGoogle();

      if (userCredential == null) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        return;
      }

      final user = userCredential.user;

      if (user != null) {
        await firestoreService.saveUser(user.uid, user.displayName);

        // Ensure loading screen shows for at least 1 second
        final elapsed = DateTime.now().difference(startTime);
        if (elapsed.inMilliseconds < 1000) {
          await Future.delayed(
            Duration(milliseconds: 1000 - elapsed.inMilliseconds),
          );
        }

        if (mounted) {
          final nextScreen = GameWidget(
            game: StartMenuGame(
              navigateToScreen: widget.navigateToScreen,
              showError: widget.showError,
            ),
          );

          widget.navigateToScreen(nextScreen);
        }
      }
    } catch (e) {
      print('Error during Google Sign-In: $e');

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        widget.showError('Failed to sign in with Google. Please try again.');
      }
    }
  }

  Future<void> _handleGuestSignIn() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _loadingMessage = "Signing in as Guest...";
    });

    try {
      final userCredential = await authService.signInAsGuest();
      final user = userCredential.user;

      if (user != null) {
        await firestoreService.saveUser(user.uid, null);

        final nextScreen = UsernameScreen(
          navigateToScreen: widget.navigateToScreen,
          showError: widget.showError,
        );

        widget.navigateToScreen(nextScreen);
      }
    } catch (e) {
      print('Guest Sign-In Error: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        widget.showError('Failed to sign in as guest. Please try again.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GameWidget(game: authGame),
          // Loading overlay
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.85),
              width: double.infinity,
              height: double.infinity,
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Color(0xFFE6B428), width: 3),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFFE6B428),
                          ),
                          strokeWidth: 8,
                        ),
                      ),
                      SizedBox(height: 30),
                      Text(
                        _loadingMessage,
                        style: TextStyle(
                          fontSize: 22,
                          color: Color(0xFFE6B428),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
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

  @override
  void dispose() {
    super.dispose();
  }
}
