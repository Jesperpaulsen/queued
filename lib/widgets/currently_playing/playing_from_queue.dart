import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:queued/configs/colors.dart';
import 'package:queued/models/queue_request.dart';
import 'package:queued/providers/skip_song_provider.dart';
import 'package:queued/widgets/shared/large_button.dart';

class PlayingFromQueue extends ConsumerWidget {
  final QueueRequest _queueRequest;

  PlayingFromQueue(this._queueRequest);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _queueRequestProvider = watch(_queueRequest.provider);
    final _skipSongState = watch(SkipSongProvider.provider.state);

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
              _queueRequest.imageUrl,
              fit: BoxFit.contain,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            _queueRequest.title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
        Text(
          _queueRequest.artist,
          style: ThemeData.light().textTheme.headline3,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Added by ${_queueRequest.displayName}"),
        ),
        LargeButton(
          color: AppColors.secondary,
          label: "Vote to skip",
          height: 50,
          minWidth: 200,
          textColor: AppColors.white,
          onPressed: _skipSongState.userHasVoted
              ? null
              : () => context.read(SkipSongProvider.provider).skipSong(),
          loading: false,
        )
      ],
    );
  }
}
