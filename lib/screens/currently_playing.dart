import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:queued/models/queue_request.dart';
import 'package:queued/providers/party_room_provider.dart';
import 'package:queued/providers/queue_provider.dart';
import 'package:queued/widgets/currently_playing/playing_from_queue.dart';
import 'package:queued/widgets/shared/background_rect.dart';

class CurrentlyPlaying extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final queueStream = watch(QueueProvider.provider.stream);
    final partyRoomState = watch(PartyRoomProvider.provider.state);
    return BackgroundRect(
        child: StreamBuilder(
      stream: queueStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<QueueRequest>> snapshot) {
        if (snapshot.hasData &&
            snapshot.data.isNotEmpty &&
            !partyRoomState.partyRoom.playingPlaylist) {
          return PlayingFromQueue(snapshot.data.first);
        } else
          return notPlayingFromQueue();
      },
    ));
  }
}

Widget notPlayingFromQueue() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        "Playing from the hosts queue.",
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      SizedBox(
        height: 15,
      ),
      Text("Add a song to the queue if you dislike the music.")
    ],
  );
}
