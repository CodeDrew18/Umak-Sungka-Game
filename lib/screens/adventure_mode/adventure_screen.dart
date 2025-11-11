import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sungka/core/constants/app_colors.dart';
import 'package:sungka/screens/adventure_mode/game_match/adventure_player_vs_bot.dart';
import 'package:sungka/screens/components/pebble_bounce.dart';
import 'package:sungka/screens/home_screen.dart';
import 'package:sungka/screens/player_vs_bot/selection_mode.dart';

class SungkaAdventureScreen extends StatefulWidget {
  final Function(Widget screen) navigateToScreen;
  final Function(String message) showError;

  const SungkaAdventureScreen({
    super.key,
    required this.navigateToScreen,
    required this.showError,
  });

  @override
  State<SungkaAdventureScreen> createState() => _SungkaAdventureScreenState();
}

class _SungkaAdventureScreenState extends State<SungkaAdventureScreen> {
  late PageController _pageController;
  int _currentLevel = 0;

  String _getLevelImagePath(int levelNumber) {
    switch (levelNumber) {
      case 1:
        return 'assets/images/assets/lvl1.png';
      case 2:
        return 'assets/images/assets/lvl2.png';
      case 3:
        return 'assets/images/assets/lvl3.png';
      case 4:
        return 'assets/images/assets/lvl4.png';
      case 5:
        return 'assets/images/assets/lvl5.png';
      case 6:
        return 'assets/images/assets/lvl6.png';
      default:
        return 'assets/images/assets/lvl1.png';
    }
  }

