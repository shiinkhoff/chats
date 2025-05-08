import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LastSeenOnline extends StatefulWidget {
  const LastSeenOnline({super.key});

  @override
  _LastSeenOnlineState createState() => _LastSeenOnlineState();
}

class _LastSeenOnlineState extends State<LastSeenOnline> {
  String _lastSeenValue = 'Nobody';
  String _onlineValue = 'Same as last seen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context, {
                  'lastSeen': _lastSeenValue,
                  'online': _onlineValue,
                });
              },
              child: Image.asset(
                'images/back.png',
                width: 22,
                height: 22,
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                "Last seen & online",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 45),
            const Text(
              'Who can see my last seen?',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w100,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Column(
                  children: [
                    _buildOptionTile(
                      title: 'Everyone',
                      value: _lastSeenValue == 'Everyone',
                      onTap: () {
                        setState(() {
                          _lastSeenValue = 'Everyone';
                        });
                      },
                    ),
                    const Divider(height: 1),
                    _buildOptionTile(
                      title: 'My contact',
                      value: _lastSeenValue == 'My contact',
                      onTap: () {
                        setState(() {
                          _lastSeenValue = 'My contact';
                        });
                      },
                    ),
                    const Divider(height: 1),
                    _buildOptionTile(
                      title: 'Nobody',
                      value: _lastSeenValue == 'Nobody',
                      onTap: () {
                        setState(() {
                          _lastSeenValue = 'Nobody';
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Who can see when I\'m online?',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w100,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Column(
                  children: [
                    _buildOptionTile(
                      title: 'Everyone',
                      value: _onlineValue == 'Everyone',
                      onTap: () {
                        setState(() {
                          _onlineValue = 'Everyone';
                        });
                      },
                    ),
                    const Divider(height: 1),
                    _buildOptionTile(
                      title: 'Same as last seen',
                      value: _onlineValue == 'Same as last seen',
                      onTap: () {
                        setState(() {
                          _onlineValue = 'Same as last seen';
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required String title,
    required bool value,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 14),
            ),
            if (value) const Icon(Icons.check, color: Colors.orange, size: 20),
          ],
        ),
      ),
    );
  }
}
