import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

class SpotifyButton extends ConsumerWidget {
  final Function connectToSpotify;
  SpotifyButton(this.connectToSpotify);

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
        onPressed: connectToSpotify,
        child: Text(
          "Connect to spotify",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
