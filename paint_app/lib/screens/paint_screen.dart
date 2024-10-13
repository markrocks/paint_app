import 'package:flutter/material.dart';
import '../widgets/color_palette.dart';
import '../widgets/tool_panel.dart';
import '../widgets/drawing_canvas.dart';

class PaintScreen extends StatefulWidget {
  const PaintScreen({Key? key}) : super(key: key);

  @override
  _PaintScreenState createState() => _PaintScreenState();
}

class _PaintScreenState extends State<PaintScreen> {
  Color selectedColor = Colors.black;
  double strokeWidth = 2.0;

  void changeColor(Color color) {
    setState(() {
      selectedColor = color;
    });
  }

  void changeStrokeWidth(double width) {
    setState(() {
      strokeWidth = width;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paint')),
      body: Row(
        children: [
          ColorPalette(onColorSelected: changeColor),
          Expanded(
            child: Stack(
              children: [
                DrawingCanvas(
                  selectedColor: selectedColor,
                  strokeWidth: strokeWidth,
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: ToolPanel(onToolSelected: changeStrokeWidth),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
