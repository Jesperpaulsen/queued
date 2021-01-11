import 'package:flutter/material.dart';
import 'package:queued/services/spotify.dart';

class Library extends StatefulWidget {
  @override
  _LibraryState createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  var loading = false;
  var connected = false;

  connectToSpotify() async {
    try {
      var result = await Spotify().connect("Test");
      setState(() {
        connected = result;
      });
    } catch (e) {
      print("Hallo");
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(connected ? "Koblet til" : "Ikke koblet til"),
          Center(
            child: FlatButton(
              child: Text("Connect"),
              onPressed: connectToSpotify,
            ),
          ),
        ],
      ),
    );
  }
}
