class ChatUserModal {
  final String uid;
  final String name;
  final String email;
  final String image;
  final DateTime lastActive;
  final bool isOnline;
  const ChatUserModal({
    required this.name,
    required this.image,
    required this.lastActive,
    required this.uid,
    required this.email,
    this.isOnline = false,
  });

  factory ChatUserModal.fromJson(Map<String, dynamic> json) => ChatUserModal(
      uid: json['uid'],
      email: json['email'],
      name: json['name'],
      image: json['image'],
      lastActive: json['lastActive'].toDate(),
      isOnline: json['isOnline'] ?? false);

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'email': email,
        'image': image,
        'lastActive': lastActive,
        'isOnline': isOnline,
      };
}
