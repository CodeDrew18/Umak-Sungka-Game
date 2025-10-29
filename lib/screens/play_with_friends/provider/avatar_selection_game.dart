// lib/screens/play_with_friends/avatar_selection/avatar_selection_game.dart
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:sungka/core/constants/app_colors.dart';

import 'package:sungka/screens/play_with_friends/game_match/match_screen.dart';
import 'package:sungka/screens/play_with_friends/provider/avatar_icon_component.dart';
import 'package:sungka/screens/play_with_friends/provider/avatar_selection_button.dart';

class AvatarSelectionGame extends FlameGame with TapCallbacks, HoverCallbacks {
  final BuildContext context;

  late TextComponent title;
  late TextComponent subtitle;
  int currentPlayer = 1;
  int? player1Index;
  int? player2Index;
  int selectedIndex = 0;

  final List<Map<String, dynamic>> avatars = [
    {"name": "Classic", "color": const Color(0xFFFFA500), "icon": Icons.person},
    {"name": "King", "color": const Color(0xFF8B8000), "icon": Icons.emoji_events},
    {"name": "Happy", "color": const Color(0xFF2ECC71), "icon": Icons.sentiment_satisfied},
    {"name": "Shadow", "color": const Color(0xFFB19CD9), "icon": Icons.dark_mode},
    {"name": "Love", "color": const Color(0xFFFF1493), "icon": Icons.favorite},
    {"name": "Star", "color": const Color(0xFF1E90FF), "icon": Icons.star},
    {"name": "Thunder", "color": const Color(0xFFFFD700), "icon": Icons.flash_on},
    {"name": "Warrior", "color": const Color(0xFF5F7C8A), "icon": Icons.shield},
  ];

  AvatarSelectionGame(this.context);

  @override
  Color backgroundColor() => const Color(0xFF1E1E1E);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    title = TextComponent(
      text: "Player $currentPlayer",
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 36,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(size.x / 2, size.y * 0.15),
    );
    add(title);

    subtitle = TextComponent(
      text: "Choose your avatar",
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 20,
          color: AppColors.titleColor,
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(size.x / 2, size.y * 0.22),
    );
    add(subtitle);

    // Create avatar icons
    _createAvatarIcons();

    // Continue button
    final button = AvatarSelectionButton(
      label: "CONTINUE",
      onPressed: _onContinue,
    )..position = Vector2(size.x / 2, size.y * 0.9);
    add(button);
  }

  void _createAvatarIcons() {
    const double spacing = 140;
    const double startY = 300;
    const int columns = 4;

    for (int i = 0; i < avatars.length; i++) {
      final row = i ~/ columns;
      final col = i % columns;
      final posX = size.x / 2 - (spacing * (columns - 1) / 2) + (col * spacing);
      final posY = startY + row * 140;

      final avatar = avatars[i];
      final icon = AvatarIconComponent(
        index: i,
        name: avatar["name"],
        color: avatar["color"],
        icon: avatar["icon"],
        onSelect: _onSelect,
      )
        ..position = Vector2(posX, posY)
        ..anchor = Anchor.center;
      add(icon);
    }
  }

  void _onSelect(int index) {
    selectedIndex = index;
  }

  void _onContinue() {
    if (currentPlayer == 1) {
      player1Index = selectedIndex;
      currentPlayer = 2;
      title.text = "Player 2";
    } else {
      player2Index = selectedIndex;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => MatchScreen(
            player1Name: "Player 1",
            player1Icon: avatars[player1Index!]["icon"],
            player1Color: avatars[player1Index!]["color"],
            player2Name: "Player 2",
            player2Icon: avatars[player2Index!]["icon"],
            player2Color: avatars[player2Index!]["color"],
          ),
        ),
      );
    }
  }
}
