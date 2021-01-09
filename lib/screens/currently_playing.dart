import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:queued/configs/colors.dart';
import 'package:queued/models/queue_request.dart';
import 'package:queued/providers/party_room_provider.dart';
import 'package:queued/providers/queue_provider.dart';
import 'package:queued/widgets/shared/background_rect.dart';
import 'package:queued/widgets/shared/large_button.dart';

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
          if (snapshot.hasData && !partyRoomState.partyRoom.playingPlaylist)
            return playingFromQueue(snapshot.data.first, watch);
          else
            return notPlayingFromQueue();
        },
      ),
    );
  }
}

Widget playingFromQueue(QueueRequest queueRequest, ScopedReader watch) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(6),
        ),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black54,
                spreadRadius: 1,
                blurRadius: 2,
                offset: Offset(0, 1),
              )
            ],
          ),
          height: 200,
          width: 200,
          child: Image.network(
            queueRequest.imageUrl,
            fit: BoxFit.contain,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          queueRequest.title,
          style: TextStyle(fontSize: 18),
        ),
      ),
      Text(
        queueRequest.artist,
        style: ThemeData.light().textTheme.headline3,
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("Added by ${queueRequest.displayName}"),
      ),
      LargeButton(
        color: AppColors.secondary,
        label: "Vote to skip",
        height: 50,
        minWidth: 200,
        textColor: AppColors.white,
        onPressed:
            queueRequest.votedToSkipByUser ? null : queueRequest.voteToSkipSong,
        loading: false,
      )
    ],
  );
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
