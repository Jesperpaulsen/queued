import 'package:queued/services/dio_wrapper.dart';

class SpotifyToken {
  String _token;
  String refreshToken;
  String generalToken;
  DateTime tokenExpires;

  SpotifyToken._privateConstructor() {
    getGeneralToken();
  }

  static final instance = SpotifyToken._privateConstructor();

  Future<void> setSdkToken(String sdkToken) async {}

  get token async {}

  Future<void> getGeneralToken() async {
    final res = await DioWrapper.instance.client.get('/getNewToken');
    generalToken = res.data["body"]["access_token"];
    print("token" + generalToken);
    tokenExpires = DateTime.now().add(Duration(hours: 1));
  }
}
