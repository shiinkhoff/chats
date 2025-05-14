class Message {
  final int id;
  final int conversationId;
  final int senderId;
  final String message;
  final String? imageUrl;

  Message({required this.id, required this.conversationId, required this.senderId, required this.message, this.imageUrl});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      conversationId: json['conversation_id'],
      senderId: json['sender_id'],
      message: json['message'],
      imageUrl: json['image_url'],
    );
  }
}