  final List<Map<String, dynamic>> levels = [
    {
      "number": 1,
      "name": "Beginner’s Match",
      "desc": "Learn the rhythm of the board and flow of shells.",
      "rules": ["• Extra Turn: Last seed in store = take another turn."],
      "unlocked": true,
      "level": Difficulty.easy,
    },
    {
      "number": 2,
      "name": "Strategic Moves",
      "desc":
          "Think ahead and trap your opponent’s side. Requires calculated moves.",
      "rules": ["• Extra Turn: Last seed in store = take another turn."],
      "unlocked": false,
      "level": Difficulty.easy,
    },
    {
      "number": 3,
      "name": "Swift Hands",
      "desc": "Speed and timing decide victory. Minimal thinking time.",
      "rules": [
        "• Extra Turn: Last seed in store = take another turn.",
        "Last seed in your empty pit, Opponent's pit across has seeds = capture all to your store.",
      ],
      "unlocked": false,
      "level": Difficulty.hard,
    },
    {
      "number": 4,
      "name": "Master of the Board",
      "desc":
          "The final challenge. Outsmart and dominate with advanced tactics.",
      "rules": [
        "• Extra Turn: Last seed in store = take another turn.",
        "• No Capture: The capture rule is disabled for pure scoring.",
      ],
      "unlocked": false,
      "level": Difficulty.medium,
    },
    {
      "number": 5,
      "name": "Tactician’s Edge",
      "desc":
          "Combine strategy and intuition to control the flow. The ultimate challenge.",
      "rules": [
        "• Extra Turn: Last seed in store = take another turn.",
        "• Capture Rule: Last seed in your empty pit + opponent's pit across has seeds = capture all to your store.",
      ],
      "unlocked": false,
      "level": Difficulty.hard,
    },
    {
      "number": 6,
      "name": "Grandmaster’s Trial",
      "desc":
          "Only the best can master both tactics and timing. Unforgiving ruleset.",
      "rules": [
        "• Extra Turn: Last seed in store = take another turn.",
        "• Capture Rule: Last seed in your empty pit + opponent's pit across has seeds = capture all to your store.",
        "• Forced Move: If only one pit has seeds, you must play it.",
      ],
      "unlocked": false,
      "level": Difficulty.hard,
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.78);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  LinearGradient _lockedGradientFallback() => LinearGradient(
    colors: [
      AppColors.grey800.withOpacity(0.9),
      AppColors.grey700.withOpacity(0.9),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/assets/bg.png', fit: BoxFit.cover),

          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Gap(60),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SafeArea(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Image.asset(
                            'assets/images/assets/adventure_mode.png',
                            width: 420,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Gap(30),
                  SizedBox(
                    height: height * 0.55,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: levels.length,
                      physics: const BouncingScrollPhysics(),
                      onPageChanged: (index) {
                        setState(() => _currentLevel = index);
                      },
                      itemBuilder: (context, index) {
                        final level = levels[index];
                        return AnimatedBuilder(
                          animation: _pageController,
                          builder: (context, child) {
                            double value = 1.0;
                            if (_pageController.position.haveDimensions) {
                              value = _pageController.page! - index;
                              value = (1 - (value.abs() * 0.25)).clamp(
                                0.85,
                                1.0,
                              );
                            }
                            return Center(
                              child: Transform.scale(
                                scale: value,
                                child: _buildLevelCard(
                                  level,
                                  lockedGradient: _lockedGradientFallback(),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 18),

                  _buildLevelIndicator(),

                  const SizedBox(height: 28),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: _buildPlayButton(),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          Positioned(
            top: 12,
            left: 12,
            child: SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: GestureDetector(
                    onTap: () async {
                      final overlay = OverlayEntry(
                        builder: (_) => const PebbleBounce(),
                      );
                      Overlay.of(context).insert(overlay);

                      await Future.delayed(const Duration(milliseconds: 300));

                      overlay.remove();

                      widget.navigateToScreen(
                        GameWidget(
                          game: HomeGame(
                            navigateToScreen: widget.navigateToScreen,
                            showError: widget.showError,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        levels.length,
        (index) => Container(
          width: 8.0,
          height: 8.0,
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                _currentLevel == index
                    ? AppColors.primary
                    : AppColors.white.withOpacity(0.3),
          ),
        ),
      ),
    );
  }

  Widget _buildFlameBackButton({required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 44,
        height: 44,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: AppColors.gradient1,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.35),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Icon(Icons.arrow_back, color: AppColors.white, size: 20),
      ),
    );
  }

  Widget _buildLevelCard(
    Map<String, dynamic> level, {
    required LinearGradient lockedGradient,
  }) {
    final bool unlocked = level["unlocked"];
    final gradient = unlocked ? AppColors.gradient2 : lockedGradient;
    final imagePath = _getLevelImagePath(level["number"]);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      height: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(unlocked ? 0.6 : 0.4),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.asset(imagePath, fit: BoxFit.cover),
          ),

          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  unlocked
                      ? AppColors.black.withOpacity(0.2)
                      : AppColors.black.withOpacity(
                        0.6,
                      ),
                  AppColors.black.withOpacity(
                    0.9,
                  ),
                ],
              ),
              border: Border.all(
                color: AppColors.white.withOpacity(
                  unlocked ? 0.3 : 0.1,
                ),
                width: 1.5,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!unlocked)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "LOCKED 🔒",
                            style: GoogleFonts.poppins(
                              color: AppColors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                const Spacer(),

                Text(
                  "LEVEL ${level["number"]}",
                  style: GoogleFonts.poppins(
                    color: AppColors.white.withOpacity(0.8),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 6),

                Text(
                  level["name"],
                  style: GoogleFonts.poppins(
                    color: AppColors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),

                Text(
                  level["desc"],
                  style: GoogleFonts.poppins(
                    color: AppColors.white.withOpacity(0.95),
                    fontSize: 14,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 18),

                Divider(color: AppColors.white.withOpacity(0.4)),
                Text(
                  "RULES",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white.withOpacity(0.95),
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),

                ...List.generate(
                  (level["rules"] as List).length,
                  (i) => Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      level["rules"][i],
                      style: GoogleFonts.poppins(
                        color: AppColors.white.withOpacity(0.85),
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayButton() {
    final current = levels[_currentLevel];
    final unlocked = current["unlocked"];
    final difficulty = current["level"];
    return GestureDetector(
      onTap:
          unlocked
              ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => AdventurePlayerVsBot(difficulty: difficulty),
                  ),
                );
                print(
                  "Starting Level ${current["number"]}: ${current["name"]}",
                );
              }
              : null,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 18,
        ),
        decoration: BoxDecoration(
          color: unlocked ? Colors.amber : Colors.grey,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color:
                  unlocked
                      ? const Color.fromARGB(255, 122, 116, 14).withOpacity(0.5)
                      : const Color.fromARGB(
                        255,
                        180,
                        158,
                        30,
                      ).withOpacity(0.35),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: Text(
            unlocked ? "START MATCH" : "LOCKED",
            style: GoogleFonts.poppins(
              color: AppColors.white,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
              fontSize: 17,
            ),
          ),
        ),
      ),
    );
  }
}

