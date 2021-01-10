import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:queued/models/party_room.dart';
import 'package:queued/providers/party_room_provider.dart';
import 'package:queued/providers/user_provider.dart';
import 'package:queued/router/route_generator.dart';
import 'package:queued/screens/logged_out/enter_display_name.dart';
import 'package:queued/screens/logged_out/enter_room_details.dart';

enum Mode {
  CREATE,
  JOIN,
}

class Join extends StatefulWidget {
  @override
  _JoinState createState() => _JoinState();
}

class _JoinState extends State<Join> {
  final _textController = new TextEditingController();
  final _nameController = new TextEditingController();
  Mode _mode = Mode.JOIN;
  PartyRoom _partyRoom;

  _createParty(BuildContext context) async {
    final partyName = _textController.text;
    if (partyName.isEmpty) return;
    await context.read(PartyRoomProvider.provider).createPartyRoom(partyName);
    setState(() {
      _partyRoom = context.read(PartyRoomProvider.provider.state).partyRoom;
    });
  }

  _joinParty(BuildContext context) async {
    final partyID = _textController.text;
    if (partyID.isEmpty) return;
    await context.read(PartyRoomProvider.provider).mountPartyRoom(partyID);
    setState(() {
      _partyRoom = context.read(PartyRoomProvider.provider.state).partyRoom;
    });
  }

  _enterDisplayName(BuildContext context) async {
    final displayName = _nameController.text;
    if (displayName.isEmpty) return;
    await context.read(UserProvider.provider).updateDisplayName(displayName);
    Navigator.of(context).pushNamed(PartyRoute.path);
  }

  void _changeMode() {
    setState(() {
      _mode = _mode == Mode.JOIN ? Mode.CREATE : Mode.JOIN;
    });
  }

  void _cancelJoin() {
    setState(() {
      _partyRoom = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    _textController.text = "892697"; // TODO: Remove this ;)
    return _partyRoom == null
        ? EnterRoomDetails(
            textController: _textController,
            changeMode: _changeMode,
            createParty: _createParty,
            joinParty: _joinParty,
            mode: _mode,
          )
        : EnterDisplayName(
            textController: _nameController,
            partyRoom: _partyRoom,
            enterDisplayName: _enterDisplayName,
            cancelJoin: _cancelJoin,
          );
  }
}
