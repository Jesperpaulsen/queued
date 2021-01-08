import 'package:flutter/material.dart';

class TabScreen {
  final String topLabel;
  final String bottomLabel;
  final Icon icon;
  final Widget screen;

  TabScreen({
    @required this.topLabel,
    @required this.icon,
    @required this.screen,
    bottomLabel,
  }) : this.bottomLabel = bottomLabel ?? topLabel;

  BottomNavigationBarItem bottomNavigation() =>
      BottomNavigationBarItem(icon: this.icon, label: this.bottomLabel);
}
