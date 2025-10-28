// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:sungka/core/constants/app_colors.dart';

// class UsernameScreen extends StatelessWidget {
//   UsernameScreen({super.key});

//   final key = GlobalKey<FormFieldState>();
//   final username = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF1E1E1E),
//       body: Column(
//         children: [
//           Stack(
//             children: [
//               Align(
//                 alignment: Alignment.topCenter,
//                 child: Text(
//                   "Sungka Master",
//                   style: GoogleFonts.poppins(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 80,
//                     foreground: Paint()
//                       ..style = PaintingStyle.stroke
//                       ..strokeWidth = 1.5
//                       ..color = AppColors.white,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
          
          
//             ],
//           ),
//             Column(
//               children: [

//                              Positioned(
//       bottom: 0,
//       left: 0,
//       right: 0,
//       child: Image.asset(
//         "assets/board1.png",
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height * 0.7,
//         fit: BoxFit.contain,
//       ),
//     ),
//               ],
//             )

//         ],
//       ),
//     );
//   }
// }





import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sungka/core/constants/app_colors.dart';
import 'package:sungka/screens/start_game_screen.dart';

class UsernameScreen extends StatefulWidget {
  const UsernameScreen({super.key});

  @override
  State<UsernameScreen> createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen>
    with SingleTickerProviderStateMixin {
  final username = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _titleScale;
  late Animation<double> _glowOpacity;
  bool _isButtonHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _titleScale = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _glowOpacity = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    username.dispose();
    super.dispose();
  }

  void _handlePlayGame() {
    if (username.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a username to continue'),
          backgroundColor: Color(0xFFE6B428),
        ),
      );
      return;
    }

    // Navigate to start game screen with username
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => StartGameScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF1a1a2e),
      body: Stack(
        children: [
          _buildParticleBackground(),

          // Main content
          SingleChildScrollView(
            child: SizedBox(
              height: screenHeight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.1),
                    child: AnimatedBuilder(
                      animation: _titleScale,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _titleScale.value,
                          child: Column(
                            children: [
                              // Glow effect
                              AnimatedBuilder(
                                animation: _glowOpacity,
                                builder: (context, child) {
                                  return Container(
                                    width: 200,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFFE6B428)
                                              .withOpacity(_glowOpacity.value),
                                          blurRadius: 40,
                                          spreadRadius: 20,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              // Title text
                              Text(
                                'Sungka Master',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 56,
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = 1.5
                                    ..color = AppColors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Enter Your Name',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.1,
                      vertical: screenHeight * 0.1,
                    ),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFE6B428).withOpacity(0.2),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: username,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: 'Enter your username',
                              hintStyle: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.white54,
                              ),
                              filled: true,
                              fillColor: const Color(0xFF2a2a3e),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE6B428),
                                  width: 2,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE6B428),
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  color: Color(0xFFFFD700),
                                  width: 3,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),

                        MouseRegion(
                          onEnter: (_) =>
                              setState(() => _isButtonHovered = true),
                          onExit: (_) =>
                              setState(() => _isButtonHovered = false),
                          child: GestureDetector(
                            onTap: _handlePlayGame,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: double.infinity,
                              height: 70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: const Color(0xFFE6B428),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFE6B428)
                                        .withOpacity(_isButtonHovered ? 0.6 : 0.3),
                                    blurRadius: _isButtonHovered ? 30 : 15,
                                    spreadRadius: _isButtonHovered ? 5 : 0,
                                  ),
                                ],
                                border: Border.all(
                                  color: Colors.black.withOpacity(0.2),
                                  width: 2,
                                ),
                              ),
                              transform: Matrix4.identity()
                                ..scale(_isButtonHovered ? 1.05 : 1.0),
                              child: Center(
                                child: Text(
                                  'PLAY GAME',
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/board1.png',
              width: screenWidth,
              height: screenHeight * 0.3,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParticleBackground() {
    return CustomPaint(
      painter: ParticlePainter(),
      size: Size.infinite,
    );
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles = [];
  static final Random random = Random();

  ParticlePainter() {
    // Initialize particles
    for (int i = 0; i < 30; i++) {
      particles.add(
        Particle(
          x: random.nextDouble() * 400,
          y: random.nextDouble() * 800,
          vx: (random.nextDouble() - 0.5) * 2,
          vy: (random.nextDouble() - 0.5) * 2,
          size: random.nextDouble() * 3 + 1,
          opacity: random.nextDouble() * 0.5 + 0.2,
        ),
      );
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    for (var particle in particles) {
      paint.color = const Color(0xFFE6B428).withOpacity(particle.opacity);
      canvas.drawCircle(
        Offset(particle.x, particle.y),
        particle.size,
        paint,
      );

      // Update particle position
      particle.x += particle.vx;
      particle.y += particle.vy;

      // Wrap around screen
      if (particle.x < 0) particle.x = size.width;
      if (particle.x > size.width) particle.x = 0;
      if (particle.y < 0) particle.y = size.height;
      if (particle.y > size.height) particle.y = 0;
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}

class Particle {
  double x, y, vx, vy, size, opacity;

  Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.size,
    required this.opacity,
  });
}
