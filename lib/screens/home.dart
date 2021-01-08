import 'package:flutter/material.dart';
import 'package:queued/configs/colors.dart';
import 'package:queued/screens/currently_playing.dart';
import 'package:queued/screens/queue.dart';
import 'package:queued/widgets/bottom_bar/custom_bottom_bar.dart';
import 'package:queued/widgets/shared/custom_app_bar.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _currentIndex = 0;

  void updateCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("Test"),
      backgroundColor: AppColors.secondary,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          CurrentlyPlaying(),
          Queue(),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentIndex,
        onTap: updateCurrentIndex,
      ),
    );
  }
}
