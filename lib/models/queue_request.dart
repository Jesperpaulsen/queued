import 'package:flutter/cupertino.dart';

class QueueRequest extends ChangeNotifier {
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
  var upVotedByUser = false;
  var votedToSkipByUser = false;

  QueueRequest({
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

  QueueRequest.fromJson(Map json)
      : this.addedBy = json["addedBy"] ?? "",
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

  Future<void> voteForSong() async {
    upVotedByUser = !upVotedByUser;
    notifyListeners();
    return new Future.delayed(
      Duration(milliseconds: 10),
    );
  }

  Future<void> voteToSkipSong() async {
    votedToSkipByUser = true;
    notifyListeners();
    return new Future.delayed(
      Duration(milliseconds: 10),
    );
  }
}
