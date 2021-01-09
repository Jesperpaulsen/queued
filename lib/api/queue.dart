import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queued/models/queue_request.dart';

class QueueAPI {
  Stream<List<QueueRequest>> mountQueue(String partyID, bool playingPlaylist) {
    return FirebaseFirestore.instance
        .collection('partyrooms')
        .doc(partyID)
        .collection('queue')
        .where("played", isEqualTo: false)
        .orderBy('upVotes', descending: true)
        .orderBy('requested')
        .snapshots()
        .map((snapshot) {
      if (playingPlaylist)
        return snapshot.docs.map((doc) {
          return QueueRequest.fromJson(doc.data());
        }).toList();
      else {
        return snapshot.docs.skip(1).map((doc) {
          return QueueRequest.fromJson(doc.data());
        }).toList();
      }
    });
  }
}
