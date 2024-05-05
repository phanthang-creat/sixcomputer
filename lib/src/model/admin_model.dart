class AdminModel {
  String? username;
  String? password;

  AdminModel({
    this.username,
    this.password,
  });

  AdminModel.fromJson(Map<dynamic, dynamic> json) {
    username = json['username'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['password'] = password;
    return data;
  }

  @override
  String toString() {
    return 'AdminModel{username: $username, password: $password}';
  }
}