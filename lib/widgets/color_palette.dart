import 'package:flutter/material.dart';

class ColorPalette extends StatelessWidget {
  final Color selectedColor;
  final Function(Color) onColorChanged;
  final Map<Color, String> colorImages;
  final double aspectRatio = 79 / 27;

  ColorPalette({
    Key? key,
    required this.selectedColor,
    required this.onColorChanged,
  })  : colorImages = {
          Colors.red: 'red',
          Colors.pink: 'pink',
          Colors.purple: 'purple',
          Colors.blue: 'blue',
          Colors.green: 'green',
          Colors.yellow: 'yellow',
          Colors.orange: 'orange',
          Colors.brown: 'brown',
          Colors.grey: 'grey',
          Colors.white: 'white',
          Colors.black: 'black',
        },
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final containerWidth = constraints.maxWidth * 0.7;
        return Container(
          width: containerWidth,
          height: 289,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/White_behind_colors.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Stack(
            children: _buildOverlappingButtons(containerWidth),
          ),
        );
      },
    );
  }

  List<Widget> _buildOverlappingButtons(double containerWidth) {
    final buttonWidth = containerWidth * 0.95;
    final buttonHeight = buttonWidth / aspectRatio;
    final List<Widget> buttons = [];
    int index = 0;

    for (var entry in colorImages.entries) {
      buttons.add(
        Positioned(
          top: index * (buttonHeight - 3), // Overlap by 3 pixels
          child: _buildColorButton(entry.key, entry.value, containerWidth),
        ),
      );
      index++;
    }

    return buttons;
  }

  Widget _buildColorButton(Color color, String imageName, double parentWidth) {
    final buttonWidth = parentWidth * 0.95;
    final buttonHeight = buttonWidth / aspectRatio;

    return Container(
      width: buttonWidth,
      height: buttonHeight,
      decoration: BoxDecoration(
        border: Border.all(
          color: selectedColor == color ? Colors.blue : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          if (selectedColor == color)
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 4,
            ),
        ],
      ),
      child: GestureDetector(
        onTap: () => onColorChanged(color),
        child: Image.asset(
          'assets/images/colors/$imageName.png',
          fit: BoxFit.fill,
          alignment: Alignment.centerLeft,
        ),
      ),
    );
  }
}
