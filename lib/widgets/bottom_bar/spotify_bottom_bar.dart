import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:queued/configs/colors.dart';
import 'package:queued/providers/spotify_provider.dart';
import 'package:queued/widgets/bottom_bar/spotify_song_detail.dart';
import 'package:queued/widgets/shared/spotify_button.dart';

class SpotifyBottomBar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final spotifyState = watch(SpotifyProvider.provider.state);
    final spotifyProvider = context.read(SpotifyProvider.provider);
    return Container(
      width: double.infinity,
      height: 70,
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.black54)],
        border: Border(
          top: BorderSide(color: AppColors.primary),
        ),
        color: AppColors.secondary.shade800,
      ),
      child: spotifyState.connected
          ? Row(
              children: [
                if (spotifyState.track != null)
                  Flexible(
                    flex: 3,
                    child: SpotifySongDetail(
                        spotifyState.track, spotifyState.isPaused),
                  ),
                Flexible(
                  child: IconButton(
                    color: AppColors.primary,
                    onPressed: spotifyProvider.togglePause,
                    icon: Icon(
                      spotifyState.isPaused ? Icons.play_arrow : Icons.pause,
                    ),
                  ),
                )
              ],
            )
          : Center(
              child: SpotifyButton(spotifyProvider.connect),
            ),
    );
  }
}
