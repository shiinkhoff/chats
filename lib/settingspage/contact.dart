import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final List<Map<String, dynamic>> friends = [
    {'initial': 'A', 'name': 'asta', 'image': true, 'checked': false},
    {'initial': 'A', 'name': 'azizi', 'image': false, 'checked': false},
    {'initial': 'B', 'name': 'ben', 'image': true, 'checked': false},
    {'initial': 'B', 'name': 'buket', 'image': false, 'checked': false},
    {'initial': 'C', 'name': 'chopperr', 'image': true, 'checked': false},
    {'initial': 'C', 'name': 'crizzyy', 'image': false, 'checked': false},
    {'initial': 'L', 'name': 'luffy', 'image': true, 'checked': false},
    {'initial': 'L', 'name': 'Lzyy', 'image': false, 'checked': false},
    {'initial': 'M', 'name': 'madara', 'image': true, 'checked': false},
    {'initial': 'M', 'name': 'mikasa', 'image': false, 'checked': false},
    {'initial': 'N', 'name': 'nami', 'image': true, 'checked': false},
    {'initial': 'N', 'name': 'nerandra', 'image': false, 'checked': false},
    {'initial': 'R', 'name': 'roronoa', 'image': true, 'checked': false},
    {'initial': 'R', 'name': 'roshi', 'image': false, 'checked': false},
  ];

  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredFriends = friends
        .where((friend) =>
            friend['name'].toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 0.0),
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
                'Contact',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search name',
                    border: InputBorder.none,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.asset(
                        'images/search.png',
                        width: 20,
                        height: 20,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filteredFriends.length,
                itemBuilder: (context, index) {
                  final friend = filteredFriends[index];
                  bool isHeader = index == 0 ||
                      filteredFriends[index - 1]['initial'] !=
                          friend['initial'];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isHeader)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Text(
                            friend['initial'],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      if (isHeader)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: filteredFriends
                                  .where(
                                      (f) => f['initial'] == friend['initial'])
                                  .map((f) {
                                bool isLastName = f ==
                                    filteredFriends.lastWhere(
                                        (x) => x['initial'] == f['initial']);
                                return Column(
                                  children: [
                                    ListTile(
                                      leading: SizedBox(
                                        width: 24.15,
                                        height: 23.91,
                                        child: f['image']
                                            ? Image.asset(
                                                'images/asta.png',
                                                fit: BoxFit.cover,
                                              )
                                            : Image.asset(
                                                'images/litch.png',
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                      title: Text(
                                        f['name'],
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                    if (!isLastName)
                                      const Divider(
                                        color: Colors.grey,
                                        height: 1,
                                      ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
