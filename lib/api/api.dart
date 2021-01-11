import 'package:queued/api/party_room.dart';
import 'package:queued/api/queue.dart';
import 'package:queued/api/votes.dart';

class API {
  static final partyRoom = PartyRoomAPI();
  static final queue = QueueAPI();
  static final votes = VotesAPI();
}
