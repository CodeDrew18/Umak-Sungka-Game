// import 'package:flame/game.dart';
// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:sungka/core/constants/app_colors.dart';
// import 'package:sungka/screens/adventure_mode/game_match/adventure_player_vs_bot.dart';
// import 'package:sungka/screens/components/pebble_bounce.dart';
// import 'package:sungka/screens/home_screen.dart';
// import 'package:sungka/screens/player_vs_bot/selection_mode.dart';
// import 'package:quickalert/quickalert.dart';

// class SungkaAdventureScreen extends StatefulWidget {
//   final Function(Widget screen) navigateToScreen;
//   final Function(String message) showError;

//   const SungkaAdventureScreen({
//     super.key,
//     required this.navigateToScreen,
//     required this.showError,
//   });

//   @override
//   State<SungkaAdventureScreen> createState() => _SungkaAdventureScreenState();
// }

// class _SungkaAdventureScreenState extends State<SungkaAdventureScreen> {
//   late PageController _pageController;
//   int _currentLevel = 0;

//   final ValueNotifier<double> _scaleNotifier = ValueNotifier(1.0);

//   final FirebaseFirestore firestore = FirebaseFirestore.instance;
//   final FirebaseAuth auth = FirebaseAuth.instance;

//   final List<Map<String, dynamic>> levels = [
//     {
//       "number": 1,
//       "name": "Beginner’s Match",
//       "desc": "Learn the rhythm of the board and flow of shells.",
//       "rules": ["• Extra Turn: Last seed in store = take another turn."],
//       "unlocked": true,
//       "level": Difficulty.easy,
//     },
//     {
//       "number": 2,
//       "name": "Strategic Moves",
//       "desc":
//           "Think ahead and trap your opponent’s side. Requires calculated moves.",
//       "rules": ["• Extra Turn: Last seed in store = take another turn."],
//       "unlocked": false,
//       "level": Difficulty.easy,
//     },
//     {
//       "number": 3,
//       "name": "Swift Hands",
//       "desc": "Speed and timing decide victory. Minimal thinking time.",
//       "rules": [
//         "• Extra Turn: Last seed in store = take another turn.",
//         "Last seed in your empty pit, Opponent's pit across has seeds = capture all to your store.",
//       ],
//       "unlocked": false,
//       "level": Difficulty.hard,
//     },
//     {
//       "number": 4,
//       "name": "Master of the Board",
//       "desc":
//           "The final challenge. Outsmart and dominate with advanced tactics.",
//       "rules": [
//         "• Extra Turn: Last seed in store = take another turn.",
//         "• No Capture: The capture rule is disabled for pure scoring.",
//       ],
//       "unlocked": false,
//       "level": Difficulty.medium,
//     },
//     {
//       "number": 5,
//       "name": "Tactician’s Edge",
//       "desc":
//           "Combine strategy and intuition to control the flow. The ultimate challenge.",
//       "rules": [
//         "• Extra Turn: Last seed in store = take another turn.",
//         "• Capture Rule: Last seed in your empty pit + opponent's pit across has seeds = capture all to your store.",
//       ],
//       "unlocked": false,
//       "level": Difficulty.hard,
//     },
//     {
//       "number": 6,
//       "name": "Grandmaster’s Trial",
//       "desc":
//           "Only the best can master both tactics and timing. Unforgiving ruleset.",
//       "rules": [
//         "• Extra Turn: Last seed in store = take another turn.",
//         "• Capture Rule: Last seed in your empty pit + opponent's pit across has seeds = capture all to your store.",
//         "• Forced Move: If only one pit has seeds, you must play it.",
//       ],
//       "unlocked": false,
//       "level": Difficulty.hard,
//     },
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController(viewportFraction: 0.78);
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     _scaleNotifier.dispose();
//     super.dispose();
//   }

//   LinearGradient _lockedGradientFallback() => LinearGradient(
//     colors: [
//       AppColors.grey800.withOpacity(0.9),
//       AppColors.grey700.withOpacity(0.9),
//     ],
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//   );

