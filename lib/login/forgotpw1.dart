import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Image.asset(
                  'images/back.png',
                  width: 22,
                  height: 22,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Forgot Password',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 50),
            const Text(
              'Email',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: 400,
              height: 40,
              child: TextField(
                controller: _emailController,
                style: const TextStyle(fontSize: 12),
                decoration: InputDecoration(
                  fillColor: const Color(0xFFE6E6E6),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "Enter your email",
                ),
              ),
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () async {
                        _sendPasswordResetEmail(context);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(
                      color: Colors.grey[300]!,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 18.0),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Send Reset Link',
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Mengirim email untuk reset password
  Future<void> _sendPasswordResetEmail(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final email = _emailController.text.trim();
      if (email.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter your email address')),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      // Tampilkan notifikasi bahwa email telah dikirim
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset email sent')),
      );

      // Kembali ke halaman login setelah email dikirim
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }
}
