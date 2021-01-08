import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:queued/api/api.dart';
import 'package:queued/models/party_room.dart';
import 'package:queued/providers/auth_provider.dart';

class PartyRoomState {
  bool loading;
  PartyRoom partyRoom;

  PartyRoomState() {
    loading = false;
  }
}

class PartyRoomProvider extends StateNotifier<PartyRoomState> {
  final AsyncValue<User> authProvider;
  PartyRoomProvider(this.authProvider) : super(PartyRoomState());

  setLoading(bool loading) {
    var newState = state;
    newState.loading = loading;
    state = newState;
  }

  setPartyRoom(PartyRoom partyRoom) {
    var newState = state;
    newState.partyRoom = partyRoom;
    state = newState;
  }

  createPartyRoom(String partyName) async {
    setLoading(true);
    try {
      final partyRoom = new PartyRoom(
        created: new DateTime.now().millisecondsSinceEpoch,
        fallback: "",
        name: partyName,
        host: authProvider.data.value.uid,
        playingPlaylist: false,
        votesForNext: 1,
      );
      await API.partyRoom.setPartyRoom(partyRoom);
      await mountPartyRoom(partyRoom.partyID);
    } catch (error) {
      print(error);
    }
    setLoading(false);
  }

  mountPartyRoom(String partyID) {
    setLoading(true);
    try {
      API.partyRoom.mountPartyRoom(partyID, setPartyRoom);
    } catch (error) {
      print(error);
    }
    setLoading(false);
  }

  static final provider = StateNotifierProvider(
      (ref) => PartyRoomProvider(ref.watch(AuthProvider.user)));
}