//   Stream<List<int>> completedLevelsStream() {
//     final user = auth.currentUser;
//     if (user == null) return const Stream.empty();

//     return firestore.collection('users').doc(user.uid).snapshots().map((
//       snapshot,
//     ) {
//       final completed = snapshot.data()?['completedLevels'] ?? [];
//       return List<int>.from(completed);
//     });
//   }

//   Future<void> completeLevel(int levelNumber) async {
//     final user = auth.currentUser;
//     if (user == null) return;

//     final userDoc = firestore.collection('users').doc(user.uid);
//     await userDoc.set({
//       'completedLevels': FieldValue.arrayUnion([levelNumber]),
//     }, SetOptions(merge: true));
//   }

//   String _getLevelImagePath(int levelNumber) {
//     return 'assets/images/assets/lvl$levelNumber.png';
//   }

//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;

//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           Image.asset('assets/images/assets/bg.png', fit: BoxFit.cover),
//           SafeArea(
//             child: StreamBuilder<List<int>>(
//               stream: completedLevelsStream(),
//               builder: (context, snapshot) {
//                 final completedLevels = snapshot.data ?? [];

//                 final updatedLevels =
//                     levels.map((level) {
//                       if (level['number'] == 1)
//                         return {...level, 'unlocked': true};
//                       return {
//                         ...level,
//                         'unlocked': completedLevels.contains(
//                           level['number'] - 1,
//                         ),
//                       };
//                     }).toList();

//                 return SingleChildScrollView(
//                   physics: const BouncingScrollPhysics(),
//                   child: Column(
//                     children: [
//                       const SizedBox(height: 60),
//                       Image.asset(
//                         'assets/images/assets/adventure_mode.png',
//                         width: 420,
//                         height: 120,
//                         fit: BoxFit.cover,
//                       ),
//                       const SizedBox(height: 30),
//                       SizedBox(
//                         height: height * 0.55,
//                         child: PageView.builder(
//                           controller: _pageController,
//                           itemCount: updatedLevels.length,
//                           physics: const BouncingScrollPhysics(),
//                           onPageChanged: (index) {
//                             setState(() => _currentLevel = index);
//                           },
//                           itemBuilder: (context, index) {
//                             final level = updatedLevels[index];
//                             return AnimatedBuilder(
//                               animation: _pageController,
//                               builder: (context, child) {
//                                 double value = 1.0;
//                                 if (_pageController.position.haveDimensions) {
//                                   value = _pageController.page! - index;
//                                   value = (1 - (value.abs() * 0.25)).clamp(
//                                     0.85,
//                                     1.0,
//                                   );
//                                 }
//                                 return Center(
//                                   child: Transform.scale(
//                                     scale: value,
//                                     child: _buildLevelCard(
//                                       level,
//                                       lockedGradient: _lockedGradientFallback(),
//                                     ),
//                                   ),
//                                 );
//                               },
//                             );
//                           },
//                         ),
//                       ),
//                       const SizedBox(height: 18),
//                       _buildLevelIndicator(updatedLevels),
//                       const SizedBox(height: 28),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 40),
//                         child: _buildPlayButton(updatedLevels[_currentLevel]),
//                       ),
//                       const SizedBox(height: 40),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),

//           // Back button with PebbleBounce
//           Positioned(
//             top: 12,
//             left: 12,
//             child: SafeArea(
//               child: Align(
//                 alignment: Alignment.topLeft,
//                 child: Padding(
//                   padding: const EdgeInsets.all(8),
//                   child: GestureDetector(
//                     onTap: () async {
//                       final overlay = OverlayEntry(
//                         builder: (_) => const PebbleBounce(),
//                       );
//                       Overlay.of(context).insert(overlay);

//                       await Future.delayed(const Duration(milliseconds: 300));
//                       overlay.remove();

