import 'package:flutter/material.dart';
import '../widgets/drawing_canvas.dart';
import '../widgets/tool_panel.dart';
import '../widgets/color_palette.dart';
import '../constants.dart';

class PaintScreen extends StatefulWidget {
  final String? templateImagePath;

  const PaintScreen({
    Key? key,
    this.templateImagePath,
  }) : super(key: key);

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
        return AppConstants.mediumBrushSize;
      case DrawingTool.crayon:
        return AppConstants.smallBrushSize;
      case DrawingTool.paintbrush:
        return AppConstants.smallBrushSize;
      case DrawingTool.marker:
        return AppConstants.smallBrushSize;
      case DrawingTool.pen:
        return AppConstants.smallBrushSize;
      case DrawingTool.waterColor:
        return AppConstants.smallBrushSize;
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
      case DrawingTool.marker:
        return AppConstants.markerOpacity;
      case DrawingTool.pen:
        return AppConstants.penOpacity;
      case DrawingTool.waterColor:
        return AppConstants.waterColorOpacity;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final sidebarWidth = screenWidth / 6;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Image.asset(
            'assets/images/background.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          // Template Image if provided
          if (widget.templateImagePath != null)
            Positioned.fill(
              child: Image.asset(
                widget.templateImagePath!,
                fit: BoxFit.contain,
              ),
            ),

          // Main Content
          Row(
            children: [
              // Left Sidebar
              Container(
                width: sidebarWidth,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/Side_banner.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ToolPanel(
                                selectedTool: selectedTool,
                                onToolChanged: (tool) {
                                  setState(() {
                                    selectedTool = tool;
                                  });
                                },
                              ),
                              ColorPalette(
                                selectedColor: selectedColor,
                                onColorChanged: (color) {
                                  setState(() {
                                    selectedColor = color;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Drawing Canvas
              Expanded(
                child: DrawingCanvas(
                  selectedColor: selectedColor,
                  strokeWidth: getStrokeWidth(selectedTool),
                  opacity: getStrokeOpacity(selectedTool),
                  blendMode: selectedBlendMode,
                  drawingTool: selectedTool,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
