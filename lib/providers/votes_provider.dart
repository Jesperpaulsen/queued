import 'package:flutter_riverpod/all.dart';
import 'package:queued/models/vote.dart';
import 'package:queued/providers/party_room_provider.dart';

class VotesProvider {
  static final provider = StreamProvider<List<Vote>>((ref) {
    final partyRoomState = ref.watch(PartyRoomProvider.provider.state);
    if (partyRoomState.partyRoom == null) return Stream<List<Vote>>.empty();
    return API
  })
}