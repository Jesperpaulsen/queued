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

  Future<bool> connect(String partyName) async {
    connected = await SpotifySdk.connectToSpotifyRemote(
        clientId: clientId, redirectUrl: redirectUrl);
    return connected;
  }
}
