import 'dart:async';

import 'package:flutter_riverpod/all.dart';
import 'package:queued/api/api.dart';
import 'package:queued/models/party_room.dart';
import 'package:queued/providers/user_provider.dart';
import 'package:queued/services/spotify.dart';

class PartyRoomState {
  bool loading;
  PartyRoom partyRoom;

  PartyRoomState() {
    loading = false;
  }
}

class PartyRoomProvider extends StateNotifier<PartyRoomState> {
  final UserProvider userProvider;
  StreamSubscription<PartyRoom> _subscription;
  PartyRoomProvider(this.userProvider) : super(PartyRoomState());

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
        host: userProvider.state.user.uid,
        playingPlaylist: false,
        votesForNext: 1,
      );
      await API.partyRoom.setPartyRoom(partyRoom);
      await mountPartyRoom(partyRoom.partyID);
    } catch (error) {
      print(error);
    }
  }

  mountPartyRoom(String partyID) async {
    setLoading(true);
    Spotify.instance.partyID = partyID;
    try {
      final partyRoomStream = API.partyRoom.mountPartyRoom(partyID);
      _subscription = partyRoomStream.listen((partyRoom) {
        setPartyRoom(partyRoom);
      });
      await for (PartyRoom partyRoom in partyRoomStream)
        return partyRoom ?? false;
    } catch (error) {
      print(error);
    } finally {
      setLoading(false);
    }
  }

  clearPartyRoom() {
    _subscription.cancel();
    setPartyRoom(null);
  }

  static final provider = StateNotifierProvider<PartyRoomProvider>((ref) {
    final userProvider = ref.watch(UserProvider.provider);
    return PartyRoomProvider(userProvider);
  });
}
