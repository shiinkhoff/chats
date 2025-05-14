import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/thread.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final TextEditingController _controller = TextEditingController();
  List<Thread> _threads = [];

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

  void _addPost() async {
    if (_controller.text.isNotEmpty) {
      final success = await ApiService.createThread(
          1, _controller.text); // ganti 1 sesuai user ID
      if (success) {
        _controller.clear();
        _loadThreads();
      } else {
        print('Gagal post ke Laravel');
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
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Write something...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _addPost,
                ),
              ),
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
                              'User ID: ${thread.userId}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            Text(thread.content),
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
