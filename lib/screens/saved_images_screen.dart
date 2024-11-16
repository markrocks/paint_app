import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'paint_screen.dart';

class SavedImagesScreen extends StatefulWidget {
  const SavedImagesScreen({Key? key}) : super(key: key);

  @override
  _SavedImagesScreenState createState() => _SavedImagesScreenState();
}

class _SavedImagesScreenState extends State<SavedImagesScreen> {
  List<String> _savedImages = [];

  @override
  void initState() {
    super.initState();
    _loadSavedImages();
  }

  Future<void> _loadSavedImages() async {
    // TODO: Load saved images from device storage or camera roll
    setState(() {
      // _savedImages = loaded images
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Image.asset(
            'assets/images/background.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          // Back Button
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // Carousel
          Center(
            child: _savedImages.isEmpty
                ? const Text('No saved images')
                : CarouselSlider(
                    options: CarouselOptions(
                      height: MediaQuery.of(context).size.height * 0.7,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: false,
                      autoPlay: false,
                    ),
                    items: _savedImages.map((imagePath) {
                      return Builder(
                        builder: (BuildContext context) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PaintScreen(),
                                ),
                              );
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Image.file(
                                File(imagePath),
                                fit: BoxFit.contain,
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }
}
