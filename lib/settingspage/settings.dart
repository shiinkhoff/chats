import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:chatdansosmed/homepage/home.dart';
import 'package:chatdansosmed/login/getstart.dart';
import 'package:chatdansosmed/login/login.dart';
import 'package:chatdansosmed/login/tampilanlogin.dart';
import 'package:chatdansosmed/settingspage/block.dart';
import 'package:chatdansosmed/settingspage/contact.dart';
import 'package:chatdansosmed/settingspage/myaccount.dart';
import 'package:chatdansosmed/settingspage/privasi dan security/privacysecc.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String username = "Loading...";
  String phone = "Loading...";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        final DocumentSnapshot userData =
            await _firestore.collection('users').doc(user.uid).get();
        if (userData.exists) {
          setState(() {
            username = userData['username'] ?? "No Username";
            phone = userData['phone'] ?? "No Phone";
          });
        }
      }
    } catch (e) {
      setState(() {
        username = "Error";
        phone = "Error";
      });
    }
  }

  void _showAddAccountBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 60,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Image.asset('images/meliodas.png', width: 60, height: 60),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Meliodas',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                          SizedBox(height: 6),
                          Text('083191907706',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey)),
                        ],
                      ),
                    ),
                    Image.asset('images/Vector.png', width: 60, height: 60),
                  ],
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    _showNewAccountBottomSheet(context);
                  },
                  child: const Text(
                    '+ Add Account',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showNewAccountBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text('Add Account',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: const Size(double.infinity, 40),
                ),
                child: const Text(
                  'Log into other account',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const GetStartPage()),
                  );
                },
                child: const Text('New Account'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLogoutBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const LogoutBottomSheet(),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        leading: IconButton(
          icon: Image.asset('images/back.png'),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(30),
          child: Padding(
            padding: EdgeInsets.only(left: 16.0, bottom: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Settings',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const CircleAvatar(
              backgroundImage: AssetImage('images/meliodas.png'),
              radius: 40,
            ),
            const SizedBox(height: 10),
            Text(username,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(phone, style: const TextStyle(color: Colors.grey)),
            const Divider(),
            buildSection(context, [
              _buildSettingsOption(context, 'My account',
                  'images/myaccount.png', const MyAccount()),
            ]),
            buildSection(context, [
              _buildSettingsOption(
                  context, 'Contact', 'images/contact.png', ContactPage()),
              _buildSettingsOption(context, 'Privacy & security',
                  'images/privsecc.png', const PrivacySecurityPage()),
              _buildSettingsOption(
                  context, 'Blocked', 'images/block.png', const BlockedPage()),
            ]),
            buildSection(context, [
              _buildSettingsOption(
                  context, 'Add Account', 'images/add.png', Container(),
                  onTap: () => _showAddAccountBottomSheet(context)),
              _buildSettingsOption(
                  context, 'Log out', 'images/logout.png', Container(),
                  onTap: () => _showLogoutBottomSheet(context)),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsOption(
      BuildContext context, String title, String iconPath, Widget page,
      {VoidCallback? onTap}) {
    return ListTile(
      leading: Image.asset(iconPath, width: 30, height: 30),
      title: Text(title),
      trailing: Image.asset('images/next.png', width: 20, height: 20),
      onTap: onTap ??
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            );
          },
    );
  }

  Widget buildSection(BuildContext context, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: children
            .expand((widget) => [
                  widget,
                  if (widget != children.last)
                    const Divider(color: Colors.grey, height: 1)
                ])
            .toList(),
      ),
    );
  }
}

class LogoutBottomSheet extends StatefulWidget {
  const LogoutBottomSheet({super.key});

  @override
  _LogoutBottomSheetState createState() => _LogoutBottomSheetState();
}

class _LogoutBottomSheetState extends State<LogoutBottomSheet> {
  bool saveLogin = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Wrap(
        children: [
          Center(
            child: Container(
              width: 40,
              height: 5,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const Center(
            child: Text(
              'Log Out of Account?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Image.asset('images/meliodas.png', width: 60, height: 60),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Meliodas',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('083191907706', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              Switch(
                value: saveLogin,
                onChanged: (value) {
                  setState(() {
                    saveLogin = value;
                  });
                },
                activeColor: const Color(0xFFFD8E4F),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'We’ll save your login info and account will automatically be deactivated if you don’t login within 60 days',
            style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const TampilanLogin()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffF81818),
              minimumSize: const Size(double.infinity, 40),
            ),
            child: const Text(
              'Log Out',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
