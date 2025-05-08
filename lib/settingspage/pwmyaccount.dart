import 'package:flutter/material.dart';
import 'myaccount.dart';

class Password extends StatelessWidget {
  const Password({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
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
              'Password',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 40),
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'New Password',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 303,
            height: 33,
            child: TextField(
              obscureText: true,
              style: const TextStyle(fontSize: 12),
              decoration: InputDecoration(
                fillColor: const Color(0xFFE6E6E6),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'Confirm New Password',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 303,
            height: 33,
            child: TextField(
              obscureText: true,
              style: const TextStyle(fontSize: 12),
              decoration: InputDecoration(
                fillColor: const Color(0xFFE6E6E6),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: 303,
            height: 33,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCCCCCC),
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyAccount()),
                );
              },
              child: const Text(
                'Next',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
