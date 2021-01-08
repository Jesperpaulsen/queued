import 'package:flutter/material.dart';
import 'package:queued/widgets/shared/background_rect.dart';

class CurrentlyPlaying extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: BackgroundRect(
        child: Center(child: Text("yo")),
      ),
    );
  }
}