//                       widget.navigateToScreen(
//                         GameWidget(
//                           game: HomeGame(
//                             navigateToScreen: widget.navigateToScreen,
//                             showError: widget.showError,
//                           ),
//                         ),
//                       );
//                     },
//                     child: Container(
//                       width: 60,
//                       height: 60,
//                       decoration: BoxDecoration(
//                         color: Colors.red,
//                         shape: BoxShape.circle,
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.3),
//                             blurRadius: 8,
//                             offset: const Offset(0, 3),
//                           ),
//                         ],
//                       ),
//                       child: const Icon(
//                         Icons.arrow_back,
//                         color: Colors.white,
//                         size: 28,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLevelIndicator(List<Map<String, dynamic>> updatedLevels) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: List.generate(
//         updatedLevels.length,
//         (index) => Container(
//           width: 8.0,
//           height: 8.0,
//           margin: const EdgeInsets.symmetric(horizontal: 4.0),
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color:
//                 _currentLevel == index
//                     ? AppColors.primary
//                     : AppColors.white.withOpacity(0.3),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildLevelCard(
//     Map<String, dynamic> level, {
//     required LinearGradient lockedGradient,
//   }) {
//     final bool unlocked = level["unlocked"];
//     final imagePath = _getLevelImagePath(level["number"]);

//     return Container(
//       width: double.infinity,
//       margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//       height: double.infinity,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(18),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.black.withOpacity(unlocked ? 0.6 : 0.4),
//             blurRadius: 18,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Stack(
//         fit: StackFit.expand,
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(18),
//             child: Image.asset(imagePath, fit: BoxFit.cover),
//           ),
//           Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(18),
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//                   unlocked
//                       ? AppColors.black.withOpacity(0.2)
//                       : AppColors.black.withOpacity(0.6),
//                   AppColors.black.withOpacity(0.9),
//                 ],
//               ),
//               border: Border.all(
//                 color: AppColors.white.withOpacity(unlocked ? 0.3 : 0.1),
//                 width: 1.5,
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 if (!unlocked)
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 8.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 12,
//                             vertical: 6,
//                           ),
//                           decoration: BoxDecoration(
//                             color: AppColors.primary.withOpacity(0.8),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Text(
//                             "LOCKED 🔒",
//                             style: GoogleFonts.poppins(
//                               color: AppColors.white,
//                               fontSize: 12,
//                               fontWeight: FontWeight.w700,
//                               letterSpacing: 1,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 const Spacer(),
//                 Text(
//                   "LEVEL ${level["number"]}",
//                   style: GoogleFonts.poppins(
//                     color: AppColors.white.withOpacity(0.8),
//                     fontSize: 14,
//                     fontWeight: FontWeight.w700,
//                     letterSpacing: 1.5,
//                   ),
//                 ),
//                 const SizedBox(height: 6),
//                 Text(
//                   level["name"],
//                   style: GoogleFonts.poppins(
//                     color: AppColors.white,
//                     fontSize: 26,
//                     fontWeight: FontWeight.w900,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   level["desc"],
//                   style: GoogleFonts.poppins(
//                     color: AppColors.white.withOpacity(0.95),
//                     fontSize: 14,
//                     height: 1.4,
//                   ),
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 const SizedBox(height: 18),
//                 Divider(color: AppColors.white.withOpacity(0.4)),
//                 Text(
//                   "RULES",
//                   style: GoogleFonts.poppins(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w700,
//                     color: AppColors.white.withOpacity(0.95),
//                     letterSpacing: 1.2,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 ...List.generate(
//                   (level["rules"] as List).length,
//                   (i) => Padding(
//                     padding: const EdgeInsets.only(top: 4),
//                     child: Text(
//                       level["rules"][i],
//                       style: GoogleFonts.poppins(
//                         color: AppColors.white.withOpacity(0.85),
//                         fontSize: 13,
//                         height: 1.4,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // 2. UPDATED _buildPlayButton for scale animation and QuickAlert
//   Widget _buildPlayButton(Map<String, dynamic> current) {
//     final unlocked = current["unlocked"];
//     final difficulty = current["level"];
//     final levelNumber = current["number"];

