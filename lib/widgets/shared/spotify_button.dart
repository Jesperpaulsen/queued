import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:queued/services/spotify.dart';

class SpotifyButton extends ConsumerWidget {
  SpotifyButton();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return ButtonTheme(
      height: 50,
      child: RaisedButton(
        elevation: 30,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        color: Colors.green,
        onPressed: Spotify.instance.connect,
        child: Text(
          "Connect to spotify",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
