import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sungka/core/services/firebase_firestore_service.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final FirebaseFirestoreService firestoreService = FirebaseFirestoreService();

  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Leaderboard")),
      body: FutureBuilder(
        future: firestoreService.getRankings(currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No data available.'));
          }

          final data = snapshot.data!;
          final top100Players = data['top100Players'] as List;
          final playerRank = data['playerRank'];
          final playerName = data['playerName'];
          final playerRating = data['playerRating'];

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: top100Players.length,
                  itemBuilder: (context, index) {
                    final player = top100Players[index];
                    final rank = index + 1;

                    return ListTile(
                      leading: CircleAvatar(child: Text('#$rank')),
                      title: Text(player['name'] ?? 'Unknown Player'),
                      trailing: Text('Rating: ${player['rating']}'),
                    );
                  },
                ),
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: Text('#$playerRank'),
                ),
                title: Text(playerName ?? 'You'),
                subtitle: Text('Rating: $playerRating'),
              ),
            ],
          );
        },
      ),
    );
  }
}
