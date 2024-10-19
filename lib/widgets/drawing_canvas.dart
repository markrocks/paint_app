import 'dart:math';
import 'package:vector_math/vector_math.dart';

import 'package:flutter/material.dart';
import 'dart:ui';
import 'tool_panel.dart';
import '../constants.dart';
import 'dart:developer' as developer;

/// A StatefulWidget that represents a canvas for drawing.
class DrawingCanvas extends StatefulWidget {
  final Color selectedColor;
  final double strokeWidth;
  final double opacity;
  final BlendMode blendMode;
  final DrawingTool drawingTool;

  /// Creates a new instance of [DrawingCanvas] with the given properties.
  const DrawingCanvas({
    Key? key,
    required this.selectedColor,
    required this.strokeWidth,
    required this.opacity,
    required this.blendMode,
    required this.drawingTool,
  }) : super(key: key);

  @override
  _DrawingCanvasState createState() => _DrawingCanvasState();
}

/// The state of the [DrawingCanvas] widget.
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
              _getPaint(),
              widget.drawingTool,
              _getPaintAlt(),
            ),
          );
        });
      },
      onPanUpdate: (details) {
        setState(() {
          drawingPoints.add(
            DrawingPoint(
              details.localPosition,
              _getPaint(),
              widget.drawingTool,
              _getPaintAlt(),
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

  /// Returns a [Paint] object configured for drawing.
  Paint _getPaint() {
    final paint = Paint()
      ..color = widget.selectedColor.withOpacity(widget.opacity)
      ..isAntiAlias = true
      ..strokeWidth = widget.strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill
      ..blendMode = widget.blendMode;
    return paint;
  }

  /// Returns a [Paint] object configured for drawing with an alternate style.
  Paint _getPaintAlt() {
    final paint = Paint()
      ..color = widget.selectedColor.withOpacity(widget.opacity)
      ..isAntiAlias = true
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..blendMode = widget.blendMode;
    return paint;
  }
}

/// A custom painter for drawing on the canvas.
class _DrawingPainter extends CustomPainter {
  final List<DrawingPoint?> drawingPoints;

  /// Creates a new instance of [_DrawingPainter] with the given points.
  _DrawingPainter(this.drawingPoints);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < drawingPoints.length - 1; i++) {
      if (drawingPoints[i] != null && drawingPoints[i + 1] != null) {
        switch (drawingPoints[i]!.tool) {
          case DrawingTool.crayon:
            _drawCrayon(canvas, drawingPoints[i]!, drawingPoints[i + 1]!, size);
            break;
          case DrawingTool.pencil:
            _drawPencil(canvas, drawingPoints[i]!, drawingPoints[i + 1]!);
            break;
          case DrawingTool.paintbrush:
            _drawPaintbrush(canvas, drawingPoints[i]!, drawingPoints[i + 1]!);
            break;
        }
      }
    }
  }

  /// Draws a line for the pencil tool.
  void _drawPencil(Canvas canvas, DrawingPoint p1, DrawingPoint p2) {
    final paint = p1.paint;
    paint.style = PaintingStyle.stroke;
    canvas.drawLine(p1.offset, p2.offset, paint);
  }

  /// Draws a circle for the paintbrush tool.
  void _drawPaintbrush(Canvas canvas, DrawingPoint p1, DrawingPoint p2) {
    final paint = p1.paint;
    // paint.style = PaintingStyle.stroke;
    // canvas.drawLine(p1.offset, p2.offset, paint);
    canvas.drawCircle(p2.offset, paint.strokeWidth / 2, paint);
  }

  /// Draws a custom shape for the crayon tool.
  void _drawCrayon(Canvas canvas, DrawingPoint p1, DrawingPoint p2, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    var paint = p1.paint;
    var paint2 = p1.paintAlt;
    var circleWidth = AppConstants.largeBrushSize / 2;
    developer.log('log me', name: 'my.app.category');
    developer.log('log me $circleWidth', name: 'my.app.category');
    var vertices = createVertices(center, circleWidth * 2);
    canvas.drawVertices(vertices, BlendMode.srcIn, paint);

    //`
    // paint.style = PaintingStyle.stroke;
    // canvas.drawLine(p1.offset, p2.offset, paint);
    // canvas.drawCircle(p1.offset, circleWidth, paint);
    // canvas.drawCircle(p1.offset, circleWidth, paint2);
    //
    for (int i = 0; i < 6; i++) {
      circleWidth -= 1; // Reduce circleWidth by 1 each iteration
      // canvas.drawCircle(p1.offset, circleWidth, paint2);
    }
  }

  /// Creates vertices for drawing a custom shape.
  Vertices createVertices(Offset center, double radius) {
    var vertexPoints = <Offset>[];
    var maxRadians = radians(360); //2 * pi;
    var degreStepInRadians = radians(30);
    vertexPoints.add(center);

    for (double i = 0; i < maxRadians; i += degreStepInRadians) {
      vertexPoints.add(center + Offset(radius * cos(i), radius * sin(i)));
    }

    var indices = <int>[];
    for (int i = 1; i < vertexPoints.length; i++) {
      indices.add(0);
      indices.add(i);
      if (i == (vertexPoints.length - 1)) {
        indices.add(1);
      } else {
        indices.add(i + 1);
      }
    }
    var positionedVertices =
        Vertices(VertexMode.triangles, vertexPoints, indices: indices);
    return positionedVertices;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Represents a point on the canvas with its drawing properties.
class DrawingPoint {
  Offset offset;
  Paint paint;
  Paint paintAlt;
  DrawingTool tool;

  /// Creates a new instance of [DrawingPoint] with the given properties.
  DrawingPoint(this.offset, this.paint, this.tool, this.paintAlt);
}
