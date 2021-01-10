import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:queued/configs/colors.dart';
import 'package:queued/models/party_room.dart';
import 'package:queued/providers/user_provider.dart';
import 'package:queued/widgets/shared/large_button.dart';

class EnterDisplayName extends ConsumerWidget {
  final PartyRoom partyRoom;
  final Function(BuildContext context) enterDisplayName;
  final Function cancelJoin;
  final TextEditingController textController;

  EnterDisplayName({
    @required this.partyRoom,
    @required this.enterDisplayName,
    @required this.textController,
    @required this.cancelJoin,
  });

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final userState = watch(UserProvider.provider.state);
    textController.text = userState.user.displayName;
    return Container(
      constraints: BoxConstraints(maxWidth: 270),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Align(
                alignment: Alignment.center,
                child: Text("You are about to join ${partyRoom.name}")),
          ),
          TextFormField(
            style: const TextStyle(
              color: Colors.white,
            ),
            controller: textController,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary),
              ),
              labelText: "Choose a nick name",
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
              label: "Join the party",
              minWidth: 400,
              onPressed: () => enterDisplayName(context),
              loading: false,
            ),
          ),
          Container(
              padding: const EdgeInsets.only(
                top: 10,
              ),
              child: FlatButton(
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: cancelJoin,
              )),
        ],
      ),
    );
  }
}
