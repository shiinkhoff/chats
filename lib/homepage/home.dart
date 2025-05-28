import 'package:chatdansosmed/homepage/post.dart';
import 'package:chatdansosmed/homepage/story.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatdansosmed/homepage/sosmed.dart';
import 'package:chatdansosmed/homepage/detailchat.dart';
import 'package:chatdansosmed/settingspage/settings.dart';
import 'package:chatdansosmed/homepage/yourstory.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<String> usernames = [];
  String currentUsername = '';
  Map<String, String> lastMessages = {};

  @override
  void initState() {
    super.initState();
    fetchCurrentUsername();
  }

  String _createChatRoomId(String userId1, String userId2) {
    List<String> userIds = [userId1, userId2];
    userIds.sort();
    return userIds.join('_');
  }

  Future<void> fetchCurrentUsername() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (userSnapshot.exists) {
      setState(() {
        currentUsername = userSnapshot.data()!['username'] as String;
      });
      fetchUsernames();
    }
  }

  Future<void> fetchUsernames() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot = await FirebaseFirestore.instance.collection('users').get();
    final fetchedUsernames =
        snapshot.docs.map((doc) => doc['username'] as String).toList();

    setState(() {
      usernames = fetchedUsernames
          .where((username) => username != currentUsername)
          .toList();
    });

    listenForMessages();
  }

  void listenForMessages() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("User belum login.");
      return;
    }

    final currentUserId = user.uid;

    for (String username in usernames) {
      FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .get()
          .then((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          String otherUserId = querySnapshot.docs.first.id;
          String chatRoomId = _createChatRoomId(currentUserId, otherUserId);

          FirebaseFirestore.instance
              .collection('chats')
              .doc(chatRoomId)
              .snapshots()
              .listen((chatRoomSnapshot) {
            if (chatRoomSnapshot.exists) {
              String lastMessage =
                  chatRoomSnapshot.data()?['lastMessage'] ?? '';
              setState(() {
                lastMessages[username] = lastMessage;
              });
            }
          });
        }
      });
    }
  }

  List<String> _filteredUsernames() {
    return _searchQuery.isEmpty
        ? usernames
        : usernames
            .where((username) =>
                username.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();
  }

  String _getFirstName(String username) {
    return username.split(' ').first;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: currentUsername.isNotEmpty
            ? Text(
                'Hello, $currentUsername',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              )
            : const CircularProgressIndicator(),
        actions: [
          IconButton(
            icon: Image.asset('images/setting.png'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CameraPage()),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipOval(
                            child: Image.asset('images/mystory.png',
                                width: 60, height: 60, fit: BoxFit.cover),
                          ),
                          const SizedBox(height: 5),
                          const Text('Your Story',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  ...usernames.map((username) => GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChesyStoryPage()),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipOval(
                                child: Image.asset('images/person.png',
                                    width: 60, height: 60, fit: BoxFit.cover),
                              ),
                              const SizedBox(height: 5),
                              Text(_getFirstName(username),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child:
                      Image.asset('images/search.png', width: 30, height: 30),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              children: _filteredUsernames()
                  .map((username) => Column(
                        children: [
                          ListTile(
                            leading: ClipOval(
                              child: Image.asset("images/person.png",
                                  width: 40, height: 40, fit: BoxFit.cover),
                            ),
                            title: Text(
                              _getFirstName(username),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            subtitle: Text(
                              lastMessages[username] ?? '',
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 14),
                            ),
                            onTap: () async {
                              final user = FirebaseAuth.instance.currentUser;
                              if (user == null) return;

                              final snapshot = await FirebaseFirestore.instance
                                  .collection('users')
                                  .where('username', isEqualTo: username)
                                  .get();

                              if (snapshot.docs.isNotEmpty) {
                                final otherUserId = snapshot.docs.first.id;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatDetail(
                                      otherUserId: otherUserId,
                                      otherUsername: username,
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                          Divider(
                              height: 1, color: Colors.grey[300], thickness: 1),
                        ],
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Image.asset('images/chat.png'), label: ''),
          BottomNavigationBarItem(
              icon: Image.asset('images/homee.png'), label: ''),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => PostPage()));
          }
        },
      ),
    );
  }
}