//     void _showLockedAlert() {
//       QuickAlert.show(
//         context: context,
//         type: QuickAlertType.error, // Use an error or warning type
//         title: "Level Locked 🔒",
//         text:
//             "You must first complete Level ${levelNumber - 1} to unlock this challenge!",
//         confirmBtnText: "OK",
//         confirmBtnColor: AppColors.primary,
//         titleColor: AppColors.primary,
//         textColor: AppColors.black,
//         // Optional custom styling to match your game's aesthetic
//         backgroundColor: AppColors.white,
//         widget: Padding(
//           padding: const EdgeInsets.only(top: 8.0),
//           child: Text(
//             textAlign: TextAlign.center,
//             "Complete the previous level to proceed.",
//             style: GoogleFonts.poppins(fontSize: 14, color: AppColors.grey700),
//           ),
//         ),
//       );
//     }

//     // // Define the main tap action for UNLOCKED levels
//     // void _onPlayTap() async {
//     //   // Logic for playing the game
//     //   await Navigator.push(
//     //     context,
//     //     MaterialPageRoute(
//     //       builder: (_) => AdventurePlayerVsBot(difficulty: difficulty, level: levelNumber,),
//     //     ),
//     //   );
//     //   // Ensure we mark it complete after the match returns (win/loss)
//     //   await completeLevel(levelNumber);
//     // }

//     // return ValueListenableBuilder<double>(
//     //   valueListenable: _scaleNotifier,
//     //   builder: (context, scale, child) {
//     //     return Transform.scale(
//     //       scale: scale,
//     //       child: GestureDetector(
//     //         // Tap Down: Start the animation
//     //         onTapDown: (_) {
//     //           _scaleNotifier.value = 0.95; // Scale down on press
//     //         },
//     //         // Tap Up: Reset animation and execute action
//     //         onTapUp: (_) async {
//     //           // Reset scale quickly for a snapback effect
//     //           await Future.delayed(const Duration(milliseconds: 50));
//     //           _scaleNotifier.value = 1.0;

//     //           // Execute the appropriate action
//     //           if (unlocked) {
//     //             _onPlayTap();
//     //           } else {
//     //             _showLockedAlert(); // Show QuickAlert for locked levels
//     //           }
//     //         },
//     //         // Tap Cancel: Reset animation if user slides finger off
//     //         onTapCancel: () {
//     //           _scaleNotifier.value = 1.0;
//     //         },
//     //         // onTap: null to ensure onTapUp/onTapDown handle all logic
//     //         onTap: null,
//     //         child: Container(
//     //           padding: const EdgeInsets.symmetric(vertical: 18),
//     //           decoration: BoxDecoration(
//     //             color: unlocked ? Colors.amber : Colors.grey,
//     //             borderRadius: BorderRadius.circular(16),
//     //             boxShadow: [
//     //               BoxShadow(
//     //                 color: unlocked
//     //                     ? const Color.fromARGB(255, 122, 116, 14).withOpacity(0.5)
//     //                     : const Color.fromARGB(255, 180, 158, 30).withOpacity(0.35),
//     //                 blurRadius: 15,
//     //                 offset: const Offset(0, 6),
//     //               ),
//     //             ],
//     //           ),
//     //           child: Center(
//     //             child: Text(
//     //               unlocked ? "START MATCH" : "LOCKED",
//     //               style: GoogleFonts.poppins(
//     //                 color: AppColors.white,
//     //                 fontWeight: FontWeight.w800,
//     //                 letterSpacing: 1.5,
//     //                 fontSize: 17,
//     //               ),
//     //             ),
//     //           ),
//     //         ),
//     //       ),
//     //     );
//     //   },
//     // );

//     void _onPlayTap() async {
//       final result = await Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder:
//               (_) => AdventurePlayerVsBot(
//                 difficulty: difficulty,
//                 level: levelNumber,
//               ),
//         ),
//       );

