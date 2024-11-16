import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'paint_screen.dart';

class NewTemplatesScreen extends StatefulWidget {
  const NewTemplatesScreen({Key? key}) : super(key: key);

  @override
  _NewTemplatesScreenState createState() => _NewTemplatesScreenState();
}

class _NewTemplatesScreenState extends State<NewTemplatesScreen> {
  List<String> templateImages = [];

  @override
  void initState() {
    super.initState();
    _loadTemplateImages();
  }

  Future<void> _loadTemplateImages() async {
    try {
      // Load the asset manifest
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);

      // Filter for images in the new directory
      final imagePaths = manifestMap.keys
          .where((String key) => key.contains('assets/images/new/'))
          .toList();

      setState(() {
        templateImages = imagePaths;
      });
    } catch (e) {
      print('Error loading template images: $e');
    }
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
            child: CarouselSlider(
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height * 0.7,
                enlargeCenterPage: true,
                enableInfiniteScroll: true,
                autoPlay: false,
              ),
              items: templateImages.map((imagePath) {
                return Builder(
                  builder: (BuildContext context) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaintScreen(
                              templateImagePath: imagePath,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Image.asset(
                          imagePath,
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
