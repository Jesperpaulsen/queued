import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queued/models/queue_request.dart';

class QueueAPI {
  Stream<List<QueueRequest>> mountQueue(String partyID) {
    return FirebaseFirestore.instance
        .collection('partyrooms')
        .doc(partyID)
        .collection('queue')
        .where("played", isEqualTo: false)
        .orderBy('upVotes', descending: true)
        .orderBy('requested')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              print("mounted");
              return QueueRequest.fromJson(doc.data());
            }).toList());
  }
}
