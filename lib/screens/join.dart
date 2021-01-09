import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:queued/configs/colors.dart';
import 'package:queued/providers/party_room_provider.dart';
import 'package:queued/router/route_generator.dart';

import '../widgets/shared/large_button.dart';

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
  Mode mode = Mode.JOIN;

  _createParty(BuildContext context) async {
    final partyName = _textController.text;
    if (partyName.isEmpty) return;
    context.read(PartyRoomProvider.provider).createPartyRoom(partyName);
    // Navigator.of(context).pushNamed('/');
  }

  _joinParty(BuildContext context) async {
    final partyID = _textController.text;
    if (partyID.isEmpty) return;
    await context.read(PartyRoomProvider.provider).mountPartyRoom(partyID);
    if (context.read(PartyRoomProvider.provider.state).partyRoom != null)
      Navigator.of(context, rootNavigator: true).pushNamed(PartyRoute.path);
  }

  void _changeMode() {
    setState(() {
      mode = mode == Mode.JOIN ? Mode.CREATE : Mode.JOIN;
    });
  }

  @override
  Widget build(BuildContext context) {
    _textController.text = "892697"; // TODO: Remove this ;)
    return Container(
      constraints: BoxConstraints(maxWidth: 270),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            child: Column(
              children: [
                TextFormField(
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  controller: _textController,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                    labelText: mode == Mode.JOIN
                        ? 'Enter code'
                        : 'Enter a name for your party',
                    labelStyle: const TextStyle(
                      color: Colors.white54,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    top: 10,
                  ),
                  width: double.infinity,
                  child: Consumer(
                    builder: (context, watch, child) {
                      return LargeButton(
                        height: 50,
                        color: AppColors.primary,
                        textColor: AppColors.white,
                        label: mode == Mode.JOIN ? 'Continue' : 'Create party',
                        minWidth: 400,
                        onPressed: () {
                          if (mode == Mode.JOIN)
                            _joinParty(context);
                          else
                            _createParty(context);
                        },
                        loading:
                            watch(PartyRoomProvider.provider.state).loading ??
                                false,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                mode == Mode.JOIN
                    ? const Text('Don\'t have a code?')
                    : const Text('All ready have a code?'),
                LargeButton(
                  height: 35,
                  minWidth: 250,
                  color: AppColors.white,
                  label: mode == Mode.JOIN ? 'Create a party' : 'Join a party',
                  onPressed: _changeMode,
                  loading: false,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
