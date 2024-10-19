import 'package:flutter/material.dart';

enum DrawingTool { crayon, pencil, paintbrush }

class ToolPanel extends StatelessWidget {
  final DrawingTool selectedTool;
  final Function(DrawingTool) onToolChanged;

  const ToolPanel({
    Key? key,
    required this.selectedTool,
    required this.onToolChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildToolButton(DrawingTool.pencil, Icons.create, 'Pencil'),
          _buildToolButton(DrawingTool.paintbrush, Icons.brush, 'Paintbrush'),
          _buildToolButton(DrawingTool.crayon, Icons.brush_outlined, 'Crayon'),
        ],
      ),
    );
  }

  Widget _buildToolButton(DrawingTool tool, IconData icon, String tooltip) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        icon: Icon(icon),
        color: selectedTool == tool ? Colors.blue : Colors.black,
        onPressed: () => onToolChanged(tool),
      ),
    );
  }
}
