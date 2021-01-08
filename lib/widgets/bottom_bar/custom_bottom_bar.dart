import 'package:flutter/material.dart';
import 'package:queued/configs/colors.dart';

class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;
  CustomBottomBar({@required this.currentIndex, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: AppColors.primary,
      selectedItemColor: AppColors.secondary,
      unselectedItemColor: AppColors.white,
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.play_arrow),
          label: "Currently playing",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.queue_music),
          label: "Queue",
        ),
      ],
    );
  }
}
