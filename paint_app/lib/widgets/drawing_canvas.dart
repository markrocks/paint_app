import 'package:flutter/material.dart';
import 'dart:ui';

class DrawingCanvas extends StatefulWidget {
  final Color selectedColor;
  final double strokeWidth;

  const DrawingCanvas({
    Key? key,
    required this.selectedColor,
    required this.strokeWidth,
  }) : super(key: key);

  @override
  _DrawingCanvasState createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawingCanvas> {
  List<DrawingPoint?> drawingPoints = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        setState(() {
          drawingPoints.add(
            DrawingPoint(
              details.localPosition,
              Paint()
                ..color = widget.selectedColor
                ..isAntiAlias = true
                ..strokeWidth = widget.strokeWidth
                ..strokeCap = StrokeCap.round,
            ),
          );
        });
      },
      onPanUpdate: (details) {
        setState(() {
          drawingPoints.add(
            DrawingPoint(
              details.localPosition,
              Paint()
                ..color = widget.selectedColor
                ..isAntiAlias = true
                ..strokeWidth = widget.strokeWidth
                ..strokeCap = StrokeCap.round,
            ),
          );
        });
      },
      onPanEnd: (details) {
        setState(() {
          drawingPoints.add(null);
        });
      },
      child: CustomPaint(
        painter: _DrawingPainter(drawingPoints),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        ),
      ),
    );
  }
}

class _DrawingPainter extends CustomPainter {
  final List<DrawingPoint?> drawingPoints;

  _DrawingPainter(this.drawingPoints);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < drawingPoints.length - 1; i++) {
      if (drawingPoints[i] != null && drawingPoints[i + 1] != null) {
        canvas.drawLine(drawingPoints[i]!.offset, drawingPoints[i + 1]!.offset,
            drawingPoints[i]!.paint);
      } else if (drawingPoints[i] != null && drawingPoints[i + 1] == null) {
        canvas.drawPoints(PointMode.points, [drawingPoints[i]!.offset],
            drawingPoints[i]!.paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class DrawingPoint {
  Offset offset;
  Paint paint;

  DrawingPoint(this.offset, this.paint);
}
