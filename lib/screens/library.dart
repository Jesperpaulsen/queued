import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:queued/providers/spotify_provider.dart';

class Library extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final spotifyState = watch(SpotifyProvider.provider.state);
    final spotifyProvider = context.read(SpotifyProvider.provider);

    return Container(
      child: Column(
        children: [
          Text(spotifyState.connected ? "Koblet til" : "Ikke koblet til"),
          Center(
            child: FlatButton(
              child: Text("Connect"),
              onPressed: () => spotifyProvider.connect(),
            ),
          ),
        ],
      ),
    );
  }
}
