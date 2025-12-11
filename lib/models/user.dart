class User {
  String? username;
  String? password;
  int? timeStamp;
  User({this.username = "", this.password = "", this.timeStamp});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'] as String?,
      password: json['password'] as String?,
      timeStamp: json['timeStamp'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    "username": username,
    "password": password,
    "timeStamp": timeStamp,
  };
}
