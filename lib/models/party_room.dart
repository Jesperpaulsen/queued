import 'dart:math';

import 'package:flutter/foundation.dart';

int generatePartyID() {
  var rng = new Random();
  return rng.nextInt(900000) + 100000;
}

class PartyRoom {
  int created;
  String fallback;
  String host;
  String name;
  String partyID;
  bool playingPlaylist;
  int votesForNext;

  PartyRoom({
    @required this.created,
    @required this.fallback,
    @required this.name,
    @required this.host,
    @required this.playingPlaylist,
    @required this.votesForNext,
  }) {
    partyID = generatePartyID().toString();
  }

  PartyRoom.fromJSON(Map json) {
    this.created = json["created"] ?? 0;
    this.fallback = json["fallback"] ?? '';
    this.host = json["host"] ?? '';
    this.name = json["name"] ?? '';
    this.partyID = json["partyID"] ?? '';
    this.playingPlaylist = json["playingPlaylist"] ?? false;
    this.votesForNext = json["votesForNext"] ?? 0;
  }

  Map<String, dynamic> toJSON() {
    return {
      "created": created,
      "fallback": fallback,
      "host": host,
      "name": name,
      "partyID": partyID,
      "playingPlaylist": playingPlaylist,
      "votesForNext": votesForNext,
    };
  }
}
