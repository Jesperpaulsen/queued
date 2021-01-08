import 'package:flutter/material.dart';
import 'package:queued/constants/queued_icons.dart';
import 'package:queued/screens/currently_playing.dart';
import 'package:queued/screens/library.dart';
import 'package:queued/screens/queue.dart';
import 'package:queued/screens/search.dart';
import 'package:queued/screens/tab_screen.dart';

final tabScreens = [
  TabScreen(
      topLabel: "Currently Playing",
      bottomLabel: "Playing",
      icon: Icon(Queued.music_player_fill),
      screen: CurrentlyPlaying()),
  TabScreen(
    topLabel: "Queue",
    icon: Icon(Icons.queue_music),
    screen: Queue(),
  ),
  TabScreen(
    topLabel: "Search",
    icon: Icon(Icons.search),
    screen: Search(),
  ),
  TabScreen(
      topLabel: "Library",
      icon: Icon(Queued.person_lines_fill),
      screen: Library()),
];
