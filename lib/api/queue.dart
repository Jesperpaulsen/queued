import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queued/models/queue_request.dart';

class QueueAPI {
  Stream<QuerySnapshot> mountQueue(String partyID) {
    return FirebaseFirestore.instance
        .collection('partyrooms')
        .doc(partyID)
        .collection('queue')
        .where("played", isEqualTo: false)
        .orderBy('upVotes', descending: true)
        .orderBy('requested')
        .snapshots();
  }

  Future<void> upVoteNextSong(String partyID, QueueRequest queueRequest) async {
    return FirebaseFirestore.instance
        .collection('partyrooms')
        .doc(partyID)
        .collection('queue')
        .doc(queueRequest.requestID)
        .update({"upVotes": 99999});
  }

  Future<void> markSongAsPlayed(
      String partyID, QueueRequest queueRequest) async {
    return FirebaseFirestore.instance
        .collection('partyrooms')
        .doc(partyID)
        .collection('queue')
        .doc(queueRequest.requestID)
        .update({"played": true});
  }
}
