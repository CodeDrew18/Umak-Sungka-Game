import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:sungka/core/constants/app_colors.dart';
import 'package:sungka/core/services/firebase_firestore_service.dart';
import 'package:sungka/screens/adventure_mode/adventure_screen.dart';
import 'package:sungka/screens/components/game_back_button.dart';
import 'package:sungka/screens/components/leaderboard_button.dart';
import 'package:sungka/screens/leaderboards/leaderboards_screen.dart';
import 'package:sungka/screens/components/settings_button.dart';
import 'package:sungka/screens/online/online_game_screen.dart';
import 'package:sungka/screens/online/waiting_for_opponent_screen.dart';
import 'package:sungka/screens/play_with_friends/play_with_friends_screen.dart';
import 'package:sungka/screens/player_vs_bot/selection_mode.dart';
import 'package:sungka/screens/settings/settings_screen.dart'; 
import 'package:sungka/screens/start_game_screen.dart';
import 'package:sungka/screens/components/image_game_button.dart'; 

class HomeGame extends FlameGame with TapCallbacks, HoverCallbacks {
SpriteComponent? backgroundImage;
SpriteComponent? titleImageComponent; 
List<ImageGameButton>? modeButtons; 
SpriteComponent? boardComponent;
GameBackButton? backButton;
SettingsButton? settingsButton;
final Function(Widget screen) navigateToScreen;
LeaderboardButton? leaderboardButton;
final Function(String message) showError;

final firestoreService = FirebaseFirestoreService();

HomeGame({required this.navigateToScreen, required this.showError,});

@override
Color backgroundColor() => const Color(0xFF1E1E1E);

@override
Future<void> onLoad() async {
await super.onLoad();

backgroundImage = SpriteComponent()
..sprite = await loadSprite('assets/bg.png')
..size = size
..position = Vector2.zero()
..priority = -10;
add(backgroundImage!);

titleImageComponent = SpriteComponent()
..sprite = await loadSprite('assets/home_title.png') 
..size = Vector2(450, 400)
..anchor = Anchor.center;
add(titleImageComponent!);

backButton = GameBackButton(
onPressed: () {
navigateToScreen(
GameWidget(
game: StartMenuGame(
navigateToScreen: navigateToScreen,
showError: showError,
),
),
);
},
primaryColor: AppColors.titleColor,
accentColor: AppColors.primary,
);
add(backButton!);

settingsButton = SettingsButton(
onPressed: () {
navigateToScreen(
GameWidget(
    game: SettingsGame(
    navigateToScreen: navigateToScreen, 
    showError: showError,
    ),
  ),
);
},
primaryColor: AppColors.titleColor,
accentColor: AppColors.primary,
icon: Icons.settings,
);
add(settingsButton!);

leaderboardButton = LeaderboardButton(
onPressed: () {
navigateToScreen(const LeaderboardScreen());
},
primaryColor: AppColors.titleColor,
accentColor: AppColors.primary,
icon: Icons.emoji_events,
);
add(leaderboardButton!);

modeButtons = [
ImageGameButton(
spritePath: 'assets/p2p.png', 
onPressed: () async { await online(); },
),
ImageGameButton(
spritePath: 'assets/adventure.png', 
onPressed: () => _onModeSelected('adventure'),
),
ImageGameButton(
spritePath: 'assets/p2f.png', 
onPressed: () => _onModeSelected('friends'),
),
ImageGameButton(
spritePath: 'assets/p2b.png', 
onPressed: () => _onModeSelected('bot'),
),
];

for (var button in modeButtons!) {
add(button);
}

boardComponent = SpriteComponent()
..sprite = await loadSprite('assets/board.png')
..size = Vector2(300, 120)
..anchor = Anchor.center;
add(boardComponent!);
}


@override
void onGameResize(Vector2 newSize) {
super.onGameResize(newSize);

if (backgroundImage != null) {
backgroundImage!
..size = newSize
..position = Vector2.zero();
}
_updateLayout(newSize);
}

void _updateLayout(Vector2 currentSize) {
if (backButton != null) {
backButton!.position = Vector2(20, 20);
}
if (settingsButton != null) {
settingsButton!.position = Vector2(currentSize.x - 50, 60);
}
if (leaderboardButton != null) {
leaderboardButton!.position = Vector2(currentSize.x - 120, 60);
}

if (titleImageComponent != null) {
titleImageComponent!.position = Vector2(
currentSize.x / 2,
currentSize.y * 0.20, 
);
}

if (modeButtons != null && modeButtons!.isNotEmpty) {
const buttonWidth = 350.0; 
const buttonHeight = 75.0; 
const verticalSpacing = 30.0; 

final numberOfButtons = modeButtons!.length; 

final fixedX = currentSize.x / 2;

final startY = currentSize.y * 0.35; 

double lastButtonCenterY = 0.0;

for (int i = 0; i < numberOfButtons; i++) {
final y = startY + i * (buttonHeight + verticalSpacing);

modeButtons![i]
..size = Vector2(buttonWidth, buttonHeight) 
..position = Vector2(fixedX, y);

lastButtonCenterY = y;
}

if (boardComponent != null) {
const boardOffsetFromButton = 80.0; 

boardComponent!
..size = Vector2(currentSize.x * 0.65, 120) 
..position = Vector2(
currentSize.x / 2, 
lastButtonCenterY + (boardComponent!.size.y / 2) + boardOffsetFromButton,
);
}
}
}

void _onModeSelected(String mode) {
switch (mode) {
case 'adventure':
navigateToScreen(const SungkaAdventureScreen());
break;
case 'friends':
navigateToScreen(const AvatarSelectionScreen());
break;
case 'bot':
navigateToScreen(
SelectionMode( 
navigateToScreen: navigateToScreen,
showError: showError,
),
);
break;
}
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
navigateToScreen(
OnlineGameScreen(
matchId: match.id,
navigateToScreen: navigateToScreen,
showError: showError,
),
);
} else {
final newMatch = await firestoreService.newMatch(
userId: user.uid,
userName: userName,
userRating: userRating,
);
navigateToScreen(
WaitingForOpponentScreen(
matchId: newMatch.id,
),
);
}
}catch (e) {
showError(e.toString());
}
}
}