import 'package:flutter/material.dart';

class ToolPanel extends StatelessWidget {
  final Function(double) onToolSelected;

  const ToolPanel({Key? key, required this.onToolSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.grey[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => onToolSelected(2.0),
            tooltip: 'Pencil',
          ),
          IconButton(
            icon: const Icon(Icons.brush),
            onPressed: () => onToolSelected(10.0),
            tooltip: 'Paintbrush',
          ),
          IconButton(
            icon: const Icon(Icons.format_paint),
            onPressed: () => onToolSelected(20.0),
            tooltip: 'Crayon',
          ),
        ],
      ),
    );
  }
}
