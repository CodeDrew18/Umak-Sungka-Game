// // // import 'package:firebase_auth/firebase_auth.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:gap/gap.dart';
// // // import 'package:google_fonts/google_fonts.dart';
// // // import 'package:sungka/core/constants/app_colors.dart';
// // // import 'package:sungka/core/services/firebase_auth_service.dart';
// // // import 'package:sungka/core/services/firebase_firestore_service.dart';
// // // import 'package:sungka/screens/online/online_game_screen.dart';
// // // import 'package:sungka/screens/online/waiting_for_opponent_screen.dart';
// // // import 'package:sungka/screens/play_with_friends/play_with_friends_screen.dart';

// // // class HomeScreen extends StatelessWidget {
// // //   HomeScreen({super.key});

// // //   final firestoreService = FirebaseFirestoreService();

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         actions: [
// // //           Row(
// // //             children: [
// // //               GestureDetector(
// // //                 onTap: () {
// // //                 FirebaseAuthService().logout();
// // //                 },
// // //                 child: Container(
// // //                   width: 50,
// // //                   height: 50,
// // //                   child: CircleAvatar(
// // //                     child: Icon(Icons.settings),
// // //                     backgroundColor: AppColors.primary,
// // //                   ),
// // //                 ),
// // //               ),
// // //               Gap(15),
// // //               Container(
// // //                 width: 50,
// // //                 height: 50,
// // //                 child: CircleAvatar(
// // //                   child: Icon(Icons.games_rounded),
// // //                   backgroundColor: AppColors.primary,
// // //                 ),
// // //               ),
// // //             ],
// // //           ),
// // //         ],
// // //       ),
// // //       backgroundColor: AppColors.background,
// // //       body: Column(
// // //         children: [
// // //           // para sa easy access features
// // //           Gap(15),
// // //           Text(
// // //             "Choose Your Battle Mode",
// // //             style: GoogleFonts.poppins(
// // //               fontSize: 30,
// // //               fontWeight: FontWeight.w900,
// // //               color: AppColors.titleColor,
// // //               shadows: [
// // //                 Shadow(
// // //                   color: AppColors.titleColor.withOpacity(0.4),
// // //                   blurRadius: 14,
// // //                   offset: Offset(2, 4),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),

// // //           //All List Features
// // //           Gap(35),
// // //           SingleChildScrollView(
// // //             scrollDirection: Axis.horizontal,
// // //             child: Row(
// // //               mainAxisAlignment: MainAxisAlignment.center,
// // //               children: [
// // //                 Gap(50),
// // //                 GestureDetector(
// // //                   onTap: () => online(context),
// // //                   child: Container(
// // //                     width: 220,
// // //                     height: 220,
// // //                     decoration: BoxDecoration(
// // //                       borderRadius: BorderRadius.circular(15),
// // //                       gradient: AppColors.gradient1,
// // //                     ),
// // //                     child: Column(
// // //                       mainAxisAlignment: MainAxisAlignment.center,
// // //                       children: [
// // //                         Icon(Icons.language_outlined, size: 50),
// // //                         Text(
// // //                           "Player vs Player",
// // //                           style: GoogleFonts.poppins(
// // //                             color: AppColors.white,
// // //                             fontWeight: FontWeight.w500,
// // //                             fontSize: 20,
// // //                           ),
// // //                         ),
// // //                         Padding(
// // //                           padding: const EdgeInsets.only(
// // //                             left: 16.0,
// // //                             right: 16,
// // //                             top: 10,
// // //                             bottom: 10,
// // //                           ),
// // //                           child: Divider(
// // //                             height: 5,
// // //                             color: AppColors.white.withOpacity(0.8),
// // //                           ),
// // //                         ),
// // //                         Text(
// // //                           "Challenge random",
// // //                           style: GoogleFonts.poppins(
// // //                             color: AppColors.white,
// // //                             fontSize: 14,
// // //                           ),
// // //                         ),
// // //                         Text(
// // //                           "player online",
// // //                           style: GoogleFonts.poppins(
// // //                             color: AppColors.white,
// // //                             fontSize: 14,
// // //                           ),
// // //                         ),
// // //                       ],
// // //                     ),
// // //                   ),
// // //                 ),
// // //                 Gap(15),

// // //                 Container(
// // //                   width: 220,
// // //                   height: 220,
// // //                   decoration: BoxDecoration(
// // //                     borderRadius: BorderRadius.circular(15),
// // //                     gradient: AppColors.gradient3,
// // //                   ),
// // //                   child: Column(
// // //                     mainAxisAlignment: MainAxisAlignment.center,
// // //                     children: [
// // //                       Icon(Icons.terrain_rounded, size: 50),
// // //                       Text(
// // //                         "Adventure Mode",
// // //                         style: GoogleFonts.poppins(
// // //                           color: AppColors.white,
// // //                           fontWeight: FontWeight.w500,
// // //                           fontSize: 20,
// // //                         ),
// // //                       ),
// // //                       Padding(
// // //                         padding: const EdgeInsets.only(
// // //                           left: 16.0,
// // //                           right: 16,
// // //                           top: 10,
// // //                           bottom: 10,
// // //                         ),
// // //                         child: Divider(
// // //                           height: 5,
// // //                           color: AppColors.white.withOpacity(0.8),
// // //                         ),
// // //                       ),
// // //                       Text(
// // //                         "Think, play, and",
// // //                         style: GoogleFonts.poppins(
// // //                           color: AppColors.white,
// // //                           fontSize: 14,
// // //                         ),
// // //                       ),
// // //                       Text(
// // //                         "outsmart your rivals.",
// // //                         style: GoogleFonts.poppins(
// // //                           color: AppColors.white,
// // //                           fontSize: 14,
// // //                         ),
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ),