//       if (result == true) {
//         await completeLevel(levelNumber);
//         QuickAlert.show(
//           context: context,
//           type: QuickAlertType.success,
//           title: "Level ${levelNumber} Completed! 🎉",
//           text: "You have unlocked the next challenge!",
//           confirmBtnColor: AppColors.primary,
//           confirmBtnText: "Great!",
//         );
//       }
//     }

//     return ValueListenableBuilder<double>(
//       valueListenable: _scaleNotifier,
//       builder: (context, scale, child) {
//         return Transform.scale(
//           scale: scale,
//           child: GestureDetector(
//             onTapDown: (_) {
//               _scaleNotifier.value = 0.95;
//             },
//             onTapUp: (_) async {
//               await Future.delayed(const Duration(milliseconds: 50));
//               _scaleNotifier.value = 1.0;
//               if (unlocked) {
//                 _onPlayTap();
//               } else {
//                 _showLockedAlert();
//               }
//             },
//             onTapCancel: () {
//               _scaleNotifier.value = 1.0;
//             },
//             onTap: null,
//             child: Container(
//               padding: const EdgeInsets.symmetric(vertical: 18),
//               decoration: BoxDecoration(
//                 color: unlocked ? Colors.amber : Colors.grey,
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color:
//                         unlocked
//                             ? const Color.fromARGB(
//                               255,
//                               122,
//                               116,
//                               14,
//                             ).withOpacity(0.5)
//                             : const Color.fromARGB(
//                               255,
//                               180,
//                               158,
//                               30,
//                             ).withOpacity(0.35),
//                     blurRadius: 15,
//                     offset: const Offset(0, 6),
//                   ),
//                 ],
//               ),
//               child: Center(
//                 child: Text(
//                   unlocked ? "START MATCH" : "LOCKED",
//                   style: GoogleFonts.poppins(
//                     color: AppColors.white,
//                     fontWeight: FontWeight.w800,
//                     letterSpacing: 1.5,
//                     fontSize: 17,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }




import 'package:audioplayers/audioplayers.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sungka/core/constants/app_colors.dart';
import 'package:sungka/screens/adventure_mode/game_match/adventure_player_vs_bot.dart';
import 'package:sungka/screens/components/pebble_bounce.dart';
import 'package:sungka/screens/home_screen.dart';
import 'package:sungka/screens/player_vs_bot/selection_mode.dart';
import 'package:quickalert/quickalert.dart';

// Assuming Difficulty is an enum or defined elsewhere, keeping the original logic
// as it relies on its existence.

class SungkaAdventureScreen extends StatefulWidget {
  final Function(Widget screen) navigateToScreen;
  final Function(String message) showError;
  final AudioPlayer bgmPlayer;


  const SungkaAdventureScreen({
    super.key,
    required this.navigateToScreen,
    required this.showError,
    required this.bgmPlayer
  });

  @override
  State<SungkaAdventureScreen> createState() => _SungkaAdventureScreenState();
}

class _SungkaAdventureScreenState extends State<SungkaAdventureScreen> {
  late PageController _pageController;
  int _currentLevel = 0;

  final ValueNotifier<double> _scaleNotifier = ValueNotifier(1.0);

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

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
    _scaleNotifier.dispose();
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

  Stream<List<int>> completedLevelsStream() {
    final user = auth.currentUser;
    if (user == null) return const Stream.empty();

    return firestore.collection('users').doc(user.uid).snapshots().map((
      snapshot,
    ) {
      final completed = snapshot.data()?['completedLevels'] ?? [];
      return List<int>.from(completed);
    });
  }

  Future<void> completeLevel(int levelNumber) async {
    final user = auth.currentUser;
    if (user == null) return;

    final userDoc = firestore.collection('users').doc(user.uid);
    // Ensure the document exists before trying to merge
    await userDoc.set(
      {
        'completedLevels': FieldValue.arrayUnion([levelNumber]),
      },
      SetOptions(merge: true),
    );
  }

