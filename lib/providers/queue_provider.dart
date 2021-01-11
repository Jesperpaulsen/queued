import 'package:flutter_riverpod/all.dart';
import 'package:queued/api/api.dart';
import 'package:queued/models/queue_request.dart';
import 'package:queued/models/vote.dart';
import 'package:queued/providers/party_room_provider.dart';
import 'package:queued/providers/up_votes_provider.dart';
import 'package:stream_transform/stream_transform.dart';

class QueueProvider {
  static final provider = StreamProvider<List<QueueRequest>>((ref) {
    final partyRoomState = ref.watch(PartyRoomProvider.provider.state);
    if (partyRoomState.partyRoom == null)
      return Stream<List<QueueRequest>>.empty();
    final queue = API.queue.mountQueue(partyRoomState.partyRoom.partyID);
    final votesStream = ref.watch(UpVotesProvider.provider.stream);
    return queue.combineLatest(votesStream, (queueRequests, upVotes) {
      final List<Vote> votes = [];
      for (final doc in upVotes.docs) {
        try {
          final vote = Vote.fromJson(doc.id, doc.data());
          print(vote.voteID);
          if (vote.voteID != null) votes.add(vote);
        } catch (e) {
          print(e);
        }
      }

      final List<QueueRequest> requests = [];
      for (final doc in queueRequests.docs) {
        try {
          final request = QueueRequest.fromJson(doc.id, doc.data());
          request.usersUpVote = votes.firstWhere(
              (vote) => vote.requestID == request.requestID,
              orElse: () => null);
          requests.add(request);
        } catch (e) {
          print(e);
        }
      }
      return requests;
    });
  });
}
