import 'package:flutter/material.dart';
import 'pwmyaccount.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({super.key});

  @override
  _MyAccountPageState createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccount> {
  String phoneNumber = "083191907706";
  String email = "tyafaa@gmail.com";
  String username = "Meliodas";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: <Widget>[
          const SizedBox(height: 16),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Image.asset(
                  'images/back.png',
                  width: 14,
                  height: 30,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'My Account',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 30),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildPrivacyOption("Phone Number", phoneNumber),
                const Divider(height: 1),
                _buildPrivacyOption("Email", email),
                const Divider(height: 1),
                _buildPrivacyOption("Username", username),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyOption(String title, String content,
      {String? iconPath, VoidCallback? onTap}) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 14),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            content,
            style: const TextStyle(
              color: Colors.blue,
              fontSize: 12,
            ),
          ),
          if (iconPath != null)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Image.asset(
                iconPath,
                width: 14,
                height: 22,
              ),
            ),
        ],
      ),
      onTap: onTap,
    );
  }
}
