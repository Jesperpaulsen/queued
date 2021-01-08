import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queued/models/party_room.dart';

class PartyRoomAPI {
  Future<void> setPartyRoom(PartyRoom partyRoom) async {
    await FirebaseFirestore.instance
        .collection('partyrooms')
        .doc(partyRoom.partyID)
        .set(partyRoom.toJSON());
  }

  StreamSubscription<DocumentSnapshot> mountPartyRoom(
      String partyID, Function(PartyRoom partyRoom) callback) {
    return FirebaseFirestore.instance
        .collection('partyrooms')
        .doc(partyID)
        .snapshots()
        .listen((doc) {
      if (doc.exists) return callback(PartyRoom.fromJSON(doc.data()));
    });
  }
}
