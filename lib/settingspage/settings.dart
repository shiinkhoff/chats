import 'package:chatdansosmed/homepage/home.dart';
import 'package:chatdansosmed/login/getstart.dart';
import 'package:chatdansosmed/login/login.dart';
import 'package:chatdansosmed/login/tampilanlogin.dart';
import 'package:chatdansosmed/settingspage/block.dart';
import 'package:chatdansosmed/settingspage/contact.dart';
import 'package:chatdansosmed/settingspage/myaccount.dart';
import 'package:chatdansosmed/settingspage/privasi%20dan%20security/privacysecc.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
        print("Mengambil data pengguna untuk UID: ${user.uid}");
        final DocumentSnapshot userData =
            await _firestore.collection('users').doc(user.uid).get();
        if (userData.exists) {
          print("Data pengguna berhasil diambil: ${userData.data()}");
          setState(() {
            username = userData['username'] ?? "No Username";
            phone = userData['phone'] ?? "No Phone";
          });
        }
      }
    } catch (e) {
      print("Kesalahan saat mengambil data pengguna: $e");
      setState(() {
        username = "Error";
        phone = "Error";
      });
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const TampilanLogin()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error during logout: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        leading: IconButton(
          icon: Image.asset('images/back.png'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            );
          },
        ),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(30),
            child: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 16),
              child: const Text(
                'Settings',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(1),
              child: const CircleAvatar(
                backgroundImage: AssetImage('images/meliodas.png'),
                radius: 40,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    phone,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Divider(),
            const SizedBox(height: 0),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
              padding: const EdgeInsets.symmetric(vertical: 0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  _buildSettingsOption(
                    context,
                    Image.asset(
                      'images/myaccount.png',
                      width: 30,
                      height: 30,
                    ),
                    'My account',
                    const MyAccount(),
                    isContainer: true,
                  ),
                ],
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                padding: const EdgeInsets.symmetric(vertical: 0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(children: [
                  _buildSettingsOption(
                      context,
                      Image.asset(
                        'images/contact.png',
                        width: 40,
                        height: 30,
                      ),
                      'Contact',
                      ContactPage(),
                      isContainer: false),
                  const Divider(
                    color: Colors.grey,
                    thickness: 1,
                    height: 0,
                  ),
                  _buildSettingsOption(
                      context,
                      Image.asset(
                        'images/privsecc.png',
                        width: 30,
                        height: 30,
                      ),
                      'Privacy & security',
                      const PrivacySecurityPage()),
                  const Divider(
                    color: Colors.grey,
                    thickness: 1,
                    height: 1,
                  ),
                  _buildSettingsOption(context, Image.asset('images/block.png'),
                      'Blocked', const BlockedPage()),
                ]),
              ),
            ),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                padding: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDEDED),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    _buildSettingsOption(
                        context,
                        Image.asset(
                          'images/add.png',
                          width: 30,
                          height: 30,
                        ),
                        'Add Account',
                        (Container()), onTap: () {
                      _showAddAccountBottomSheet(context);
                    }),
                    const Divider(
                      color: Colors.grey,
                      thickness: 1,
                      height: 0,
                    ),
                    _buildSettingsOption(
                        context,
                        Image.asset(
                          'images/logout.png',
                          width: 30,
                          height: 30,
                        ),
                        'Log out',
                        (Container()), onTap: () {
                      _showLogoutBottomSheet(context);
                    })
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsOption(
      BuildContext context, Widget icon, String title, Widget page,
      {VoidCallback? onTap, bool isContainer = false, double? titleFontSize}) {
    Widget option = ListTile(
      leading: icon,
      title: Text(
        title,
        style: TextStyle(fontSize: titleFontSize ?? 14),
      ),
      trailing: Image.asset(
        'images/next.png',
        width: 20,
        height: 20,
      ),
      onTap: onTap ??
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            );
          },
    );

    // Wrap option in a Container if isContainer is true
    if (isContainer) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: option,
      );
    }

    return option;
  }

  //Widget _buildAddAccountOption(BuildContext context) {
  //return ListTile(
  //leading: const Icon(Icons.add),
  //title: const Text('Add account'),
  //trailing: const Icon(Icons.arrow_forward_ios),
  //onTap: () {
  //_showAddAccountBottomSheet(context);
  //},
  //);
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
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: 60,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Image.asset(
                    'images/meliodas.png',
                    width: 60,
                    height: 60,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(15.0),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Meliodas',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            '083191907706',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Image.asset(
                    'images/Vector.png',
                    width: 60,
                    height: 60,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  // Menutup bottom sheet yang ada
                  Navigator.of(context).pop();
                  // Menampilkan bottom sheet baru
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
              const SizedBox(height: 20),
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
      return InkWell(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: 60,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'Add Account',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Login(),
                      ),
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
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GetStartPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 40),
                  ),
                  child: const Text('New Account'),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
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
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              'Log Out of Account?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Save login',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Image.asset(
                'images/meliodas.png',
                width: 60,
                height: 60,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(15.0),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Meliodas',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        '083191907706',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () {
                  setState(() {
                    saveLogin = !saveLogin;
                  });
                },
                child: Container(
                  width: 55,
                  height: 30,
                  decoration: BoxDecoration(
                    color:
                        saveLogin ? const Color(0xFFFD8E4F) : Colors.grey[300],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Stack(
                    children: [
                      AnimatedAlign(
                        alignment: saveLogin
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        duration: const Duration(milliseconds: 200),
                        child: Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Image.asset(
                'images/exit.png',
                width: 24,
                height: 24,
              ),
              const SizedBox(width: 8),
              const Text('Exit terms'),
            ],
          ),
          const Text(
            'We’ll save your login info and account will automatically be deactivated if you don’t login within 60 days',
            style: TextStyle(
                fontStyle: FontStyle.italic, fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(
            height: 10,
          ),
          Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TampilanLogin(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffF81818),
                  minimumSize: const Size(double.infinity, 40),
                ),
                child: const Text(
                  'Log Out',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Fungsi untuk menampilkan bottom sheet
void _showLogoutBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
    ),
    builder: (BuildContext context) {
      return const LogoutBottomSheet();
    },
  );
}