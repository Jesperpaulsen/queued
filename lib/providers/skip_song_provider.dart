import 'package:flutter_riverpod/all.dart';
import 'package:queued/api/api.dart';
import 'package:queued/providers/party_room_provider.dart';
import 'package:queued/providers/user_provider.dart';
import 'package:queued/services/spotify.dart';

class SkipSongProviderState {
  int numberOfVotes;
  bool userHasVoted;

  SkipSongProviderState() {
    numberOfVotes = 0;
    userHasVoted = false;
  }
}

class SkipSongProvider extends StateNotifier<SkipSongProviderState> {
  PartyRoomState partyRoomState;
  UserState userState;
  SkipSongProvider(this.partyRoomState, this.userState)
      : super(SkipSongProviderState()) {
    mountVotesForNext();
  }

  mountVotesForNext() {
    final votesStream =
        API.votes.mountVotesToSkipSong(partyRoomState.partyRoom.partyID);
    votesStream.listen((snapshot) {
      setNumberOfVotes(snapshot.size);
      setUserHasVoted(snapshot.docs
          .any((vote) => vote.data().containsValue(userState.user.uid)));
    });
  }

  setNumberOfVotes(int numberOfVotes) {
    Spotify.instance.setVotes(numberOfVotes);
    final newState = state;
    newState.numberOfVotes = numberOfVotes;
    state = newState;
  }

  setUserHasVoted(bool userHasVoted) {
    final newState = state;
    newState.userHasVoted = userHasVoted;
    state = newState;
  }

  skipSong() async {
    setUserHasVoted(true);
    try {
      await API.votes
          .voteToSkipSong(partyRoomState.partyRoom.partyID, userState.user.uid);
    } catch (e) {
      setUserHasVoted(false);
      print(e);
    }
  }

  static final provider = StateNotifierProvider<SkipSongProvider>((ref) =>
      SkipSongProvider(ref.watch(PartyRoomProvider.provider.state),
          ref.watch(UserProvider.provider.state)));
}
