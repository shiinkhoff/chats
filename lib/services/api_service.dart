import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/thread.dart';
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.204.222:8000/api';

  Future<void> saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', userId);
  }

  static Future<List<Thread>> fetchThreads() async {
    final response = await http.get(Uri.parse('$baseUrl/threads'));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);

      List<Thread> threads = data.map((json) => Thread.fromJson(json)).toList();

      // Urutkan dari yang terbaru ke yang lama
      threads.sort((a, b) =>
          DateTime.parse(b.createdAt!).compareTo(DateTime.parse(a.createdAt!)));

      return threads;
    } else {
      throw Exception('Failed to load threads');
    }
  }

  static Future<bool> createThread(String userId, String content,
      [File? image]) async {
    var uri = Uri.parse('$baseUrl/threads');
    var request = http.MultipartRequest('POST', uri);
    request.fields['user_id'] = userId;
    request.fields['content'] = content;

    if (image != null) {
      var stream = http.ByteStream(image.openRead());
      var length = await image.length();
      var multipartFile = http.MultipartFile(
        'gambar',
        stream,
        length,
        filename: basename(image.path),
        contentType: MediaType('image', 'jpeg'), // Ganti jika bukan jpeg
      );
      request.files.add(multipartFile);
    }

    var response = await request.send();
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      final respStr = await response.stream.bytesToString();
      print('Failed to post thread: ${response.statusCode}');
      print('Response body: $respStr'); // ← Tambahkan ini untuk debug

      return false;
    }
  }

  static Future<bool> registerUserToLaravel(
      {required String name,
      required String username,
      required String email,
      required String noHp,
      required String password}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'username': username,
        'email': email,
        'no_hp': noHp,
        'password': password
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final String laravelId =
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
