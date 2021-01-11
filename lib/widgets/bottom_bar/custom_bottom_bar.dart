import 'package:flutter/material.dart';
import 'package:queued/configs/colors.dart';
import 'package:queued/screens/tab_screens.dart';
import 'package:queued/widgets/bottom_bar/spotify_bottom_bar.dart';

class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;
  CustomBottomBar({
    @required this.currentIndex,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 126,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SpotifyBottomBar(),
          BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: AppColors.primary,
              selectedItemColor: AppColors.secondary,
              unselectedItemColor: AppColors.white,
              currentIndex: currentIndex,
              onTap: onTap,
              items: tabScreens.map((e) => e.bottomNavigation()).toList()),
        ],
      ),
    );
  }
}
