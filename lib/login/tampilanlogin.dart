import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chatdansosmed/homepage/home.dart';
import 'package:chatdansosmed/login/getstart.dart';
import 'package:chatdansosmed/login/login.dart';

class TampilanLogin extends StatelessWidget {
  const TampilanLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: _checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          User? user = snapshot.data;

          if (user != null && user.emailVerified) {
            // Jika user sudah login dan email terverifikasi, langsung ke HomePage
            return HomePage();
          } else {
            // Jika email belum terverifikasi, logout user dan tampilkan pesan
            FirebaseAuth.instance.signOut();
            return const Login();
          }
        }

        // Jika user belum login, tetap di TampilanLogin
        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFFA6A6A), Color(0xFFFA956A)],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'Hi Welcome\nto Tatalk',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.brown.shade700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Image.asset(
                    'images/catlogo.png',
                    height: 200,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Text(
                      'Let\'s talk with your\nfriends and family',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.brown.shade700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 45),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const GetStartPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9A4D35),
                      foregroundColor: const Color(0xFFFFFFFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 100, vertical: 20),
                    ),
                    child: const Text('Get Started'),
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
                      backgroundColor: const Color(0xFFFA956A),
                      foregroundColor: const Color(0xFFffffff),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            color: Color(0xFF9D4D34), width: 2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 115, vertical: 20),
                    ),
                    child: const Text('Login'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<User?> _checkLoginStatus() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    return auth.currentUser;
  }
}
