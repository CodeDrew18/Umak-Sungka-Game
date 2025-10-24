import 'package:flutter/material.dart';
import 'package:sungka/auth/google_connect_screen.dart';
import 'package:sungka/main.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:sungka/screens/start_game_screen.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _playMusic();

    Future.delayed(const Duration(seconds: 3), () async {
      await _audioPlayer.stop();
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => GoogleConnectScreen()),
        );
      }
    });
  }

  Future<void> _playMusic() async {
    await _audioPlayer.play(AssetSource('bg-mc.wav'));
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Image.asset(
            "assets/loading.webp",
            height: 250,
            fit: BoxFit.contain,
          )
              .animate()
              .fadeIn(duration: 800.ms)
              .scale(duration: 1000.ms, curve: Curves.easeOutBack),
        ),
      ),
    );
  }
}
