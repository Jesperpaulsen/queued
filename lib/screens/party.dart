import 'package:flutter/material.dart';
import 'package:queued/configs/colors.dart';
import 'package:queued/screens/tab_screens.dart';
import 'package:queued/widgets/bottom_bar/custom_bottom_bar.dart';
import 'package:queued/widgets/shared/custom_app_bar.dart';

class Party extends StatefulWidget {
  @override
  _PartyState createState() => _PartyState();
}

class _PartyState extends State<Party> {
  var _currentIndex = 0;

  void updateCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(tabScreens[_currentIndex].topLabel),
      backgroundColor: AppColors.secondary,
      body: IndexedStack(
        index: _currentIndex,
        children: tabScreens.map((e) => e.screen).toList(),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentIndex,
        onTap: updateCurrentIndex,
      ),
    );
  }
}
