import 'dart:io';

class SignupUserModal {
  final String uid;
  final String name;
  final String email;
  final String password;
  final String? image;
  final DateTime lastActive;
  final bool isOnline;
  const SignupUserModal({
    required this.name,
    required this.image,
    required this.lastActive,
    required this.uid,
    required this.email,
    required this.password,
    this.isOnline = false,
  });

  factory SignupUserModal.fromJson(Map<String, dynamic> json) =>
      SignupUserModal(
          uid: json['uid'],
          email: json['email'],
          name: json['name'],
          image: json['image'],
          password: json['password'],
          lastActive: json['lastActive'].toDate(),
          isOnline: json['isOnline'] ?? false);

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'email': email,
        'image': image,
        'password': password,
        'lastActive': lastActive,
        'isOnline': isOnline,
      };
}
