import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import '../models/thread.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.100.224:8000/api';

  static Future<bool> createThread(int userId, String content) async {
    final response = await http.post(
      Uri.parse('$baseUrl/threads'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId, 'content': content}),
    );

    return response.statusCode == 201 || response.statusCode == 200;
  }

  static Future<List<Thread>> fetchThreads() async {
    final response = await http.get(Uri.parse('$baseUrl/threads'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((e) => Thread.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat data threads');
    }
  }

  static Future<bool> registerUserToLaravel({
    required String name,
    required String username,
    required String email,
    required String noHp,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'username': username,
        'email': email,
        'no_hp': noHp,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final int laravelId =
          data['data']['id']; // Ambil ID dari response Laravel

      // Simpan laravel_id ke Firestore
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'laravel_id': laravelId, // Simpan ID Laravel ke Firestore
        });
      }

      return true;
    } else {
      print('Error Register Laravel: ${response.body}');
      return false;
    }
  }
}
