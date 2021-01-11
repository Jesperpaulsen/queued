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

  Stream<PartyRoom> mountPartyRoom(String partyID) {
    try {
      return FirebaseFirestore.instance
          .collection('partyrooms')
          .doc(partyID)
          .snapshots()
          .map((snapshot) {
        if (snapshot.exists)
          return PartyRoom.fromJSON(snapshot.data());
        else
          throw new Error();
      });
    } catch (error) {
      return Stream<PartyRoom>.empty();
    }
  }

  Future<void> setPlayingPlaylist(String partyID, bool playingPlaylist) {
    return FirebaseFirestore.instance
        .collection('partyrooms')
        .doc(partyID)
        .update({"playingPlaylist": playingPlaylist});
  }
}
