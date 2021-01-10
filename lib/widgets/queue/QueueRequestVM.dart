import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:queued/configs/colors.dart';
import 'package:queued/models/queue_request.dart';

class QueueRequestVM extends ConsumerWidget {
  final QueueRequest queueRequest;
  final EdgeInsets padding;

  QueueRequestVM({@required this.padding, @required this.queueRequest});

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _queueRequestProvider = watch<QueueRequest>(queueRequest.provider);
    return Padding(
      padding: padding,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 1,
                  child: Image.network(
                    queueRequest.imageUrl,
                    fit: BoxFit.contain,
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: Column(
                    children: [
                      ellipsisText(text: queueRequest.title, size: 15),
                      ellipsisText(
                        text: queueRequest.artist,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ellipsisText(
                          text: "Added by ${queueRequest.displayName}",
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: IconButton(
                    icon: Icon(
                      Icons.thumb_up,
                      color: _queueRequestProvider.upVotedByUser
                          ? AppColors.secondary
                          : Colors.white,
                    ),
                    onPressed: _queueRequestProvider.voteForSong,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Divider(
              height: 3,
              thickness: 1.2,
              color: AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }
}

Widget ellipsisText(
        {String text, Color color = Colors.white, double size = 14}) =>
    Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.left,
        style: TextStyle(
          color: color,
          fontSize: size,
        ),
      ),
    );
