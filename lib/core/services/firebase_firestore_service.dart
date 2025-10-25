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
      'isDraw': false,
      'player1Id': userId,
      'player1Name': userName,
      'player1Rating': userRating,
      'player2Id': null,
      'player2Rating': null,
      'status': 'waiting',
      'winner': null,
      'loser': null,
      'player1Score': 0,
      'player2Score': 0,
      'winnerNewRating': null,
      'loserNewRating': null,
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
}
