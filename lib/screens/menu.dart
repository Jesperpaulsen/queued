import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:queued/configs/colors.dart';
import 'package:queued/providers/party_room_provider.dart';
import 'package:queued/widgets/menu/menu_bottom.dart';

class Menu extends ConsumerWidget {
  final Function(bool showMenu) showMenu;
  Menu(this.showMenu);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final partyRoomState = watch(PartyRoomProvider.provider.state);

    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => showMenu(false),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    partyRoomState.partyRoom.name,
                    style: TextStyle(fontSize: 25),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("# ${partyRoomState.partyRoom.partyID}"),
                  ),
                  Text("Your name is Jesper"),
                ],
              ),
            ),
            flex: 3,
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              color: AppColors.secondary,
              child: MenuBottom(),
            ),
            flex: 7,
          )
        ],
      ),
    );
  }
}
