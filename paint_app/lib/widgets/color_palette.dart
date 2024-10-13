import 'package:flutter/material.dart';

class ColorPalette extends StatelessWidget {
  final Function(Color) onColorSelected;

  const ColorPalette({Key? key, required this.onColorSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Color> colors = [
      Colors.black,
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
      Colors.brown,
    ];

    return Container(
      width: 50,
      color: Colors.grey[200],
      child: ListView.builder(
        itemCount: colors.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => onColorSelected(colors[index]),
            child: Container(
              height: 50,
              color: colors[index],
            ),
          );
        },
      ),
    );
  }
}
