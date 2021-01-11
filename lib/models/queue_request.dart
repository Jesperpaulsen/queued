import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:queued/api/api.dart';
import 'package:queued/models/vote.dart';

class QueueRequest extends ChangeNotifier {
  final String requestID;
  final String addedBy;
  final String artist;
  final String displayName;
  final String imageUrl;
  final bool played;
  final int requested;
  final String spotifyID;
  final String spotifyUri;
  final String title;
  final int upVotes;
  Vote usersUpVote;

  QueueRequest({
    this.requestID,
    this.addedBy,
    this.artist,
    this.displayName,
    this.imageUrl,
    this.played,
    this.requested,
    this.spotifyID,
    this.spotifyUri,
    this.title,
    this.upVotes,
  });

  QueueRequest.fromJson(String requestID, Map json)
      : this.requestID = requestID,
        this.addedBy = json["addedBy"] ?? "",
        this.artist = json["artist"] ?? "",
        this.displayName = json["displayName"] ?? "",
        this.imageUrl = json["imageUrl"] ?? "",
        this.played = json["played"] ?? false,
        this.requested =
            json["request"] ?? DateTime.now().millisecondsSinceEpoch,
        this.spotifyID = json["spotifyID"] ?? "",
        this.spotifyUri = json["spotifyUri"] ?? "",
        this.title = json["title"] ?? "",
        this.upVotes = json["upVotes"] ?? 0;

  Future<void> voteForSong(String partyID, String userID) async {
    try {
      if (usersUpVote == null) {
        usersUpVote = new Vote(userID: userID, requestID: requestID);
        notifyListeners();
        usersUpVote = await API.votes.upVoteSong(partyID, usersUpVote);
        print(usersUpVote.voteID);
      } else {
        print(usersUpVote.voteID);
        final tmpVote = usersUpVote;
        usersUpVote = null;
        notifyListeners();
        await API.votes.removeVoteForSong(partyID, tmpVote);
      }
    } catch (e) {
      print(e);
    }
  }

  get upVotedByUser => usersUpVote != null;

  get provider => ChangeNotifierProvider((_) => this);
}
