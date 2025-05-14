class Thread {
  final int id;
  final int userId;
  final String content;

  Thread({required this.id, required this.userId, required this.content});

  factory Thread.fromJson(Map<String, dynamic> json) {
    return Thread(
      id: json['id'],
      userId: json['user_id'],
      content: json['content'],
    );
  }
}
