
import 'package:chatdansosmed/homepage/home.dart';
import 'package:flutter/material.dart';

class call extends StatelessWidget {
  final double fontSize;
  final double iconSize;
  final double containerHeight;
  final double containerWidth;
  final Color containerColor;
  final double backIconSize;

  const call({
    super.key,
    this.fontSize = 28,
    this.iconSize = 45,
    this.containerHeight = 125,
    this.containerWidth = double.infinity,
    this.containerColor = const Color(0xFFC6C2C2),
    this.backIconSize = 35,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFd9d9d9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFd9d9d9),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: IconButton(
            icon: Image.asset('images/back.png'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 0),
          const Text(
            'asta',
            style: TextStyle(
              color: Colors.black,
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 0),
          Text(
            'Ringging',
            style: TextStyle(
              color: Colors.black,
              fontSize: fontSize * 0.57,
            ),
          ),
          SizedBox(
            width: 50,
            height: 50,
          ),
          Image.asset('images/imagesasta.png'),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(0),
            child: Container(
              width: containerWidth,
              height: containerHeight,
              padding: const EdgeInsets.symmetric(horizontal: 0),
              decoration: BoxDecoration(
                color: containerColor,
                borderRadius: const BorderRadius.all(Radius.circular(30)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 45,
                    height: 5,
                    decoration: const BoxDecoration(
                      color: Color(0xFFC6C2C2),
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/volume.png',
                          width: 45,
                          height: 45,
                        ),
                        const SizedBox(width: 40),
                        Image.asset(
                          'images/vidcall2.png',
                          width: 50,
                          height: 50,
                        ),
                        const SizedBox(width: 40),
                        Image.asset(
                          'images/mute.png',
                          width: 40,
                          height: 40,
                        ),
                        const SizedBox(width: 40),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()),
                            );
                          },
                          child: Image.asset(
                            'images/endcall.png',
                            width: 60,
                            height: 60,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
