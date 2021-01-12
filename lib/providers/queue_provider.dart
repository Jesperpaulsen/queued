import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:queued/api/api.dart';
import 'package:queued/models/queue_request.dart';
import 'package:queued/models/vote.dart';
import 'package:queued/providers/party_room_provider.dart';
import 'package:queued/providers/up_votes_provider.dart';
import 'package:queued/services/spotify.dart';
import 'package:stream_transform/stream_transform.dart';

class QueueProvider {
  static final provider = StreamProvider<List<QueueRequest>>((ref) {
    final partyRoomState = ref.watch(PartyRoomProvider.provider.state);

    if (partyRoomState.partyRoom == null)
      return Stream<List<QueueRequest>>.empty();

    final queue = API.queue.mountQueue(partyRoomState.partyRoom.partyID);
    final votesStream = ref.watch(UpVotesProvider.provider.stream);

    return queue.combineLatest(votesStream, (queueRequests, upVotes) {
      final votes = getVotes(upVotes.docs);
      final requests = getRequests(queueRequests.docs, votes);

      Spotify.instance.subscribeToQueueStream(requests);

      return requests;
    });
  });
}

List<Vote> getVotes(List<QueryDocumentSnapshot> docs) {
  final List<Vote> votes = [];
  for (final doc in docs) {
    try {
      final vote = Vote.fromJson(doc.id, doc.data());
      print(vote.voteID);
      if (vote.voteID != null) votes.add(vote);
    } catch (e) {
      print(e);
    }
  }
  return votes;
}

List<QueueRequest> getRequests(
    List<QueryDocumentSnapshot> docs, List<Vote> votes) {
  final List<QueueRequest> requests = [];
  for (final doc in docs) {
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
}
