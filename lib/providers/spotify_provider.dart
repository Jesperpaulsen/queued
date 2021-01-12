import 'package:flutter_riverpod/all.dart';
import 'package:queued/models/queue_request.dart';
import 'package:queued/providers/party_room_provider.dart';
import 'package:queued/providers/queue_provider.dart';
import 'package:queued/services/spotify.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/models/track.dart';

class SpotifyState {
  var connected = false;
  var isPaused = false;
  var loadInProgress = false;
  var playingPlaylist = false;
  Track track;
}

class SpotifyProvider extends StateNotifier<SpotifyState> {
  final PartyRoomProvider partyRoomProvider;
  final Stream<List<QueueRequest>> queueStream;
  SpotifyProvider(this.partyRoomProvider, this.queueStream)
      : super(SpotifyState());

  setConnected(bool connected) {
    final newState = state;
    newState.connected = connected;
    state = newState;
  }

  setTrack(Track track) {
    final newState = state;
    newState.track = track;
    state = newState;
  }

  setIsPaused(bool isPaused) {
    final newState = state;
    newState.isPaused = isPaused;
    state = newState;
  }

  updateCurrentlyPlaying(PlayerState state) {
    setTrack(state.track);
    setIsPaused(state.isPaused);
  }

  static final provider = StateNotifierProvider<SpotifyProvider>((ref) {
    final provider = SpotifyProvider(
      ref.watch(PartyRoomProvider.provider),
      ref.watch(QueueProvider.provider.stream),
    );

    Spotify.instance.setSpotifyProvider(provider);
    return provider;
  });
}
