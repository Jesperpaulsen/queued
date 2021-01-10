import 'package:flutter_riverpod/all.dart';
import 'package:queued/api/api.dart';
import 'package:queued/models/queue_request.dart';
import 'package:queued/providers/party_room_provider.dart';

class QueueProvider {
  static final provider = StreamProvider<List<QueueRequest>>((ref) {
    final partyRoomState = ref.watch(PartyRoomProvider.provider.state);
    if (partyRoomState.partyRoom == null)
      return Stream<List<QueueRequest>>.empty();
    return API.queue.mountQueue(partyRoomState.partyRoom.partyID);
  });
}
