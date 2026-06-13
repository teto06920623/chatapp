class ChatLastMessage {
  final String image;
  final String name;
  final String lastMessage;
  final String time;
  final bool isread;

  ChatLastMessage({
    required this.image,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.isread,
  });

  factory ChatLastMessage.fromJson(Map<String, dynamic> json) {
    return ChatLastMessage(
      image: json['image'],
      name: json['name'],
      lastMessage: json['lastMessage'],
      time: json['time'],
      isread: json['isread'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'name': name,
      'lastMessage': lastMessage,
      'time': time,
      'isread': isread,
    };
  }
}
