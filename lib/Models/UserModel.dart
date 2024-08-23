class UserModel {
  final String Email;
  final String UserName;
  UserModel({required this.Email, required this.UserName});
  factory UserModel.fromJson(jsonData) {
    return UserModel(
      Email: jsonData["email"],
      UserName: jsonData["username"],
    );
  }
}
