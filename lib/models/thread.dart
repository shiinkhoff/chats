class Thread {
  final String id;
  final String userId;
  final String username;
  final String content;
  final String? gambar;
  final String? createdAt; // Tambahkan ini

  Thread({
    required this.id,
    required this.userId,
    required this.username,
    required this.content,
    this.gambar,
    this.createdAt, // Tambahkan ini
  });

  factory Thread.fromJson(Map<String, dynamic> json) {
    return Thread(
      id: json['id'].toString(),
      userId: json['user_id'].toString(),
      username: json['username'] ?? '',
      content: json['content'] ?? '',
      gambar: json['gambar'],
      createdAt: json['created_at'] ?? '', // Pastikan ini sesuai dengan API
    );
  }
}
