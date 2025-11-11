import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sungka/core/constants/app_colors.dart';
import 'package:sungka/screens/auth/auth_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:audioplayers/audioplayers.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  void _navigateToScreen(Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _playMusic();

    Future.delayed(const Duration(seconds: 4), () async {
      await _audioPlayer.stop();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => AuthScreen(
            navigateToScreen: _navigateToScreen,
            showError: _showError,
          ),
        ),
      );
    });
  }

  Future<void> _playMusic() async {
    try {
      await _audioPlayer.play(AssetSource('bg-mc.wav'));
    } catch (e) {
      debugPrint('Audio error: $e');
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/splashscreen_bg.png",
              height: 200,
              fit: BoxFit.contain,
            )
                .animate()
                .fadeIn(duration: 800.ms)
                .scale(duration: 1000.ms, curve: Curves.easeOutBack),
            
            const SizedBox(height: 20),
            
            Text(
              "Sungka Master",
              style: GoogleFonts.poppins(
                color: Colors.yellow,
                fontSize: 54,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.yellow.withOpacity(0.7),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(duration: 1000.ms, delay: 900.ms)
                .slideY(begin: 0.3, end: 0, curve: Curves.easeOutBack),
          ],
        ),
      ),
    );
  }
}