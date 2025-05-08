import 'package:chatdansosmed/settingspage/privasi%20dan%20security/cf&hide.dart';
import 'package:flutter/material.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({super.key});

  @override
  _StatusPageState createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  String? _selectedOption; // Menyimpan pilihan yang dipilih

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context, {
                    'status': _selectedOption,
                  });
                },
                child: Image.asset(
                  'images/back.png',
                  width: 22,
                  height: 22,
                ),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'Status Privacy',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 45),
              const Text(
                'Who can see my status updates on Tatalk?',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    _buildOptionTile('My contact', showEdit: false),
                    const Divider(height: 1),
                    _buildOptionTile('Close friends'),
                    const Divider(height: 1),
                    _buildOptionTile('Hide from...'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionTile(String title, {bool showEdit = true}) {
    bool isSelected = _selectedOption == title; // Cek apakah pilihan dipilih

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedOption = title; // Set pilihan yang dipilih
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        color: Colors.white, // Background putih
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 14), // Ukuran font 14
            ),
            Row(
              children: [
                if (isSelected) // Tampilkan ikon ceklis jika dipilih
                  const Icon(Icons.check, color: Colors.orange), // Ikon ceklis
                if (showEdit) // Tampilkan "Edit" hanya jika showEdit true
                  GestureDetector(
                    onTap: () {
                      // Navigasi ke halaman yang sesuai berdasarkan judul
                      if (title == 'Close friends') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CloseFriendsScreen()),
                        );
                      } else if (title == 'Hide from...') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HideStatus()),
                        );
                      }
                    },
                    child: const Text(
                      'Edit', // Teks "Edit"
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.orange, // Warna teks "Edit"
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
