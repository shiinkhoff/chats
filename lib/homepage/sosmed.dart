import 'package:chatdansosmed/homepage/home.dart';
import 'package:chatdansosmed/homepage/post.dart';
import 'package:flutter/material.dart';


class medsospage extends StatelessWidget {
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
        leading: IconButton(
          icon: Image.asset('images/notification.png', height: 24),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Image.asset('images/setting.png', height: 24),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        children: [
          PostWidget(
            username: 'litch',
            time: '15.58',
            content: 'Dimabuk apalagi ya setelah mobile ini',
            likes: '',
            backgroundImage: 'assets/image/litch.png',
          ),
          PostWidget(
            username: 'asta',
            time: '15.58',
            content: 'partner baru nichhh xoxo',
            imageUrl: 'assets/image/game_screenshoot.png',
            likes: '280k',
            backgroundImage: 'assets/image/asta.png',
          ),
          PostWidget(
            username: 'asta',
            time: '15.58',
            content: 'Lagi ada UC promo ni, cepetan sebelum promonya habis',
            imageUrl: 'assets/image/uc_promo.png',
            likes: '',
            backgroundImage: 'assets/image/asta.png',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PostPage(),
                ),
              );
        },
        child: const Icon(Icons.add, size: 32),
        backgroundColor: Colors.orange,
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Container(
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Image.asset('images/chats.png', height: 30),
                onPressed: () {
                  Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage (),
                ),
              );
            },
         ),
              IconButton(
                icon: Image.asset('images/HOME.png', height: 30),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PostWidget extends StatelessWidget {
  final String username;
  final String time;
  final String content;
  final String? imageUrl;
  final String likes;
  final String backgroundImage;

  PostWidget({
    required this.username,
    required this.time,
    required this.content,
    this.imageUrl,
    required this.likes,
    required this.backgroundImage,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage(backgroundImage),
                      backgroundColor: Colors.transparent,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      username,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Text(time, style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 5),
            Text(content),
            if (imageUrl != null) ...[
              const SizedBox(height: 5),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(imageUrl!, fit: BoxFit.cover),
              ),
            ],
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(Icons.favorite_border),
                const SizedBox(width: 5),
                Text(likes),
              ],
            ),
          ],
        ),
      ),
    );
  }
}