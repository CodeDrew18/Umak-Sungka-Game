import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sungka/core/constants/app_colors.dart';
import 'package:sungka/screens/play_with_friends/game_match/match_screen.dart';
import 'package:sungka/screens/play_with_friends/provider/avatar_card.dart';
import 'package:sungka/screens/play_with_friends/provider/avatar_model.dart';

class AvatarSelectionScreen extends StatefulWidget {
  const AvatarSelectionScreen({Key? key}) : super(key: key);

  @override
  State<AvatarSelectionScreen> createState() => _AvatarSelectionScreenState();
}

class _AvatarSelectionScreenState extends State<AvatarSelectionScreen>
    with TickerProviderStateMixin {
  int selectedIndex = 0;
  int currentPlayer = 1;

  final List<Avatar> avatars = [
    Avatar(name: 'Classic', color: const Color(0xFFFFA500), icon: Icons.person),
    Avatar(
      name: 'King',
      color: const Color(0xFF8B8000),
      icon: Icons.emoji_events,
    ),
    Avatar(
      name: 'Happy',
      color: const Color(0xFF2ECC71),
      icon: Icons.sentiment_satisfied,
    ),
    Avatar(
      name: 'Shadow',
      color: const Color(0xFFB19CD9),
      icon: Icons.dark_mode,
    ),
    Avatar(name: 'Love', color: const Color(0xFFFF1493), icon: Icons.favorite),
    Avatar(name: 'Star', color: const Color(0xFF1E90FF), icon: Icons.star),
    Avatar(
      name: 'Thunder',
      color: const Color(0xFFFFD700),
      icon: Icons.flash_on,
    ),
    Avatar(name: 'Warrior', color: const Color(0xFF5F7C8A), icon: Icons.shield),
  ];

  int? player1Selection;
  int? player2Selection;

  void _onContinue() {
    if (currentPlayer == 1) {
      player1Selection = selectedIndex;
      setState(() {
        currentPlayer = 2;
        selectedIndex = 0;
      });
    } else {
      player2Selection = selectedIndex;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (_) => MatchScreen(
                player1Name: "Player 1",
                player1Icon: avatars[player1Selection!].icon,
                player1Color: avatars[player1Selection!].color,
                player2Name: "Player 2",
                player2Icon: avatars[player2Selection!].icon,
                player2Color: avatars[player2Selection!].color,
              ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 200),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color:
                        currentPlayer == 1
                            ? const Color(0xFFFFA500)
                            : Colors.grey.shade700,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color:
                        currentPlayer == 2
                            ? const Color(0xFFFFA500)
                            : Colors.grey.shade700,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          const Gap(10),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 600),
            transitionBuilder: (Widget child, Animation<double> animation) {
              final slideAnimation = Tween<Offset>(
                begin: const Offset(0.0, 0.5),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
              );

              final fadeAnimation = CurvedAnimation(
                parent: animation,
                curve: Curves.easeIn,
              );

              return SlideTransition(
                position: slideAnimation,
                child: FadeTransition(opacity: fadeAnimation, child: child),
              );
            },
            child: Text(
              'Player $currentPlayer',
              key: ValueKey<int>(currentPlayer),
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black54,
                    blurRadius: 10,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
            ),
          ),
          const Text(
            'Choose your avatar',
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFFFFA500),
              fontWeight: FontWeight.w600,
            ),
          ),
          const Gap(10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GridView.builder(
                itemCount: avatars.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final isDisabled =
                      currentPlayer == 2 && player1Selection == index;

                  return Opacity(
                    opacity: isDisabled ? 0.4 : 1.0,
                    child: IgnorePointer(
                      ignoring: isDisabled,
                      child: AvatarCard(
                        avatar: avatars[index],
                        isSelected: selectedIndex == index,
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const Gap(15),
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFA500).withOpacity(0.6),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: _onContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFFA500),
                padding: const EdgeInsets.symmetric(
                  horizontal: 60,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                currentPlayer == 1 ? 'CONTINUE' : 'START GAME',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
