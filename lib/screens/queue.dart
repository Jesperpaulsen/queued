import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:queued/models/queue_request.dart';
import 'package:queued/providers/party_room_provider.dart';
import 'package:queued/providers/queue_provider.dart';
import 'package:queued/screens/currently_playing.dart';
import 'package:queued/widgets/queue/QueueRequestVM.dart';
import 'package:queued/widgets/shared/background_rect.dart';

EdgeInsets _getPadding(int index, int totalLength) {
  if (index == 0) return EdgeInsets.only(top: 70);
  if (index == totalLength - 1) return EdgeInsets.only(bottom: 60);
  return EdgeInsets.all(0);
}

class Queue extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final queueStream = watch(QueueProvider.provider.stream);
    final partyRoomState = watch(PartyRoomProvider.provider.state);
    return BackgroundRect(
      child: StreamBuilder(
        stream: queueStream,
        builder:
            (BuildContext context, AsyncSnapshot<List<QueueRequest>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError)
            return Center(
              child: Text("Something went wrong when loading the queue :("),
            );
          else if (snapshot.data.isEmpty ||
              (snapshot.hasData &&
                  snapshot.data.length == 1 &&
                  !partyRoomState.partyRoom.playingPlaylist)) {
            return notPlayingFromQueue();
          } else
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return (!partyRoomState.partyRoom.playingPlaylist && index == 0)
                    ? SizedBox(
                        height: 70,
                      )
                    : QueueRequestVM(
                        padding: _getPadding(index, snapshot.data.length),
                        queueRequest: snapshot.data[index],
                      );
              },
              itemCount: snapshot.data.length,
            );
        },
      ),
    );
  }
}
