import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sungka/screens/online/online_game_screen.dart';

class FirebaseFirestoreService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> saveUser(String id, String? name) async {
    await firestore.collection('users').doc(id).set({
      'name': name,
      'rating': 800,
      'wins': 0,
      'losses': 0,
      'draws': 0,
      'isOnline': true,
      'currentMatchId': null,
    });
  }

  Future<DocumentSnapshot> getUser({required User user}) {
    return firestore.collection('users').doc(user.uid).get();
  }

  Future<QuerySnapshot> findMatch({
    required int minRating,
    required int maxRating,
  }) async {
    return await firestore
        .collection('matches')
        .where('status', isEqualTo: 'waiting')
        .where('player1Rating', isGreaterThanOrEqualTo: minRating)
        .where('player1Rating', isLessThanOrEqualTo: maxRating)
        .limit(1)
        .get();
  }

  Future<void> joinMatch({
    required String matchId,
    required String userId,
    required String userName,
    required int rating,
  }) async {
    await firestore.collection('matches').doc(matchId).update({
      'player2Id': userId,
      'player2Name': userName,
      'player2Rating': rating,
      'status': 'playing',
    });
  }

  Future<DocumentReference> newMatch({
    required String userId,
    required String userName,
    required int userRating,
  }) async {
    return await firestore.collection('matches').add({
      'player1Id': userId,
      'player1Name': userName,
      'player1Rating': userRating,
      'player2Id': null,
      'player2Name': null,
      'player2Rating': null,
      'status': 'waiting',
      'winner': null,
      'loser': null,
      'player1Score': 0,
      'player2Score': 0,
      'winnerNewRating': null,
      'loserNewRating': null,
      'playerAskingRematch': null,
      'rematchOf': null,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<DocumentSnapshot> getMatch({required String matchId}) {
    return firestore.collection('matches').doc(matchId).snapshots();
  }

  Future<void> cancelMatch({required String matchId}) async {
    await firestore.collection('matches').doc(matchId).delete();
  }

  Future<void> updateMatchResult({
    required String matchId,
    required String winnerId,
    required String loserId,
    required int winnerNewRating,
    required int loserNewRating,
    required int player1Score,
    required int player2Score,
  }) async {
    await FirebaseFirestore.instance.collection('matches').doc(matchId).update({
      'winner': winnerId,
      'loser': loserId,
      'winnerNewRating': winnerNewRating,
      'loserNewRating': loserNewRating,
      'player1Score': player1Score,
      'player2Score': player2Score,
    });
  }

  Future<void> updateUserRating(
    String uid,
    int newRating, {
    bool winner = false,
  }) async {
    if (winner) {
      await firestore.collection('users').doc(uid).update({
        'rating': newRating,
        'wins': FieldValue.increment(1),
      });

      return;
    }

    await firestore.collection('users').doc(uid).update({
      'rating': newRating,
      'losses': FieldValue.increment(1),
    });
  }

  Future<void> askRematch({
    required String matchId,
    required String? uid,
  }) async {
    await FirebaseFirestore.instance.collection('matches').doc(matchId).update({
      'playerAskingRematch': uid,
    });
  }

  Future<QuerySnapshot> findRematch({required String previousMatchId}) async {
    return await FirebaseFirestore.instance
        .collection('matches')
        .where('rematchOf', isEqualTo: previousMatchId)
        .where('status', isEqualTo: 'rematch_pending')
        .limit(1)
        .get();
  }

  Future<void> acceptRematch({required String rematchId}) async {
    await firestore.collection('matches').doc(rematchId).update({
      'status': 'playing',
    });
  }

  Future<DocumentReference> rematch(
    String previousMatchId,
    int player1NewRating,
    int player2NewRating,
  ) async {
    final previousMatch =
        await firestore.collection('matches').doc(previousMatchId).get();
    final data = previousMatch.data()!;

    return firestore.collection('matches').add({
      'player1Id': data['player1Id'],
      'player1Name': data['player1Name'],
      'player1Rating': player1NewRating,
      'player2Id': data['player2Id'],
      'player2Name': data['player2Name'],
      'player2Rating': player2NewRating,
      'status': 'rematch_pending',
      'winner': null,
      'loser': null,
      'player1Score': data['player1Score'],
      'player2Score': data['player2Score'],
      'winnerNewRating': null,
      'loserNewRating': null,
      'playerAskingRematch': null,
      'rematchOf': previousMatchId,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
