import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:queued/configs/colors.dart';
import 'package:queued/providers/party_room_provider.dart';
import 'package:queued/widgets/shared/large_button.dart';

import 'join.dart';

class EnterRoomDetails extends ConsumerWidget {
  final TextEditingController textController;
  final Mode mode;
  final Function(BuildContext context) createParty;
  final Function(BuildContext context) joinParty;
  final Function() changeMode;

  EnterRoomDetails({
    @required this.textController,
    @required this.mode,
    @required this.createParty,
    @required this.joinParty,
    @required this.changeMode,
  });

  @override
  Widget build(BuildContext context, ScopedReader watch) {
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
                  controller: textController,
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
                    child: LargeButton(
                      height: 50,
                      color: AppColors.primary,
                      textColor: AppColors.white,
                      label: mode == Mode.JOIN ? 'Continue' : 'Create party',
                      minWidth: 400,
                      onPressed: () {
                        if (mode == Mode.JOIN)
                          joinParty(context);
                        else
                          createParty(context);
                      },
                      loading:
                          watch(PartyRoomProvider.provider.state).loading ??
                              false,
                    )),
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
                  onPressed: changeMode,
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
