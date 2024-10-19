import 'package:flutter/material.dart';
import '../constants.dart';

class ColorPalette extends StatelessWidget {
  final Color selectedColor;
  final Function(Color) onColorChanged;

  const ColorPalette({
    Key? key,
    required this.selectedColor,
    required this.onColorChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: AppConstants.defaultColors.map((color) {
          return ColorButton(
            color: color,
            isSelected: selectedColor == color,
            onTap: onColorChanged,
          );
        }).toList(),
      ),
    );
  }
}

class ColorButton extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final Function(Color) onTap;

  const ColorButton({
    Key? key,
    required this.color,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(color),
      child: Container(
        margin: const EdgeInsets.all(8),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.white : Colors.black,
            width: 3,
          ),
        ),
      ),
    );
  }
}
