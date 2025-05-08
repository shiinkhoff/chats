import 'package:chatdansosmed/homepage/home.dart';
import 'package:chatdansosmed/login/tampilanlogin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetStartPage extends StatelessWidget {
  const GetStartPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Controllers for text fields
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    // Sign up function
    Future<void> signUp(BuildContext context) async {
      final username = usernameController.text.trim();
      final phone = phoneController.text.trim();
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      try {
        // Daftar user ke Firebase Auth
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        User? user = userCredential.user;

        if (user != null) {
          // Kirim email verifikasi
          await user.sendEmailVerification();

          // Simpan data user ke Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            'username': username,
            'phone': phone,
            'email': email,
            'createdAt': FieldValue.serverTimestamp(),
          });

          // Tampilkan pesan bahwa email verifikasi telah dikirim
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Email Verification Sent'),
              content: const Text(
                  'A verification email has been sent. Please verify your email before logging in.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TampilanLogin()),
                    );
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      } catch (e) {
        // Tampilkan pesan error
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Color(0xFFFA6A6A),
              Color(0XFFFA956A),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  margin: const EdgeInsets.only(top: 50, bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.56),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const TampilanLogin(),
                              ),
                            );
                          },
                          child: Image.asset('images/x.png'),
                        ),
                      ),
                      Image.asset(
                        'images/catlogo.png',
                        height: 195,
                        width: 195,
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 20),
                        child: Column(
                          children: [
                            TextField(
                              controller: usernameController,
                              decoration: InputDecoration(
                                labelText: 'Username',
                                border: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              controller: phoneController,
                              decoration: InputDecoration(
                                labelText: 'Phone number',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              controller: emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              controller: passwordController,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 50),
                            ElevatedButton(
                              onPressed: () => signUp(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 157, 77, 53),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 120, vertical: 20),
                                textStyle: const TextStyle(fontSize: 18),
                                foregroundColor:
                                    const Color.fromARGB(255, 255, 255, 255),
                              ),
                              child: const Text('SignUp'),
                            ),
                            const SizedBox(
                              height: 70,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
