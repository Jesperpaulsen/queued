import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:queued/api/api.dart';
import 'package:queued/providers/party_room_provider.dart';
import 'package:queued/providers/user_provider.dart';

class UpVotesProvider {
  static final provider = StreamProvider<QuerySnapshot>((ref) {
    final partyRoomState = ref.watch(PartyRoomProvider.provider.state);
    final userState = ref.watch(UserProvider.provider.state);
    if (partyRoomState.partyRoom == null || userState.user == null)
      return Stream<QuerySnapshot>.empty();
    return API.votes
        .mountVotes(partyRoomState.partyRoom.partyID, userState.user.uid);
  });
}
