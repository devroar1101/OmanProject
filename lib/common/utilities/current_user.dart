class CurrentUser {
  static final CurrentUser _instance = CurrentUser._internal();

  int? userId;
  String? userObjectId;
  String? email;
  String? systemName;
  String? name;
  String? token;

  CurrentUser._internal();

  factory CurrentUser() {
    return _instance;
  }

  void setUserDetails(Map<String, dynamic> userData) {
    userId = userData['userId'] ?? 1;
    userObjectId = userData['userObjectId'] ?? '1111';
    email = userData['email'];
    systemName = userData['systemName'];
    name = userData['name'];
    token = userData['token'];
  }

  void clearUserDetails() {
    userId = null;
    userObjectId = null;
    email = null;
    systemName = null;
    name = null;
    token = null;
  }
}
