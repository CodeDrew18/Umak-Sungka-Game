import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sungka/screens/start_game_screen.dart';

class UsernameScreen extends StatefulWidget {
  const UsernameScreen({super.key});

  @override
  State<UsernameScreen> createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen>
    with TickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  late AnimationController _titleAnimationController;
  late AnimationController _particleAnimationController;
  late Animation<double> _titleScale;
  late Animation<double> _titleOpacity;
  late Animation<double> _glowIntensity;
  bool _isButtonHovered = false;
  bool _isInputFocused = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    // Title animation
    _titleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat(reverse: true);

    _titleScale = Tween<double>(begin: 0.98, end: 1.08).animate(
      CurvedAnimation(parent: _titleAnimationController, curve: Curves.easeInOut),
    );

    _titleOpacity = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _titleAnimationController, curve: Curves.easeInOut),
    );

    _glowIntensity = Tween<double>(begin: 0.4, end: 0.9).animate(
      CurvedAnimation(parent: _titleAnimationController, curve: Curves.easeInOut),
    );

    // Particle animation
    _particleAnimationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _titleAnimationController.dispose();
    _particleAnimationController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void _handlePlayGame() {
    final username = _usernameController.text.trim();
    if (username.isEmpty) {
      _showErrorSnackBar('Please enter a username to continue');
      return;
    }

    if (username.length < 3) {
      _showErrorSnackBar('Username must be at least 3 characters');
      return;
    }

    if (username.length > 20) {
      _showErrorSnackBar('Username must be less than 20 characters');
      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const StartGameScreen(),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFFF6B35),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isLandscape = screenSize.width > screenSize.height;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1E),
      body: Stack(
        children: [
          // Animated particle background
          _buildAnimatedParticleBackground(),

          // Main content
          SingleChildScrollView(
            child: SizedBox(
              height: screenSize.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top section with title
                  Padding(
                    padding: EdgeInsets.only(
                      top: screenSize.height * 0.08,
                      left: 20,
                      right: 20,
                    ),
                    child: _buildTitleSection(),
                  ),

                  // Middle section with input and button
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width * 0.08,
                      vertical: screenSize.height * 0.06,
                    ),
                    child: _buildInputSection(screenSize),
                  ),

                  // Bottom decorative element
                  _buildBottomDecoration(screenSize),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleSection() {
    return AnimatedBuilder(
      animation: Listenable.merge([_titleScale, _titleOpacity, _glowIntensity]),
      builder: (context, child) {
        return Transform.scale(
          scale: _titleScale.value,
          child: Opacity(
            opacity: _titleOpacity.value,
            child: Column(
              children: [
                // Glow effect container
                // Container(
                //   width: 50,
                //   height: 50,
                //   decoration: BoxDecoration(
                //     shape: BoxShape.circle,
                //     boxShadow: [
                //       BoxShadow(
                //         color: const Color(0xFFFF6B35).withOpacity(_glowIntensity.value * 0.6),
                //         blurRadius: 60,
                //         spreadRadius: 30,
                //       ),
                //       BoxShadow(
                //         color: const Color(0xFFFF4500).withOpacity(_glowIntensity.value * 0.3),
                //         blurRadius: 40,
                //         spreadRadius: 15,
                //       ),
                //     ],
                //   ),
                // ),
                // const SizedBox(height: 20),
                // Main title
                ShaderMask(
                  shaderCallback: (bounds) {
                    return LinearGradient(
                      colors: [
                        const Color(0xFFFFD700),
                        const Color(0xFFFF6B35),
                        const Color(0xFFFF4500),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ).createShader(bounds);
                  },
                  child: Text(
                    'SUNGKA MASTER',
                    style: GoogleFonts.poppins(
                      fontSize: 56,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.5,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 12),
                // Subtitle
                Text(
                  'Enter Your Battle Name',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    color: Colors.white70,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInputSection(Size screenSize) {
    return Column(
      children: [
        // Username input field
        Focus(
          onFocusChange: (hasFocus) {
            setState(() => _isInputFocused = hasFocus);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: _isInputFocused
                      ? const Color(0xFFFF6B35).withOpacity(0.5)
                      : const Color(0xFFFF6B35).withOpacity(0.2),
                  blurRadius: _isInputFocused ? 30 : 15,
                  spreadRadius: _isInputFocused ? 5 : 0,
                ),
              ],
            ),
            child: TextField(
              controller: _usernameController,
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLength: 20,
              decoration: InputDecoration(
                hintText: 'Enter your username',
                hintStyle: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white38,
                  fontWeight: FontWeight.w400,
                ),
                filled: true,
                fillColor: const Color(0xFF1A1A2E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xFFFF6B35),
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: const Color(0xFFFF6B35).withOpacity(0.5),
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xFFFFD700),
                    width: 3,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 18,
                ),
                counterStyle: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.white38,
                ),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
        ),
        const SizedBox(height: 48),

        // Play button
        MouseRegion(
          onEnter: (_) => setState(() => _isButtonHovered = true),
          onExit: (_) => setState(() => _isButtonHovered = false),
          child: GestureDetector(
            onTap: _handlePlayGame,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              height: 72,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: _isButtonHovered
                      ? [
                          const Color(0xFFFF6B35),
                          const Color(0xFFFF4500),
                        ]
                      : [
                          const Color(0xFFFF6B35),
                          const Color(0xFFFF4500),
                        ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF6B35).withOpacity(
                      _isButtonHovered ? 0.8 : 0.4,
                    ),
                    blurRadius: _isButtonHovered ? 40 : 20,
                    spreadRadius: _isButtonHovered ? 8 : 2,
                  ),
                ],
                border: Border.all(
                  color: Colors.white.withOpacity(_isButtonHovered ? 0.3 : 0.1),
                  width: 2,
                ),
              ),
              transform: Matrix4.identity()
                ..scale(_isButtonHovered ? 1.06 : 1.0),
              child: Expanded(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'IGNITE THE BATTLE',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 1.8,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.flash_on,
                        color: Colors.white,
                        size: _isButtonHovered ? 24 : 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomDecoration(Size screenSize) {
    return Container(
      height: screenSize.height * 0.25,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            const Color(0xFFFF6B35).withOpacity(0.1),
            const Color(0xFFFF4500).withOpacity(0.15),
          ],
        ),
      ),
      child: Center(
        child: Opacity(
          opacity: 0.3,
          child: Icon(
            Icons.local_fire_department,
            size: screenSize.height * 0.15,
            color: const Color(0xFFFF6B35),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedParticleBackground() {
    return AnimatedBuilder(
      animation: _particleAnimationController,
      builder: (context, child) {
        return CustomPaint(
          painter: FlameParticlePainter(
            animationValue: _particleAnimationController.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class FlameParticlePainter extends CustomPainter {
  final double animationValue;
  final Random random = Random(42);
  late List<FlameParticle> particles;

  FlameParticlePainter({required this.animationValue}) {
    particles = _generateParticles();
  }

  List<FlameParticle> _generateParticles() {
    final List<FlameParticle> particleList = [];
    for (int i = 0; i < 50; i++) {
      particleList.add(
        FlameParticle(
          initialX: random.nextDouble() * 400,
          initialY: random.nextDouble() * 800,
          velocityX: (random.nextDouble() - 0.5) * 1.5,
          velocityY: (random.nextDouble() - 0.5) * 1.5,
          size: random.nextDouble() * 4 + 1,
          baseOpacity: random.nextDouble() * 0.4 + 0.1,
          duration: random.nextDouble() * 3 + 2,
          seed: i,
        ),
      );
    }
    return particleList;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    for (var particle in particles) {
      final progress = (animationValue * particle.duration) % 1.0;
      final x = particle.initialX + (particle.velocityX * progress * 200);
      final y = particle.initialY + (particle.velocityY * progress * 200);

      // Wrap around
      final wrappedX = x % size.width;
      final wrappedY = y % size.height;

      // Opacity pulse
      final opacityPulse = (sin(progress * pi * 2) + 1) / 2;
      final opacity = particle.baseOpacity * opacityPulse;

      // Color variation
      final colorValue = (particle.seed + progress) % 1.0;
      Color particleColor;
      if (colorValue < 0.33) {
        particleColor = const Color(0xFFFF6B35);
      } else if (colorValue < 0.66) {
        particleColor = const Color(0xFFFFD700);
      } else {
        particleColor = const Color(0xFFFF4500);
      }

      paint.color = particleColor.withOpacity(opacity);
      canvas.drawCircle(
        Offset(wrappedX, wrappedY),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(FlameParticlePainter oldDelegate) => true;
}

class FlameParticle {
  final double initialX;
  final double initialY;
  final double velocityX;
  final double velocityY;
  final double size;
  final double baseOpacity;
  final double duration;
  final int seed;

  FlameParticle({
    required this.initialX,
    required this.initialY,
    required this.velocityX,
    required this.velocityY,
    required this.size,
    required this.baseOpacity,
    required this.duration,
    required this.seed,
  });
}