import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      'board': [4, 4, 4, 4, 4, 4, 4, 0, 4, 4, 4, 4, 4, 4, 4, 0],
      'turnId': userId,
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
      'isGameOver': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<DocumentSnapshot> getMatch({required String matchId}) {
    return firestore.collection('matches').doc(matchId).snapshots();
  }

  Future<void> updateBoardAndTurn({
    required String matchId,
    required List<int> newBoard,
    required String nextTurnId,
  }) async {
    await firestore.collection('matches').doc(matchId).update({
      'board': newBoard,
      'turnId': nextTurnId,
    });
  }

  Future<void> cancelMatch({required String matchId}) async {
    await firestore.collection('matches').doc(matchId).delete();
  }

  Future<void> updateMatchResult({
    required String matchId,
    required dynamic winnerId,
    String? loserId,
    int? winnerNewRating,
    int? loserNewRating,
    int? player1Score,
    int? player2Score,
    List<int>? board,
    bool? isGameOver,
  }) async {
    final data = <String, dynamic>{
      if (winnerId != null) 'winner': winnerId,
      if (loserId != null) 'loser': loserId,
      if (winnerNewRating != null) 'winnerNewRating': winnerNewRating,
      if (loserNewRating != null) 'loserNewRating': loserNewRating,
      if (player1Score != null) 'player1Score': player1Score,
      if (player2Score != null) 'player2Score': player2Score,
      if (board != null) 'board': board,
      if (isGameOver != null) 'isGameOver': isGameOver,
    };

    await firestore.collection('matches').doc(matchId).update(data);
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

  Future<void> declineRematch({required String rematchId}) async {
    await firestore.collection('matches').doc(rematchId).update({
      'status': 'declined',
    });
  }

  Future<void> cancelRematch({required String rematchId}) async {
    await firestore.collection('matches').doc(rematchId).update({
      'status': 'canceled',
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

  Future<void> updateBoardState({
    required String matchId,
    required List<int> board,
    required String nextTurnId,
    required bool isGameOver,
  }) async {
    await FirebaseFirestore.instance.collection('matches').doc(matchId).update({
      'board': board,
      'turnId': nextTurnId,
      'isGameOver': isGameOver,
    });
  }

  Future<Map<String, dynamic>> getRankings(String userId) async {
    final top100PlayersSnapshot =
        await firestore
            .collection('users')
            .orderBy('rating', descending: true)
            .orderBy('name')
            .limit(100)
            .get();

    final top100Players =
        top100PlayersSnapshot.docs.map((player) {
          return {
            'id': player.id,
            'name': player['name'] ?? 'Unknown',
            'rating': player['rating'] ?? 0,
          };
        }).toList();

    final userDoc = await firestore.collection('users').doc(userId).get();
    if (!userDoc.exists) {
      return {'top100Players': top100Players, 'playerRank': -1};
    }

    final int userRating = userDoc['rating'] ?? 0;
    final String playerName = userDoc['name'] ?? 'Unknown Player';
    final int playerRating = userDoc['rating'] ?? 0;

    final higherRated =
        await firestore
            .collection('users')
            .where('rating', isGreaterThan: userRating)
            .count()
            .get();

    final sameRatingSnapshot =
        await firestore
            .collection('users')
            .where('rating', isEqualTo: userRating)
            .orderBy(FieldPath.documentId)
            .get();

    int positionInTieGroup = sameRatingSnapshot.docs.indexWhere(
      (doc) => doc.id == userId,
    );

    if (positionInTieGroup == -1) {
      positionInTieGroup = 0;
    }

    int playerRank = higherRated.count! + positionInTieGroup + 1;

    return {
      'top100Players': top100Players,
      'playerRank': playerRank,
      'playerName': playerName,
      'playerRating': playerRating,
    };
  }

  Future<DocumentSnapshot> getMatchOnce({required String matchId}) {
    return firestore.collection('matches').doc(matchId).get();
  }
}
