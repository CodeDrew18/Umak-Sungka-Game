import 'package:flutter/material.dart';
import 'package:sungka/core/constants/app_colors.dart';
import 'package:sungka/screens/auth/auth_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:audioplayers/audioplayers.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({
    super.key,
    required this.navigateToScreen,
    required this.showError,
    required this.bgmPlayer,
    required this.musicLevel,
  });

  final Function(Widget screen) navigateToScreen;
  final Function(String message) showError;
  final AudioPlayer bgmPlayer;
  final musicLevel;
  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _playMusic();

    Future.delayed(const Duration(seconds: 4), () async {
      await _audioPlayer.stop();

      try {
        await widget.bgmPlayer.resume();
      } catch (e) {
        debugPrint('BGM resume error: $e');
      }

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (_) => AuthScreen(
                  navigateToScreen: widget.navigateToScreen,
                  showError: widget.showError,
                  bgmPlayer: widget.bgmPlayer,
                  musicLevel: widget.musicLevel,
                ),
          ),
        );
      }
    });
  }

  Future<void> _playMusic() async {
    try {
      await widget.bgmPlayer.pause();
    } catch (e) {
      debugPrint('BGM pause error: $e');
    }

    try {
      await _audioPlayer.play(AssetSource('bg-mc.wav'));
    } catch (e) {
      debugPrint('Splash audio error: $e');
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
          ],
        ),
      ),
    );
  }
}
