import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

class SpotifyButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return RaisedButton(
      onPressed: () {},
      child: Text("Connect to spotify"),
    );
  }
}
