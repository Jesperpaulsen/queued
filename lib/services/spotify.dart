import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class Spotify {
  String clientId;
  String redirectUrl;
  bool connected;
  Spotify() {
    this.clientId = DotEnv().env["SPOTIFY_CLIENT_ID"].toString();
    this.redirectUrl = DotEnv().env["SPOTIFY_REDIRECT_URI"].toString();
  }

  Future<String> connect(String partyName) async {
    return SpotifySdk.getAuthenticationToken(
        clientId: clientId,
        redirectUrl: redirectUrl,
        scope: 'app-remote-control, '
            'user-modify-playback-state, '
            'playlist-read-private, '
            'playlist-modify-public,user-read-currently-playing');
  }

  Future<void> pause() {
    return SpotifySdk.pause();
  }

  Future<void> resume() {
    return SpotifySdk.resume();
  }

  Future<void> play(String uri) {
    return SpotifySdk.play(spotifyUri: uri);
  }

  Future<void> seekToPosition(int position) =>
      SpotifySdk.seekTo(positionedMilliseconds: position);

  listenToChanges(Function onData, Function onError) {
    final stream = SpotifySdk.subscribePlayerState();
    stream.listen(onData, onError: onError);
  }
}
