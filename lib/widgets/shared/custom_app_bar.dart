import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:queued/models/party_room.dart';
import 'package:queued/providers/party_room_provider.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String _title;
  CustomAppBar(this._title);

  @override
  Size get preferredSize => Size.fromHeight(60);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _partyRoomState = watch(PartyRoomProvider.provider.state);
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          color: Theme.of(context).primaryColor,
        ),
        onPressed: () {},
      ),
      centerTitle: true,
      title: titleBuilder(_title, _partyRoomState.partyRoom),
      backgroundColor: Theme.of(context).accentColor,
      elevation: 0,
    );
  }
}

Widget titleBuilder(String title, PartyRoom partyRoom) {
  return Column(children: [
    Text("# ${partyRoom.partyID} - ${partyRoom.name}"),
    Text(
      title,
      style: TextStyle(fontSize: 17),
    )
  ]);
}
