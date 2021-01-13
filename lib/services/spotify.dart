import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:queued/api/api.dart';
import 'package:queued/models/queue_request.dart';
import 'package:queued/providers/spotify_provider.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class Spotify {
  String _clientId;
  String _redirectUrl;
  String _token;
  SpotifyProvider _spotifyProvider;
  PlayerState _playerState;
  ConnectionStatus _connectionStatus;
  QueueRequest _currentQueueRequest;
  QueueRequest _requestBeingLoaded;
  List<QueueRequest> _queue;
  var _loadInProgress = false;
  String _partyID;
  var _votesRequiredToSkipSong = 9999;
  int _numberOfVotes = 0;
  var _playingPlaylist = false;
  String _fallbackListUri = "";
  var _firstLoadAfterConnection = true;

  Spotify._privateConstructor() {
    this._clientId = DotEnv().env["SPOTIFY_CLIENT_ID"].toString();
    this._redirectUrl = DotEnv().env["SPOTIFY_REDIRECT_URI"].toString();
  }

  static final instance = Spotify._privateConstructor();

  void cleanState() {
    _playingPlaylist = false;
    _firstLoadAfterConnection = true;
  }

  Future<void> connect() async {
    try {
      listenToConnectionChanges();
      _token = await SpotifySdk.getAuthenticationToken(
          clientId: _clientId,
          redirectUrl: _redirectUrl,
          scope: 'app-remote-control, '
              'user-modify-playback-state, '
              'playlist-read-private, '
              'playlist-modify-public,user-read-currently-playing');
    } catch (e) {
      cleanState();
      print(e);
    }
  }

  void setSpotifyProvider(SpotifyProvider spotifyProvider) =>
      _spotifyProvider = spotifyProvider;
  void subscribeToQueueStream(List<QueueRequest> queue) => _queue = queue;
  void setVotes(int numberOfVotes) {
    _numberOfVotes = numberOfVotes;
    if (_votesRequiredToSkipSong - _numberOfVotes <= 0) playNextSong();
  }

  void setPartyRoomDetails(
      String partyID, int votesRequiredToSkipSong, bool playingPlaylist) {
    _partyID = partyID;
    _votesRequiredToSkipSong = votesRequiredToSkipSong;
    _playingPlaylist = playingPlaylist;
  }

  void setFallBackList(String fallbackListUri) =>
      _fallbackListUri = fallbackListUri;

  QueueRequest get _nextRequest {
    if (_playingPlaylist || _firstLoadAfterConnection) {
      return _queue.first;
    }
    if (!_playingPlaylist && _queue.length > 1) {
      return _queue[1];
    }
    return null;
  }

  void _handleConnectionStatus(ConnectionStatus connectionStatus) {
    if (_connectionStatus == null ||
        (_connectionStatus.connected != connectionStatus.connected &&
            connectionStatus.connected)) firstLoad();
    if (!connectionStatus.connected) {
      cleanState();
      _firstLoadAfterConnection = true;
    }
    _connectionStatus = connectionStatus;
    _spotifyProvider.setConnected(connectionStatus.connected);
  }

  void _handleStateChanges(PlayerState playerState) {
    _playerState = playerState;
    _spotifyProvider.updateCurrentlyPlaying(playerState);
    if (playerState.playbackPosition > 5000)
      _loadInProgress = false;
    else if (playerState.playbackPosition == 0 && !_loadInProgress) {
      playNextSong();
    }
  }

  void _handleError(Object error) {
    _spotifyProvider.setConnected(false);
    print(error);
  }

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
      (_playerState?.isPaused ?? false) ? resume() : pause();

  Future<void> firstLoad() async {
    listenToStateChanges();
    _loadInProgress = true;
    _requestBeingLoaded = _nextRequest;
    if (_requestBeingLoaded != null) {
      _currentQueueRequest = _requestBeingLoaded;
      await API.queue.upVoteNextSong(_partyID, _requestBeingLoaded);
      await loadAndPlayQueue();
      _firstLoadAfterConnection = false;
    }
  }

  Future<void> loadAndPlayQueue() async {
    await API.partyRoom.setPlayingPlaylist(_partyID, false);
    _playingPlaylist = false;
    await play(_currentQueueRequest.spotifyUri);
  }

  Future<void> loadAndPlayPlaylist() async {
    await API.partyRoom.setPlayingPlaylist(_partyID, true);
    _playingPlaylist = true;
    await SpotifySdk.setShuffle(shuffle: true);
    await SpotifySdk.play(spotifyUri: _fallbackListUri);
  }

  Future<void> playNextSong() async {
    try {
      await pause();
    } catch (e) {}
    _loadInProgress = true;
    if (_votesRequiredToSkipSong - _numberOfVotes <= 0)
      await API.votes.clearSkipVotes(_partyID);
    else
      API.votes.clearSkipVotes(_partyID);
    _requestBeingLoaded = _nextRequest;
    if (_requestBeingLoaded != null) {
      _playingPlaylist = false;
      await API.queue.upVoteNextSong(_partyID, _requestBeingLoaded);
    }
    if (_currentQueueRequest != null) {
      await API.queue.markSongAsPlayed(_partyID, _currentQueueRequest);
    }
    _currentQueueRequest = _requestBeingLoaded;
    if (_currentQueueRequest != null)
      return loadAndPlayQueue();
    else if (!_playingPlaylist) return loadAndPlayPlaylist();
  }
}