  String _getLevelImagePath(int levelNumber) {
    return 'assets/images/assets/lvl$levelNumber.png';
  }

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
            child: StreamBuilder<List<int>>(
              stream: completedLevelsStream(),
              builder: (context, snapshot) {
                final completedLevels = snapshot.data ?? [];

                // Corrected and cleaned up the unlocking logic
                final updatedLevels = levels.map((level) {
                  final levelNumber = level['number'] as int;
                  bool unlocked = levelNumber == 1; // Level 1 is always unlocked

                  if (levelNumber > 1) {
                    // Unlock Level N if Level N-1 is in the completed list
                    unlocked = completedLevels.contains(levelNumber - 1);
                  }

                  return {
                    ...level,
                    'unlocked': unlocked,
                  };
                }).toList();

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(height: 60),
                      Image.asset(
                        'assets/images/assets/adventure_mode.png',
                        width: 420,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        height: height * 0.55,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: updatedLevels.length,
                          physics: const BouncingScrollPhysics(),
                          onPageChanged: (index) {
                            setState(() => _currentLevel = index);
                          },
                          itemBuilder: (context, index) {
                            final level = updatedLevels[index];
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
                      _buildLevelIndicator(updatedLevels),
                      const SizedBox(height: 28),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: _buildPlayButton(updatedLevels[_currentLevel]),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                );
              },
            ),
          ),

          // Back button with PebbleBounce
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
                            bgmPlayer: widget.bgmPlayer,
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

  Widget _buildLevelIndicator(List<Map<String, dynamic>> updatedLevels) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        updatedLevels.length,
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

  Widget _buildLevelCard(
    Map<String, dynamic> level, {
    required LinearGradient lockedGradient,
  }) {
    final bool unlocked = level["unlocked"];
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
                      : AppColors.black.withOpacity(0.6),
                  AppColors.black.withOpacity(0.9),
                ],
              ),
              border: Border.all(
                color: AppColors.white.withOpacity(unlocked ? 0.3 : 0.1),
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

  Widget _buildPlayButton(Map<String, dynamic> current) {
    final unlocked = current["unlocked"] as bool;
    final difficulty = current["level"];
    final levelNumber = current["number"] as int;

    void _showLockedAlert() {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: "Level Locked 🔒",
        text:
            "You must first complete Level ${levelNumber - 1} to unlock this challenge!",
        confirmBtnText: "OK",
        confirmBtnColor: AppColors.primary,
        titleColor: AppColors.primary,
        textColor: AppColors.black,
        backgroundColor: AppColors.white,
        widget: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            textAlign: TextAlign.center,
            "Complete the previous level to proceed.",
            style: GoogleFonts.poppins(fontSize: 14, color: AppColors.grey700),
          ),
        ),
      );
    }

    void _onPlayTap() async {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AdventurePlayerVsBot(
            difficulty: difficulty,
            level: levelNumber,
          ),
        ),
      );

      if (result == true) {
        await completeLevel(levelNumber);

        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: "Level $levelNumber Completed! 🎉",
          text: "You have unlocked the next challenge!",
          confirmBtnColor: AppColors.primary,
          confirmBtnText: "Great!",
        );
      }
    }

    return ValueListenableBuilder<double>(
      valueListenable: _scaleNotifier,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: GestureDetector(
            onTapDown: (_) {
              if (unlocked) {
                _scaleNotifier.value = 0.95;
              }
            },
            onTapUp: (_) async {
              await Future.delayed(const Duration(milliseconds: 50));
              _scaleNotifier.value = 1.0;
              if (unlocked) {
                _onPlayTap();
              } else {
                _showLockedAlert();
              }
            },
            onTapCancel: () {
              _scaleNotifier.value = 1.0;
            },
            onTap: null, // Logic handled by onTapUp/onTapDown
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                color: unlocked ? Colors.amber : Colors.grey,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: unlocked
                        ? const Color.fromARGB(
                            255,
                            122,
                            116,
                            14,
                          ).withOpacity(0.5)
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
          ),
        );
      },
    );
  }
}