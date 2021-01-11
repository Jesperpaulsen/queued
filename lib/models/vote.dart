class Vote {
  String voteID;
  final String requestID;
  final String userID;

  Vote({this.voteID, this.requestID, this.userID});

  Vote.fromJson(String voteID, Map json)
      : voteID = voteID,
        requestID = json["requestID"] ?? "",
        userID = json["userID"] ?? "";

  Map<String, dynamic> toJson() {
    return {
      "requestID": requestID,
      "userID": userID,
    };
  }
}
