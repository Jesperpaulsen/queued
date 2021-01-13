import 'package:dio/dio.dart';
import 'package:queued/services/spotify_token.dart';

class DioWrapper {
  Dio client = Dio();

  DioWrapper._privateConstructor() {
    client.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
      if (options.path.toLowerCase().contains('token'))
        options.baseUrl =
            "https://europe-west1-queued-217c4.cloudfunctions.net/app";
      else {
        options.baseUrl = "https://api.spotify.com/v1/";
        options.headers["Authorization"] =
            "Bearer  ${SpotifyToken.instance.generalToken}";
      }
      return options;
    }));
  }

  static final instance = DioWrapper._privateConstructor();
}
