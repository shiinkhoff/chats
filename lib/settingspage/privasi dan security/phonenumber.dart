import 'package:flutter/material.dart';

class PhoneNumber extends StatefulWidget {
  const PhoneNumber({super.key});

  @override
  _PhoneNumberState createState() => _PhoneNumberState();
}

class _PhoneNumberState extends State<PhoneNumber> {
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
                  'phoneNumber': _lastSeenValue,
                  'findMe': _onlineValue,
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
                "Phone Number",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 45),
            const Text(
              'Who can see my phone number?',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w100,
              ),
            ),
            const SizedBox(height: 8),
            _buildRoundedContainer([
              _buildOptionTile(
                title: 'Everyone',
                value: _lastSeenValue == 'Everyone',
                onTap: () {
                  setState(() {
                    _lastSeenValue = 'Everyone';
                  });
                },
              ),
              const Divider(height: 1, color: Colors.grey),
              _buildOptionTile(
                title: 'My contact',
                value: _lastSeenValue == 'My contact',
                onTap: () {
                  setState(() {
                    _lastSeenValue = 'My contact';
                  });
                },
              ),
              const Divider(height: 1, color: Colors.grey),
              _buildOptionTile(
                title: 'Nobody',
                value: _lastSeenValue == 'Nobody',
                onTap: () {
                  setState(() {
                    _lastSeenValue = 'Nobody';
                  });
                },
              ),
            ]),
            const SizedBox(height: 24),
            const Text(
              'Who can find me by phone number?',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w100,
              ),
            ),
            const SizedBox(height: 8),
            _buildRoundedContainer([
              _buildOptionTile(
                title: 'Everyone',
                value: _onlineValue == 'Everyone',
                onTap: () {
                  setState(() {
                    _onlineValue = 'Everyone';
                  });
                },
              ),
              const Divider(height: 1, color: Colors.grey),
              _buildOptionTile(
                title: 'My contact',
                value: _onlineValue == 'My contact',
                onTap: () {
                  setState(() {
                    _onlineValue = 'My contact';
                  });
                },
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildRoundedContainer(List<Widget> children) {
    return Container(
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
        child: Column(children: children),
      ),
    );
  }

  Widget _buildOptionTile(
      {required String title, required bool value, required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
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
