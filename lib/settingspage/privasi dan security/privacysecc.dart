import 'package:chatdansosmed/settingspage/privasi%20dan%20security/lastseen.dart';
import 'package:chatdansosmed/settingspage/privasi%20dan%20security/phonenumber.dart';
import 'package:chatdansosmed/settingspage/privasi%20dan%20security/pp.dart';
import 'package:chatdansosmed/settingspage/privasi%20dan%20security/statuspge.dart';
import 'package:flutter/material.dart';

class PrivacySecurityPage extends StatefulWidget {
  const PrivacySecurityPage({super.key});

  @override
  _PrivacySecurityPageState createState() => _PrivacySecurityPageState();
}

class _PrivacySecurityPageState extends State<PrivacySecurityPage> {
  bool _passcodeEnabled = false;
  bool _readReceiptsEnabled = false;

  String lastSeenStatus = "Nobody";
  String phoneNumberStatus = "Nobody";
  String profilePhotoStatus = "My contact";
  String statusStatus = "My contact";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: <Widget>[
          const SizedBox(height: 15),
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
              'Privacy & Security',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F7),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(0),
            margin: const EdgeInsets.symmetric(vertical: 0),
            child: Column(
              children: [
                _buildPrivacyOption("Last seen & online", lastSeenStatus,
                    'images/next.png', context),
                const Divider(height: 1),
                _buildPrivacyOption("Phone number", phoneNumberStatus,
                    'images/next.png', context),
                const Divider(height: 1),
                _buildPrivacyOption("Profile photos", profilePhotoStatus,
                    'images/next.png', context),
                const Divider(height: 1),
                _buildPrivacyOption(
                    "Status", statusStatus, 'images/next.png', context),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F7),
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.all(0),
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: Column(
              children: [
                ListTile(
                  title: const Text(
                    "Read receipts",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 14),
                  ),
                  trailing: GestureDetector(
                    onTap: () {
                      setState(() {
                        _readReceiptsEnabled = !_readReceiptsEnabled;
                      });
                    },
                    child: Container(
                      width: 50,
                      height: 30,
                      decoration: BoxDecoration(
                        color: _readReceiptsEnabled
                            ? const Color(0xFFFD8E4F)
                            : const Color(0xFFE1E0E0),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Stack(
                        children: [
                          AnimatedAlign(
                            alignment: _readReceiptsEnabled
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 2,
          ),
          const Text(
            'If you turn off read receipt, you won’t be able to see read receipts from other people',
            style: TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyOption(
      String title, String status, String imagePath, BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 14),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            status,
            style: const TextStyle(
              color: Color(0xFF3771C8),
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 8),
          Image.asset(
            imagePath,
            width: 14,
            height: 22,
          ),
        ],
      ),
      onTap: () {
        // Navigasi untuk opsi "Last seen & online"
        if (title == "Last seen & online") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LastSeenOnline(),
            ),
          ).then((result) {
            if (result != null) {
              setState(() {
                lastSeenStatus = result['lastSeen'] ?? lastSeenStatus;
                // Update online status jika diperlukan
              });
            }
          });
        } else if (title == "Phone number") {
          // Navigasi untuk opsi "Phone number"
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PhoneNumber(),
            ),
          ).then((result) {
            if (result != null) {
              setState(() {
                phoneNumberStatus = result['phoneNumber'] ?? phoneNumberStatus;
                // Update find me status jika diperlukan
              });
            }
          });
        } else if (title == "Profile photos") {
          // Navigasi untuk opsi "Profile photos"
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PhotoProfil(),
            ),
          ).then((result) {
            if (result != null) {
              setState(() {
                profilePhotoStatus =
                    result['profilePhoto'] ?? profilePhotoStatus;
              });
            }
          });
        } else if (title == "Status") {
          // Navigasi untuk opsi "Status"
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const StatusPage(),
            ),
          ).then((result) {
            if (result != null) {
              setState(() {
                statusStatus = result['status'] ?? statusStatus;
              });
            }
          });
        }
      },
    );
  }
}
