import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

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
}
