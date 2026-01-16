class AuthApiModel {
  final String? id;
  final String username;
  final String email;
  final String? status;

  AuthApiModel({
    this.id,
    required this.username,
    required this.email,
    this.status,
  });

  factory AuthApiModel.fromJson(Map<String, dynamic> json) {
    return AuthApiModel(
      id: json['_id'] ?? json['id'],
      username: json['username'],
      email: json['email'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {"username": username, "email": email};
  }
}
