import 'package:dio/dio.dart';

class DioWrapper {
  Dio client = Dio();

  DioWrapper._privateConstructor() {
    client.options.baseUrl =
        "https://europe-west1-queued-217c4.cloudfunctions.net/app";
    client.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
      return options;
    }));
  }

  static final instance = DioWrapper._privateConstructor();
}
