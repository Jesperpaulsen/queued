import 'package:flutter_riverpod/all.dart';
import 'package:queued/api/api.dart';
import 'package:queued/models/queue_request.dart';
import 'package:queued/providers/party_room_provider.dart';
import 'package:queued/providers/queue_provider.dart';
import 'package:queued/services/spotify.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/models/track.dart';

class SpotifyState {
  final spotify = Spotify();
  var token = "";
  var connected = false;
  var isPaused = false;
  var loadInProgress = false;
  var position = 0;
  var playingPlaylist = false;
  QueueRequest currentQueueRequest;
  QueueRequest requestBeingLoaded;
  Track track;
}

class SpotifyProvider extends StateNotifier<SpotifyState> {
  final PartyRoomProvider partyRoomProvider;
  final Stream<List<QueueRequest>> queueStream;
  SpotifyProvider(this.partyRoomProvider, this.queueStream)
      : super(SpotifyState()) {
    this.queueStream.listen((queue) {
      setCurrentQueueRequest(queue.first);
    });
  }

  setToken(String token) {
    final newState = state;
    newState.token = token;
    state = newState;
  }

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

  setPosition(int position) {
    final newState = state;
    newState.position = position;
    state = newState;
  }

  setLoadInProgress(bool loadInProgress) {
    final newState = state;
    newState.loadInProgress = loadInProgress;
    state = newState;
  }

  setPlayingPlaylist(bool playingPlaylist) {
    final newState = state;
    newState.playingPlaylist = playingPlaylist;
    state = newState;
  }

  setCurrentQueueRequest(QueueRequest queueRequest) {
    final newState = state;
    newState.currentQueueRequest = queueRequest;
    state = newState;
  }

  setRequestBeingLoaded(QueueRequest queueRequest) {
    final newState = state;
    newState.requestBeingLoaded = queueRequest;
    state = newState;
  }

  Future<void> connect() async {
    final token =
        await state.spotify.connect(partyRoomProvider.state.partyRoom.name);
    setToken(token);
    setConnected(true);
    state.spotify.listenToChanges(handlePlayerChange, (error) => connect());
    return firstLoad();
  }

  updateCurrentlyPlaying(PlayerState state) {
    setTrack(state.track);
    setIsPaused(state.isPaused);
  }

  Future<void> handlePlayerChange(PlayerState state) async {
    print(state.isPaused);
    setTrack(state.track);
    setIsPaused(state.isPaused);
  }

  Future<void> togglePause() async {
    if (state.isPaused) {
      return state.spotify.resume();
    } else {
      return state.spotify.pause();
    }
  }

  Future<void> firstLoad() async {
    setLoadInProgress(true);
    setRequestBeingLoaded(state.currentQueueRequest);
    if (state.requestBeingLoaded != null) {
      await API.queue.upVoteNextSong(
          partyRoomProvider.state.partyRoom.partyID, state.requestBeingLoaded);
      return loadAndPlayQueue();
    }
  }

  Future<void> loadAndPlayQueue() async {
    await API.partyRoom
        .setPlayingPlaylist(partyRoomProvider.state.partyRoom.partyID, false);
    print("test");
    return state.spotify.play(state.requestBeingLoaded.spotifyUri);
  }

  static final provider = StateNotifierProvider((ref) => SpotifyProvider(
      ref.watch(PartyRoomProvider.provider),
      ref.watch(QueueProvider.provider.stream)));
}
