import 'package:flutter/material.dart';
import 'new_templates_screen.dart';
import 'saved_images_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final buttonHeight = screenHeight * 0.8;
    final aspectRatio = 150 / 150; // original width/height ratio
    final buttonWidth = buttonHeight * aspectRatio;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image (if any)
          Image.asset(
            'assets/images/home/home_background.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          // Settings Button
          Positioned(
            top: 40,
            right: 20,
            child: GestureDetector(
              onTap: () {
                // TODO: Implement settings
              },
              child: Image.asset(
                'assets/images/home/Setting_icon_march19@2x.png',
                width: 50,
                height: 50,
              ),
            ),
          ),

          // New and Saved Buttons Container
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // New Button
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NewTemplatesScreen(),
                      ),
                    );
                  },
                  child: Image.asset(
                    'assets/images/home/NewButtonv2_Cropped1@2x.png',
                    width: buttonWidth,
                    height: buttonHeight,
                    fit: BoxFit.contain,
                  ),
                ),

                // Saved Button
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SavedImagesScreen(),
                      ),
                    );
                  },
                  child: Image.asset(
                    'assets/images/home/SavedButtonv2_Cropped1.png',
                    width: buttonWidth,
                    height: buttonHeight,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
