import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../models/thread.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImage;
  List<Thread> _threads = [];

  String _formatTimestamp(String? timestamp) {
    if (timestamp == null) return '';
    final dateTime = DateTime.tryParse(timestamp);
    if (dateTime == null) return '';
    return '${dateTime.day}-${dateTime.month}-${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _loadThreads() async {
    try {
      final data = await ApiService.fetchThreads();
      setState(() {
        _threads = data;
      });
    } catch (e) {
      print('Error fetching threads: $e');
    }
  }

  void _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _pickedImage = picked;
      });
    }
  }

  Future<void> _addPost() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User belum login')),
      );
      return;
    }

    if (_controller.text.isNotEmpty || _pickedImage != null) {
      final success = await ApiService.createThread(
        userId,
        _controller.text,
        _pickedImage != null ? File(_pickedImage!.path) : null,
      );
      if (success) {
        _controller.clear();
        setState(() {
          _pickedImage = null;
        });
        _loadThreads();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal mengirim post ke Laravel')),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadThreads();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tatalk',
          style: TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: 'Write something...',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: _addPost,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.image),
                      label: const Text("Pilih Gambar"),
                    ),
                    const SizedBox(width: 10),
                    if (_pickedImage != null)
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: Image.file(File(_pickedImage!.path),
                            fit: BoxFit.cover),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: _threads.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _threads.length,
                    itemBuilder: (context, index) {
                      final thread = _threads[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 10.0),
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Username: ${thread.username}', // ← Ganti User ID jadi username
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            Text(thread.content),
                            const SizedBox(height: 10),
                            if (thread.gambar != null &&
                                thread.gambar!.isNotEmpty)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  thread.gambar!,
                                  fit: BoxFit.cover,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    print("Image error: $error"); // ← debug log
                                    return const Text(
                                        "Gagal menampilkan gambar");
                                  },
                                ),
                              ),
                            const SizedBox(
                              height: 5,
                            ),
                            if (thread.createdAt != null &&
                                thread.createdAt!.isNotEmpty)
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  timeago.format(
                                      DateTime.parse(thread.createdAt!),
                                      locale: 'id'),
                                  style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic),
                                ),
                              )
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
