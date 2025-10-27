// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:sungka/core/services/firebase_auth_service.dart';
// import 'package:sungka/core/services/firebase_firestore_service.dart';
// import 'package:sungka/screens/online/online_game_screen.dart';
// import 'package:sungka/screens/online/waiting_for_opponent_screen.dart';

// class BattleModeScreen extends StatefulWidget {
//   const BattleModeScreen({super.key});

//   @override
//   State<BattleModeScreen> createState() => _BattleModeScreenState();
// }

// class _BattleModeScreenState extends State<BattleModeScreen> {
//   final firestoreService = FirebaseFirestoreService();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Center(
//         child: Column(
//           children: [
//             Text("Choose Your Battle Mode"),
//             ElevatedButton(onPressed: online, child: Text("Player VS Player")),
//             ElevatedButton(
//               onPressed: () {
//                 FirebaseAuthService().logout();
//               },
//               child: Text("Logout"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

 
// }
