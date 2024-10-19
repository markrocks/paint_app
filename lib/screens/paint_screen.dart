import 'package:flutter/material.dart';
import '../widgets/drawing_canvas.dart';
import '../widgets/tool_panel.dart';
import '../widgets/color_palette.dart';
import '../constants.dart';

class PaintScreen extends StatefulWidget {
  const PaintScreen({Key? key}) : super(key: key);

  @override
  _PaintScreenState createState() => _PaintScreenState();
}

class _PaintScreenState extends State<PaintScreen> {
  Color selectedColor = Colors.black;
  DrawingTool selectedTool = DrawingTool.pencil;
  BlendMode selectedBlendMode = BlendMode.srcOver;

  double getStrokeWidth(DrawingTool tool) {
    switch (tool) {
      case DrawingTool.pencil:
        return AppConstants.smallBrushSize;
      case DrawingTool.crayon:
        return AppConstants.largeBrushSize;
      case DrawingTool.paintbrush:
        return AppConstants.mediumBrushSize;
    }
  }

  double getStrokeOpacity(DrawingTool tool) {
    switch (tool) {
      case DrawingTool.pencil:
        return AppConstants.defaultOpacity;
      case DrawingTool.crayon:
        return AppConstants.crayonOpacity;
      case DrawingTool.paintbrush:
        return AppConstants.paintbrushOpacity;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Paint App'),
      ),
      body: Column(
        children: [
          Expanded(
            child: DrawingCanvas(
              selectedColor: selectedColor,
              strokeWidth: getStrokeWidth(selectedTool),
              opacity: getStrokeOpacity(selectedTool),
              blendMode: selectedBlendMode,
              drawingTool: selectedTool,
            ),
          ),
          ColorPalette(
            selectedColor: selectedColor,
            onColorChanged: (color) {
              setState(() {
                selectedColor = color;
              });
            },
          ),
          ToolPanel(
            selectedTool: selectedTool,
            onToolChanged: (tool) {
              setState(() {
                selectedTool = tool;
              });
            },
          ),
        ],
      ),
    );
  }
}
