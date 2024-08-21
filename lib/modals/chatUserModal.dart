class ChatUserModal {
  String uid;
  String name;
  String email;
  String image;
  DateTime lastActive;
  bool isOnline;
  int unreadMessages;
  ChatUserModal({
    required this.name,
    required this.image,
    required this.lastActive,
    required this.uid,
    required this.email,
    this.isOnline = false,
    this.unreadMessages = 0,
  });

  factory ChatUserModal.fromJson(Map<String, dynamic> json) => ChatUserModal(
        uid: json['uid'],
        email: json['email'],
        name: json['name'],
        image: json['image'],
        lastActive: json['lastActive'].toDate(),
        isOnline: json['isOnline'] ?? false,
        unreadMessages: json['unreadMessages'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'email': email,
        'image': image,
        'lastActive': lastActive,
        'isOnline': isOnline,
        'unreadMessages': unreadMessages,
      };
}
