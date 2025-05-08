import 'package:flutter/material.dart';

class ChesyStoryPage extends StatefulWidget {
  const ChesyStoryPage({Key? key}) : super(key: key);

  @override
  _ChesyStoryPageState createState() => _ChesyStoryPageState();
}

class _ChesyStoryPageState extends State<ChesyStoryPage> {
  bool isReplyVisible = false; // Track the visibility of the reply input
  final TextEditingController _replyController =
      TextEditingController(); // Controller for reply input

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Back to previous page
          },
        ),
      ),
      body: Column(
        children: [
          // Contact name and timestamp
          const ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage('images/profil.png'),
            ),
            title: Text(
              'chesy',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'Hari ini 20.19', // Timestamp
              style: TextStyle(color: Colors.black54),
            ),
          ),

          // Display the image with fit
          Expanded(
            child: Container(
              width: double.infinity, // Fill the width of the screen
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'images/chesy_story.png'), // Use the correct image asset path
                  fit: BoxFit
                      .cover, // Make image fill the container without padding
                ),
              ),
            ),
          ),

          // Caption or message
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'WKWK CU BANGET', // Caption or the story message
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),

          // Reply button and like icon
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Expanded for a wider Reply button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isReplyVisible =
                            !isReplyVisible; // Toggle reply visibility
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Reply'),
                  ),
                ),
                const SizedBox(width: 16), // Space between buttons
                IconButton(
                  onPressed: () {
                    // Implement like functionality here
                  },
                  icon: const Icon(Icons.favorite_border, color: Colors.black),
                ),
              ],
            ),
          ),

          // Reply input field
          if (isReplyVisible)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _replyController,
                      decoration: InputDecoration(
                        hintText: 'Type your reply...',
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.orange),
                    onPressed: () {
                      // Implement send reply functionality here
                      final replyText = _replyController.text;
                      if (replyText.isNotEmpty) {
                        // Handle the reply text (e.g., send to a server, display on screen, etc.)
                        print("Reply sent: $replyText");
                        _replyController.clear();
                        setState(() {
                          isReplyVisible =
                              false; // Hide the reply input after sending
                        });
                      }
                    },
                  ),
                ],
              ),
            ),

          const SizedBox(height: 20), // Space at the bottom
        ],
      ),
    );
  }
}
