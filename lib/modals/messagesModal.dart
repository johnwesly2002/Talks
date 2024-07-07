class Messages {
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime sentTime;
  final MessageType messageType;

  const Messages({
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.sentTime,
    required this.messageType,
  });
  factory Messages.fromJson(Map<String, dynamic> json) => Messages(
        receiverId: json['receiverId'],
        senderId: json['senderId'],
        sentTime: json['sentTime'].toDate(),
        content: json['content'],
        messageType: MessageType.fromJson(json['messageType']),
      );

  Map<String, dynamic> toJson() => {
        "receiverId": receiverId,
        "senderId": senderId,
        "content": content,
        "sentTime": sentTime,
        "messageType": messageType.toJson(),
      };
}

enum MessageType {
  text,
  image;

  String toJson() => name;
  factory MessageType.fromJson(String json) => values.byName(json);
}
