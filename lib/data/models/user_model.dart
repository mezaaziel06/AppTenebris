class UserModel {
  final String id;
  final String email;
  final String displayName;
  final String? avatarUrl;

  UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    required this.avatarUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      email: json["email"] ?? "",
      displayName: json["display_name"] ?? "",
      avatarUrl: json["avatar_url"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "email": email,
      "display_name": displayName,
      "avatar_url": avatarUrl,
    };
  }
}
