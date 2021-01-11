import 'package:flutter/material.dart';
import 'package:queued/widgets/queue/QueueRequestVM.dart';
import 'package:spotify_sdk/models/image_uri.dart';
import 'package:spotify_sdk/models/track.dart';

class SpotifySongDetail extends StatelessWidget {
  final Track track;
  final bool isPaused;

  SpotifySongDetail(this.track, this.isPaused);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: Image.network(
              getImageUrl(track.imageUri),
              fit: BoxFit.contain,
            ),
          ),
          Flexible(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.only(left: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ellipsisText(text: track.name, size: 15),
                  ellipsisText(
                    text: track.artist.name,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String getImageUrl(ImageUri imageUri) {
  final splittedUri = imageUri.raw.split(":");
  return "https://i.scdn.co/image/${splittedUri.last}";
}
