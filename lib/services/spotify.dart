import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:queued/api/api.dart';
import 'package:queued/models/queue_request.dart';
import 'package:queued/providers/party_room_provider.dart';
import 'package:queued/providers/spotify_provider.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class Spotify {
  String _clientId;
  String _redirectUrl;
  String _token;
  SpotifyProvider _spotifyProvider;
  PartyRoomProvider _partyRoomProvider;
  PlayerState _playerState;
  ConnectionStatus _connectionStatus;
  QueueRequest _currentQueueRequest;
  QueueRequest _requestBeingLoaded;
  var _loadInProgress = false;
  String partyID;

  Spotify._privateConstructor() {
    this._clientId = DotEnv().env["SPOTIFY_CLIENT_ID"].toString();
    this._redirectUrl = DotEnv().env["SPOTIFY_REDIRECT_URI"].toString();

    final container = ProviderContainer();
    this._spotifyProvider = container.read(SpotifyProvider.provider);
    this._partyRoomProvider = container.read(PartyRoomProvider.provider);
  }

  static final Spotify instance = Spotify._privateConstructor();

  Future<void> connect() async {
    try {
      _token = await SpotifySdk.getAuthenticationToken(
          clientId: _clientId,
          redirectUrl: _redirectUrl,
          scope: 'app-remote-control, '
              'user-modify-playback-state, '
              'playlist-read-private, '
              'playlist-modify-public,user-read-currently-playing');
      listenToConnectionChanges();
    } catch (e) {
      print(e);
    }
  }

  initialize(String partyID) => this.partyID = partyID;

  void subscribeToQueueStream(QueueRequest queueRequest) =>
      _currentQueueRequest = queueRequest;

  void _handleConnectionStatus(ConnectionStatus connectionStatus) {
    _connectionStatus = connectionStatus;
    _spotifyProvider.setConnected(connectionStatus.connected);
  }

  void _handleStateChanges(PlayerState playerState) {
    _playerState = playerState;
    _spotifyProvider.updateCurrentlyPlaying(playerState);
  }

  void _handleError(Error error) => print(error);

  listenToStateChanges() {
    final stream = SpotifySdk.subscribePlayerState();
    stream.listen(_handleStateChanges, onError: _handleError);
  }

  listenToConnectionChanges() {
    final stream = SpotifySdk.subscribeConnectionStatus();
    stream.listen(_handleConnectionStatus, onError: _handleError);
  }

  Future<void> play(String uri) => SpotifySdk.play(spotifyUri: uri);
  Future<void> pause() => SpotifySdk.pause();
  Future<void> resume() => SpotifySdk.resume();
  Future<void> togglePause() =>
      (_playerState.isPaused ?? false) ? resume() : pause();

  Future<void> firstLoad() async {
    _loadInProgress = true;
    _requestBeingLoaded = _currentQueueRequest;
    if (_requestBeingLoaded != null) {
      await API.queue.upVoteNextSong(partyID, _requestBeingLoaded);
      loadAndPlayQueue();
    }
  }

  Future<void> loadAndPlayQueue() async {
    await API.partyRoom.setPlayingPlaylist(partyID, false);
    play(_requestBeingLoaded.spotifyUri);
  }
}
