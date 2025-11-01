import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:sungka/core/constants/app_colors.dart';
import 'package:sungka/core/services/firebase_firestore_service.dart';
import 'package:sungka/screens/adventure_mode/adventure_screen.dart';
import 'package:sungka/screens/components/animated_title.dart';
import 'package:sungka/screens/components/game_back_button.dart';
import 'package:sungka/screens/components/home_game_button.dart';
import 'package:sungka/screens/components/particle_background.dart';
import 'package:sungka/screens/components/settings_button.dart';
import 'package:sungka/screens/components/water_effect.dart';
import 'package:sungka/screens/online/online_game_screen.dart';
import 'package:sungka/screens/online/waiting_for_opponent_screen.dart';
import 'package:sungka/screens/play_with_friends/play_with_friends_screen.dart';
import 'package:sungka/screens/player_vs_bot/selection_mode.dart';
import 'package:sungka/screens/settings/settings_screen.dart';
import 'package:sungka/screens/start_game_screen.dart';

class HomeGame extends FlameGame with TapCallbacks, HoverCallbacks {
  final BuildContext context;
  ParticleBackground? particleBackground;
  AnimatedTitle? titleComponent;
  WaterEffect? waterEffect;
  List<HomeGameButton>? modeButtons;
  GameBackButton? backButton;
  SettingsButton? settingsButton;
  final firestoreService = FirebaseFirestoreService();

  HomeGame(this.context);

  @override
  Color backgroundColor() => const Color(0xFF1E1E1E);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    waterEffect = WaterEffect();
    add(waterEffect!);

    particleBackground = ParticleBackground();
    add(particleBackground!);

    titleComponent = AnimatedTitle(title: 'Choose Your Battle Mode');
    add(titleComponent!);

    backButton = GameBackButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => StartGameScreen()),
        );
      },
      primaryColor: AppColors.titleColor,
      accentColor: AppColors.primary,
    );
    backButton!.position = Vector2(20, 20);
    add(backButton!);

      settingsButton = SettingsButton(
        onPressed: () {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.push(
              context,
             MaterialPageRoute(
                  builder: (_) => GameWidget(
                    game: SettingsGame(context),
                  ),
                ),

            );
          });
        },
        primaryColor: AppColors.titleColor,
        accentColor: AppColors.primary,
        icon: Icons.settings,
      );
    settingsButton!.position = Vector2(70, 80);
    add(settingsButton!);

    modeButtons = [
      HomeGameButton(
        position: Vector2.zero(),
        label: 'Player vs Player',
        description: 'Challenge random\nplayer online',
        icon: Icons.language_outlined,
        gradient: AppColors.gradient1,
        onPressed: () async {
          await online();
        },
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
    if (backButton != null) {
      backButton!.position = Vector2(20, 20);
    }

    if (settingsButton != null) {
      settingsButton!.position = Vector2( currentSize.x - 70, 50);
    }

    if (titleComponent != null) {
      titleComponent!.position = Vector2(
        currentSize.x / 2,
        currentSize.y * 0.18,
      );
    }

    if (modeButtons != null && modeButtons!.isNotEmpty) {
      const buttonWidth = 160.0;
      const spacing = 30.0;
      final totalWidth =
          (buttonWidth * modeButtons!.length) +
          (spacing * (modeButtons!.length - 1));
      final startX = (currentSize.x - totalWidth) / 2 + (buttonWidth / 2);
      final centerY = currentSize.y * 0.6;

      for (int i = 0; i < modeButtons!.length; i++) {
        final x = startX + i * (buttonWidth + spacing);
        modeButtons![i].position = Vector2(x, centerY);
      }
    }
  }

  void _onModeSelected(String mode) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      switch (mode) {
        case 'adventure':
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SungkaAdventureScreen()),
          );
          break;
        case 'friends':
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AvatarSelectionScreen()),
          );
          break;
        case 'bot':
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SelectionMode()),
          );
          break;
      }
    });
  }

  Future<void> online() async {
    final user = FirebaseAuth.instance.currentUser;

    try {
      final userDoc = await firestoreService.getUser(user: user!);

      if (!userDoc.exists) throw Exception("User not found.");

      final userData = userDoc.data() as Map<String, dynamic>;
      final userName = userData["name"];
      final userRating = userData['rating'] ?? 800;
      final minRating = userRating - 100;
      final maxRating = userRating + 100;
      final findMatch = await firestoreService.findMatch(
        minRating: minRating,
        maxRating: maxRating,
      );

      if (findMatch.docs.isNotEmpty) {
        final match = findMatch.docs.first;

        await firestoreService.joinMatch(
          matchId: match.id,
          userId: user.uid,
          userName: userName,
          rating: userRating,
        );

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => OnlineGameScreen(matchId: match.id),
          ),
        );
      } else {
        final newMatch = await firestoreService.newMatch(
          userId: user.uid,
          userName: userName,
          userRating: userRating,
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WaitingForOpponentScreen(matchId: newMatch.id),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$e")));
    }
  }
}
