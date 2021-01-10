class Vote {
  final String requestID;
  final String userID;

  Vote({this.requestID, this.userID});

  Vote.fromJson(Map json)
      : requestID = json["requestID"] ?? "",
        userID = json["userID"] ?? "";
}
