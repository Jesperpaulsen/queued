import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queued/models/vote.dart';

class VotesAPI {
  Stream<QuerySnapshot> mountVotes(String partyID, String userID) {
    return FirebaseFirestore.instance
        .collection('partyrooms')
        .doc(partyID)
        .collection('votes')
        .where("userID", isEqualTo: userID)
        .snapshots();
  }

  Future<Vote> upVoteSong(String partyID, Vote vote) async {
    final ref =
        FirebaseFirestore.instance.collection('partyrooms').doc(partyID);

    final res = await ref.collection('votes').add(vote.toJson());
    await ref
        .collection('queue')
        .doc(vote.requestID)
        .update({"upVotes": FieldValue.increment(1)});
    vote.voteID = res.id;
    return vote;
  }

  Future<void> removeVoteForSong(String partyID, Vote vote) async {
    final ref =
        FirebaseFirestore.instance.collection('partyrooms').doc(partyID);
    print(vote.voteID);
    await ref.collection('votes').doc(vote.voteID).delete();
    return ref
        .collection('queue')
        .doc(vote.requestID)
        .update({"upVotes": FieldValue.increment(-1)});
  }
}
