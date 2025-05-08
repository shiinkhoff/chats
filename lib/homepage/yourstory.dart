import 'package:chatdansosmed/homepage/except.dart';
import 'package:chatdansosmed/homepage/home.dart';
import 'package:chatdansosmed/homepage/only.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _controller;
  late List<CameraDescription> _cameras;
  bool _isFlashOn = false;
  bool _isCameraFront = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      _controller = CameraController(
        _cameras[_isCameraFront ? 1 : 1],
        ResolutionPreset.medium,
      );
      await _controller.initialize();
      setState(() {});
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  Future<void> _openGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DisplayPictureScreen(imagePath: image.path),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image.asset(
            'images/x2.png',
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isFlashOn = !_isFlashOn;
                _controller.setFlashMode(
                  _isFlashOn ? FlashMode.torch : FlashMode.off,
                );
              });
            },
            icon: Icon(
              _isFlashOn ? Icons.flash_on : Icons.flash_off,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
          ),
          _controller.value.isInitialized
              ? CameraPreview(_controller)
              : const Center(child: CircularProgressIndicator()),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: _openGallery,
                        icon: Image.asset('images/galeri.png'),
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () async {
                          try {
                            final XFile picture =
                                await _controller.takePicture();
                            final String imagePath = picture.path;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DisplayPictureScreen(imagePath: imagePath),
                              ),
                            );
                          } catch (e) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Error'),
                                  content: Text('Failed to take picture: $e'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        icon: Image.asset('images/tombol.png'),
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Video'),
                          SizedBox(width: 8),
                          Text(
                            'Foto',
                            style: TextStyle(color: Colors.orange),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _isCameraFront = !_isCameraFront;
                            _controller = CameraController(
                              _cameras[_isCameraFront ? 1 : 0],
                              ResolutionPreset.medium,
                            );
                            _controller.initialize().then((_) {
                              if (!mounted) return;
                              setState(() {});
                            });
                          });
                        },
                        icon: Image.asset('images/repeat.png'),
                      ),
                      const SizedBox(height: 4),
                    ],
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

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
          ),
          Center(
            child: Image.file(File(imagePath)),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                color: Colors.black.withOpacity(0.7),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.7),
                    hintText: 'Add a caption...',
                    hintStyle: const TextStyle(color: Colors.white54),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        _showPrivacyOptions(context);
                      },
                      icon: Image.asset(
                        'images/+.png',
                        width: 25,
                        height: 25,
                      ),
                      label: const Text(
                        'Status(33 Excluded)',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('Post',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Positioned(
            top: 40,
            right: 10,
            child: Column(
              children: [
                IconButton(
                  icon: Image.asset('images/musicc.png', width: 25, height: 25),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  splashRadius: 20,
                  color: Colors.transparent,
                ),
                const SizedBox(height: 10),
                IconButton(
                  icon: Image.asset('images/txt.png', width: 25, height: 25),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  splashRadius: 20,
                  color: Colors.transparent,
                ),
                const SizedBox(height: 10),
                IconButton(
                  icon: Image.asset('images/emoji.png', width: 25, height: 25),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  splashRadius: 20,
                  color: Colors.transparent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPrivacyOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Who can see my story?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Positioned(
                    top: 40,
                    right: 50,
                    child: IconButton(
                      icon: Image.asset('images/x.png', width: 25, height: 25),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      padding: EdgeInsets.zero,
                      splashRadius: 20,
                      color: Colors.transparent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('My contacts'),
                subtitle: const Text('All your contacts'),
                trailing: Image.asset('images/yes.png'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('My contacts except'),
                subtitle: const Text('All your contacts'),
                trailing: TextButton(
                  onPressed: () {
                    print('click');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const except(),
                      ),
                    );
                  },
                  child: const Text(
                    'Edit',
                    style: TextStyle(
                      color: Color(0xffFA956A),
                    ),
                  ),
                ),
                onTap: () {},
              ),
              ListTile(
                title: const Text('Only share with'),
                subtitle: const Text('All your contacts'),
                trailing: TextButton(
                  onPressed: () {
                    print('click');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const only(),
                      ),
                    );
                  },
                  child: const Text(
                    'Edit',
                    style: TextStyle(
                      color: Color(0xffFA956A),
                    ),
                  ),
                ),
                onTap: () {},
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.orange,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Done',
                  style: TextStyle(
                    color: Color(0xffffffff),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