// // //                 Gap(15),

// // //                 GestureDetector(
// // //                   onTap:
// // //                       () => Navigator.push(
// // //                         context,
// // //                         MaterialPageRoute(
// // //                           builder: (_) => AvatarSelectionScreen(),
// // //                         ),
// // //                       ),
// // //                   child: Container(
// // //                     width: 220,
// // //                     height: 220,
// // //                     decoration: BoxDecoration(
// // //                       borderRadius: BorderRadius.circular(15),
// // //                       gradient: AppColors.gradient2,
// // //                     ),
// // //                     child: Column(
// // //                       mainAxisAlignment: MainAxisAlignment.center,
// // //                       children: [
// // //                         Icon(Icons.people, size: 50),
// // //                         Text(
// // //                           "Player with friends",
// // //                           style: GoogleFonts.poppins(
// // //                             color: AppColors.white,
// // //                             fontWeight: FontWeight.w500,
// // //                             fontSize: 20,
// // //                           ),
// // //                         ),
// // //                         Padding(
// // //                           padding: const EdgeInsets.only(
// // //                             left: 16.0,
// // //                             right: 16,
// // //                             top: 10,
// // //                             bottom: 10,
// // //                           ),
// // //                           child: Divider(
// // //                             height: 5,
// // //                             color: AppColors.white.withOpacity(0.8),
// // //                           ),
// // //                         ),
// // //                         Text(
// // //                           "Play with your friends",
// // //                           style: GoogleFonts.poppins(
// // //                             color: AppColors.white,
// // //                             fontSize: 14,
// // //                           ),
// // //                         ),
// // //                         Text(
// // //                           "locally",
// // //                           style: GoogleFonts.poppins(
// // //                             color: AppColors.white,
// // //                             fontSize: 14,
// // //                           ),
// // //                         ),
// // //                       ],
// // //                     ),
// // //                   ),
// // //                 ),
// // //                 Gap(15),
// // //                 Container(
// // //                   width: 220,
// // //                   height: 220,
// // //                   decoration: BoxDecoration(
// // //                     borderRadius: BorderRadius.circular(15),
// // //                     gradient: AppColors.gradient3,
// // //                   ),
// // //                   child: Column(
// // //                     mainAxisAlignment: MainAxisAlignment.center,
// // //                     children: [
// // //                       Icon(Icons.smart_toy, size: 50),
// // //                       Text(
// // //                         "Player vs Bot",
// // //                         style: GoogleFonts.poppins(
// // //                           color: AppColors.white,
// // //                           fontWeight: FontWeight.w500,
// // //                           fontSize: 20,
// // //                         ),
// // //                       ),
// // //                       Padding(
// // //                         padding: const EdgeInsets.only(
// // //                           left: 16.0,
// // //                           right: 16,
// // //                           top: 10,
// // //                           bottom: 10,
// // //                         ),
// // //                         child: Divider(
// // //                           height: 5,
// // //                           color: AppColors.white.withOpacity(0.8),
// // //                         ),
// // //                       ),
// // //                       Text(
// // //                         "Test Your Skills",
// // //                         style: GoogleFonts.poppins(
// // //                           color: AppColors.white,
// // //                           fontSize: 14,
// // //                         ),
// // //                       ),
// // //                       Text(
// // //                         "Offline",
// // //                         style: GoogleFonts.poppins(
// // //                           color: AppColors.white,
// // //                           fontSize: 14,
// // //                         ),
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ),
// // //                 Gap(50),
// // //               ],
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   Future<void> online(BuildContext context) async {
// // //     final user = FirebaseAuth.instance.currentUser;

// // //     try {
// // //       final userDoc = await firestoreService.getUser(user: user!);

// // //       if (!userDoc.exists) throw Exception("User not found.");

// // //       final userData = userDoc.data() as Map<String, dynamic>;
// // //       final userName = userData["name"];
// // //       final userRating = userData['rating'] ?? 800;
// // //       final minRating = userRating - 100;
// // //       final maxRating = userRating + 100;
// // //       final findMatch = await firestoreService.findMatch(
// // //         minRating: minRating,
// // //         maxRating: maxRating,
// // //       );

// // //       if (findMatch.docs.isNotEmpty) {
// // //         final match = findMatch.docs.first;

// // //         await firestoreService.joinMatch(
// // //           matchId: match.id,
// // //           userId: user.uid,
// // //           userName: userName,
// // //           rating: userRating,
// // //         );

// // //         Navigator.of(context).push(
// // //           MaterialPageRoute(
// // //             builder: (_) => OnlineGameScreen(matchId: match.id),
// // //           ),
// // //         );
// // //       } else {
// // //         final newMatch = await firestoreService.newMatch(
// // //           userId: user.uid,
// // //           userName: userName,
// // //           userRating: userRating,
// // //         );

// // //         Navigator.push(
// // //           context,
// // //           MaterialPageRoute(
// // //             builder: (_) => WaitingForOpponentScreen(matchId: newMatch.id),
// // //           ),
// // //         );
// // //       }
// // //     } catch (e) {
// // //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$e")));
// // //     }
// // //   }
// // // }




// // import 'package:flame/game.dart';
// // import 'package:flutter/material.dart';
// // import 'package:sungka/core/constants/app_colors.dart';
// // import 'package:sungka/screens/components/animated_title.dart';
// // import 'package:sungka/screens/components/home_game_button.dart';
// // import 'package:sungka/screens/components/particle_background.dart';
// // import 'package:sungka/screens/components/water_effect.dart';

// // class HomeGame extends FlameGame {
// //   ParticleBackground? particleBackground;
// //   AnimatedTitle? titleComponent;
// //   WaterEffect? waterEffect;
// //   List<HomeGameButton>? modeButtons;

// //   @override
// //   Color backgroundColor() => const Color(0xFF1E1E1E);

// //   @override
// //   Future<void> onLoad() async {
// //     await super.onLoad();

// //     // Safely create components
// //     waterEffect = WaterEffect();
// //     add(waterEffect!);

// //     particleBackground = ParticleBackground();
// //     add(particleBackground!);

// //     titleComponent = AnimatedTitle(
// //       title: 'Choose Your Battle',
// //       subtitle: 'Mode',
// //     );
// //     add(titleComponent!);

// //     // Initialize buttons safely
// //     modeButtons = [
// //       HomeGameButton(
// //         position: Vector2.zero(),
// //         label: 'Player vs Player',
// //         description: 'Challenge random\nplayer online',
// //         icon: Icons.language_outlined,
// //         gradient: AppColors.gradient1,
// //         onPressed: () => _onModeSelected('pvp'),
// //       ),
// //       HomeGameButton(
// //         position: Vector2.zero(),
// //         label: 'Adventure Mode',
// //         description: 'Think, play, and\noutsmart rivals',
// //         icon: Icons.terrain_rounded,
// //         gradient: AppColors.gradient2,
// //         onPressed: () => _onModeSelected('adventure'),
// //       ),
// //       HomeGameButton(
// //         position: Vector2.zero(),
// //         label: 'Play with Friends',
// //         description: 'Play with your\nfriends locally',
// //         icon: Icons.people,
// //         gradient: AppColors.gradient3,
// //         onPressed: () => _onModeSelected('friends'),
// //       ),
// //       HomeGameButton(
// //         position: Vector2.zero(),
// //         label: 'Player vs Bot',
// //         description: 'Test your skills\noffline',
// //         icon: Icons.smart_toy,
// //         gradient: AppColors.gradient1,
// //         onPressed: () => _onModeSelected('bot'),
// //       ),
// //     ];

// //     // Add buttons safely
// //     if (modeButtons != null) {
// //       for (var button in modeButtons!) {
// //         add(button);
// //       }
// //     }
// //   }

// //   @override
// //   void onMount() {
// //     super.onMount();
// //     // Position everything once the game is ready
// //     _updateLayout(size);
// //   }

// //   @override
// //   void onGameResize(Vector2 newSize) {
// //     super.onGameResize(newSize);
// //     _updateLayout(newSize);
// //   }

// //   void _updateLayout(Vector2 currentSize) {
// //     // Safely position title
// //     if (titleComponent != null) {
// //       titleComponent!.position =
// //           Vector2(currentSize.x / 2, currentSize.y * 0.15);
// //     }

// //     // Safely position buttons
// //     if (modeButtons != null && modeButtons!.isNotEmpty) {
// //       final positions = [0.40, 0.55, 0.70, 0.85];
// //       for (int i = 0; i < modeButtons!.length; i++) {
// //         modeButtons![i].position =
// //             Vector2(currentSize.x / 2, currentSize.y * positions[i]);
// //       }
// //     }
// //   }

// //   void _onModeSelected(String mode) {
// //     debugPrint('Selected mode: $mode');
// //   }
// // }





// import 'package:flame/game.dart';
// import 'package:flutter/material.dart';
// import 'package:sungka/core/constants/app_colors.dart';
// import 'package:sungka/screens/components/animated_title.dart';
// import 'package:sungka/screens/components/home_game_button.dart';
// import 'package:sungka/screens/components/particle_background.dart';
// import 'package:sungka/screens/components/water_effect.dart';

// class HomeGame extends FlameGame {
//   ParticleBackground? particleBackground;
//   AnimatedTitle? titleComponent;
//   WaterEffect? waterEffect;
//   List<HomeGameButton>? modeButtons;

//   @override
//   Color backgroundColor() => const Color(0xFF1E1E1E);

//   @override
//   Future<void> onLoad() async {
//     await super.onLoad();

//     // Add visual layers
//     waterEffect = WaterEffect();
//     add(waterEffect!);

//     particleBackground = ParticleBackground();
//     add(particleBackground!);

//     // Title
//     titleComponent = AnimatedTitle(
//       title: 'Choose Your Battle Mode',
//     );
//     add(titleComponent!);

//     // Create the mode buttons
//     modeButtons = [
//       HomeGameButton(
//         position: Vector2.zero(),
//         label: 'Player vs Player',
//         description: 'Challenge random\nplayer online',
//         icon: Icons.language_outlined,
//         gradient: AppColors.gradient1,
//         onPressed: () => _onModeSelected('pvp'),
//       ),
//       HomeGameButton(
//         position: Vector2.zero(),
//         label: 'Adventure Mode',
//         description: 'Think, play, and\noutsmart rivals',
//         icon: Icons.terrain_rounded,
//         gradient: AppColors.gradient2,
//         onPressed: () => _onModeSelected('adventure'),
//       ),
//       HomeGameButton(
//         position: Vector2.zero(),
//         label: 'Play with Friends',
//         description: 'Play with your\nfriends locally',
//         icon: Icons.people,
//         gradient: AppColors.gradient3,
//         onPressed: () => _onModeSelected('friends'),
//       ),
//       HomeGameButton(
//         position: Vector2.zero(),
//         label: 'Player vs Bot',
//         description: 'Test your skills\noffline',
//         icon: Icons.smart_toy,
//         gradient: AppColors.gradient1,
//         onPressed: () => _onModeSelected('bot'),
//       ),
//     ];

//     // Add buttons to the game
//     for (var button in modeButtons!) {
//       add(button);
//     }
//   }

//   @override
//   void onMount() {
//     super.onMount();
//     _updateLayout(size);
//   }

//   @override
//   void onGameResize(Vector2 newSize) {
//     super.onGameResize(newSize);
//     _updateLayout(newSize);
//   }

//   void _updateLayout(Vector2 currentSize) {
//     // Title centered
//     if (titleComponent != null) {
//       titleComponent!.position = Vector2(currentSize.x / 2, currentSize.y * 0.18);
//     }

//     // Arrange buttons in a Row (centered horizontally)
//     if (modeButtons != null && modeButtons!.isNotEmpty) {
//       final buttonWidth = 160.0;
//       final spacing = 30.0;
//       final totalWidth = (buttonWidth * modeButtons!.length) + (spacing * (modeButtons!.length - 1));
//       final startX = (currentSize.x - totalWidth) / 2 + (buttonWidth / 2);
//       final centerY = currentSize.y * 0.6;

//       for (int i = 0; i < modeButtons!.length; i++) {
//         final x = startX + i * (buttonWidth + spacing);
//         modeButtons![i].position = Vector2(x, centerY);
//       }
//     }
//   }

//   void _onModeSelected(String mode) {
//     debugPrint('Selected mode: $mode');
//   }
// }



import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:sungka/core/constants/app_colors.dart';
import 'package:sungka/screens/components/animated_title.dart';
import 'package:sungka/screens/components/home_game_button.dart';
import 'package:sungka/screens/components/particle_background.dart';
import 'package:sungka/screens/components/water_effect.dart';

class HomeGame extends FlameGame {
  ParticleBackground? particleBackground;
  AnimatedTitle? titleComponent;
  WaterEffect? waterEffect;
  List<HomeGameButton>? modeButtons;

  late final AudioPlayer _audioPlayer;

  @override
  Color backgroundColor() => const Color(0xFF1E1E1E);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // 🎵 Initialize background music
    _audioPlayer = AudioPlayer();
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.play(AssetSource('audio/sunngka_music.mp3'));

    // 🌊 Water effect
    waterEffect = WaterEffect();
    add(waterEffect!);

    // ✨ Particle background
    particleBackground = ParticleBackground();
    add(particleBackground!);

    // 🎯 Title
    titleComponent = AnimatedTitle(title: 'Choose Your Battle Mode');
    add(titleComponent!);

    // 🕹️ Mode buttons
    modeButtons = [
      HomeGameButton(
        position: Vector2.zero(),
        label: 'Player vs Player',
        description: 'Challenge random\nplayer online',
        icon: Icons.language_outlined,
        gradient: AppColors.gradient1,
        onPressed: () => _onModeSelected('pvp'),
      ),
      HomeGameButton(
        position: Vector2.zero(),
        label: 'Adventure Mode',
        description: 'Think, play, and\noutsmart rivals',
        icon: Icons.terrain_rounded,
        gradient: AppColors.gradient2,
        onPressed: () => _onModeSelected('adventure'),
      ),
      HomeGameButton(
        position: Vector2.zero(),
        label: 'Play with Friends',
        description: 'Play with your\nfriends locally',
        icon: Icons.people,
        gradient: AppColors.gradient3,
        onPressed: () => _onModeSelected('friends'),
      ),
      HomeGameButton(
        position: Vector2.zero(),
        label: 'Player vs Bot',
        description: 'Test your skills\noffline',
        icon: Icons.smart_toy,
        gradient: AppColors.gradient1,
        onPressed: () => _onModeSelected('bot'),
      ),
    ];

    // Add buttons to the game
    for (var button in modeButtons!) {
      add(button);
    }
  }

  @override
  void onMount() {
    super.onMount();
    _updateLayout(size);
  }

  @override
  void onGameResize(Vector2 newSize) {
    super.onGameResize(newSize);
    _updateLayout(newSize);
  }

  void _updateLayout(Vector2 currentSize) {
    // Title centered
    if (titleComponent != null) {
      titleComponent!.position = Vector2(currentSize.x / 2, currentSize.y * 0.18);
    }

    // Arrange buttons horizontally
    if (modeButtons != null && modeButtons!.isNotEmpty) {
      const buttonWidth = 160.0;
      const spacing = 30.0;
      final totalWidth = (buttonWidth * modeButtons!.length) + (spacing * (modeButtons!.length - 1));
      final startX = (currentSize.x - totalWidth) / 2 + (buttonWidth / 2);
      final centerY = currentSize.y * 0.6;

      for (int i = 0; i < modeButtons!.length; i++) {
        final x = startX + i * (buttonWidth + spacing);
        modeButtons![i].position = Vector2(x, centerY);
      }
    }
  }

  void _onModeSelected(String mode) {
    debugPrint('Selected mode: $mode');
  }

  @override
  void onRemove() {
    // Stop and dispose of background music when leaving the screen
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.onRemove();
  }
}
