import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:queued/providers/party_room_provider.dart';
import 'package:queued/router/route_generator.dart';

class MenuItem {
  final String label;
  final Function() action;
  MenuItem(this.label, this.action);
}

class MenuBottom extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final List<MenuItem> menuItems = [
      MenuItem("Share", () => print("Share")),
      MenuItem("Settings", () => print("Settings")),
      MenuItem("Leave party", () {
        Navigator.of(context).pushNamed(LoggedOutRoute.path);
        context.read(PartyRoomProvider.provider).clearPartyRoom();
      })
    ];
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: menuItems.map((menuItem) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: GestureDetector(
              child: Text(
                menuItem.label,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              onTap: menuItem.action,
            ),
          );
        }).toList(),
      ),
    );
  }
}
