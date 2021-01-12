import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:queued/providers/spotify_provider.dart';
import 'package:queued/services/spotify.dart';

class Library extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final spotifyState = watch(SpotifyProvider.provider.state);

    return Container(
      child: Column(
        children: [
          Text(spotifyState.connected ? "Koblet til" : "Ikke koblet til"),
          Center(
            child: FlatButton(
              child: Text("Connect"),
              onPressed: () => Spotify.instance.connect(),
            ),
          ),
        ],
      ),
    );
  }
}
