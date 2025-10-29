// import 'package:flutter/material.dart';
// import 'package:sungka/core/constants/app_colors.dart';
// import 'package:sungka/screens/auth_screen.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:audioplayers/audioplayers.dart';

// class Splashscreen extends StatefulWidget {
//   const Splashscreen({super.key});

//   @override
//   State<Splashscreen> createState() => _SplashscreenState();
// }

// class _SplashscreenState extends State<Splashscreen> {
//   final AudioPlayer _audioPlayer = AudioPlayer();

//   @override
//   void initState() {
//     super.initState();
//     _playMusic();

//     Future.delayed(const Duration(seconds: 3), () async {
//       await _audioPlayer.stop();
//       if (mounted) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => AuthScreen()),
//         );
//       }
//     });
//   }

//   Future<void> _playMusic() async {
//     await _audioPlayer.play(AssetSource('bg-mc.wav'));
//   }

//   @override
//   void dispose() {
//     _audioPlayer.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [AppColors.black, AppColors.black],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Center(
//           child: Image.asset(
//                 "assets/loading.webp",
//                 height: 250,
//                 fit: BoxFit.contain,
//               )
//               .animate()
//               .fadeIn(duration: 800.ms)
//               .scale(duration: 1000.ms, curve: Curves.easeOutBack),
//         ),
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:sungka/screens/auth/auth_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flame/game.dart';
import 'package:flame/particles.dart';
import 'package:flame/components.dart';
import 'dart:math';

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

    Future.delayed(const Duration(seconds: 4), () async {
      await _audioPlayer.stop();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) =>  AuthScreen()),
        );
    });
  }

Future<void> _playMusic() async {
  try {
    await _audioPlayer.play(AssetSource('bg-mc.wav'));
  } catch (e, stack) {
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
      body: Stack(
        fit: StackFit.expand,
        children: [
          GameWidget(game: FireEffectGame()),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black87, Colors.black],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: Image.asset(
              "assets/loading.webp",
              height: 250,
              fit: BoxFit.contain,
            )
                .animate()
                .fadeIn(duration: 800.ms)
                .scale(duration: 1000.ms, curve: Curves.easeOutBack),
          ),
        ],
      ),
    );
  }
}

class FireEffectGame extends FlameGame {
  final Random _random = Random();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(
      ParticleSystemComponent(
        particle: Particle.generate(
          count: 100,
          lifespan: 2,
          generator: (i) {
            final dx = _random.nextDouble() * size.x;
            final dy = size.y - 80;
            final color = Colors.orange.withOpacity(0.6 + _random.nextDouble() * 0.4);

            return AcceleratedParticle(
              acceleration: Vector2(0, -30),
              speed: Vector2((dx - size.x / 2) * 0.02, -40 - _random.nextDouble() * 20),
              position: Vector2(dx, dy),
              child: CircleParticle(
                radius: 2 + _random.nextDouble() * 4,
                paint: Paint()
                  ..color = color
                  ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
              ),
            );
          },
        ),
      ),
    );
  }
}
