class Message {
  final bool isSender;
  final String content;
  final int timestamp;

  Message({
    required this.isSender,
    required this.content,
    required this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    final content = json["choices"][0]["message"]["content"];

    return Message(
      isSender: false,
      content: content,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
  }

  factory Message.fromDatabase(Map<String, dynamic> json) {
    print(json);
    return Message(
      isSender: json["is_sender"] == 1 ? true : false,
      content: json["content"],
      timestamp: json["timestamp"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "is_sender": isSender,
      "content": content,
      "timestamp": timestamp,
    };
  }
}
