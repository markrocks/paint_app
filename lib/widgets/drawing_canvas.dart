import 'dart:math';
import 'package:vector_math/vector_math.dart';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;
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
  List<List<DrawingPoint>> drawingStrokes = [];
  late _DrawingPainter _painter;
  GlobalKey _customPaintKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _painter = _DrawingPainter(drawingStrokes);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        setState(() {
          drawingStrokes.add([
            DrawingPoint(
              details.localPosition,
              _getPaint(),
              widget.drawingTool,
              _getPaintAlt(),
              _getRadiusValue(),
              colorAlt: widget.selectedColor
                  .withOpacity(0.4 + Random().nextDouble() * 0.2),
              offsetAlt: details.localPosition,
            ),
          ]);
        });
        _forceRepaint();
      },
      onPanUpdate: (details) {
        setState(() {
          drawingStrokes.last.add(
            DrawingPoint(
              details.localPosition,
              _getPaint(),
              widget.drawingTool,
              _getPaintAlt(),
              _getRadiusValue(),
              colorAlt: widget.selectedColor
                  .withOpacity(0.4 + Random().nextDouble() * 0.2),
              offsetAlt: details.localPosition,
            ),
          );
        });
        _forceRepaint();
      },
      onPanEnd: (details) {
        _updateCachedImage();
      },
      child: RepaintBoundary(
        key: _customPaintKey,
        child: CustomPaint(
          painter: _painter,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
        ),
      ),
    );
  }

  Future<void> _updateCachedImage() async {
    final size = MediaQuery.of(context).size;
    await _painter.updateCachedImage(size);
    setState(() {});
  }

  void _forceRepaint() {
    _customPaintKey.currentContext?.findRenderObject()?.markNeedsPaint();
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

  double _getRadiusValue() {
    return (widget.strokeWidth - 20) + Random().nextDouble() * 40;
  }

  Offset _getAltOffset(Offset offset, Paint paint) {
    // Change parameters to take a single Offset
    var xRandom =
        offset.dx + (Random().nextDouble() - 0.5) * paint.strokeWidth * 1.2;
    var yRandom =
        offset.dy + (Random().nextDouble() - 0.5) * paint.strokeWidth * 1.2;
    return Offset(xRandom, yRandom);
  }
}

/// A custom painter for drawing on the canvas.
class _DrawingPainter extends CustomPainter {
  final List<List<DrawingPoint>> drawingStrokes;
  ui.Image? _cachedImage;
  // Map to store random positions for each pair of points
  final Map<String, List<Offset>> _randomPositionsCache = {};

  /// Creates a new instance of [_DrawingPainter] with the given points.
  _DrawingPainter(this.drawingStrokes);

  @override
  void paint(Canvas canvas, Size size) {
    if (_cachedImage != null) {
      canvas.drawImage(_cachedImage!, Offset.zero, Paint());
    }
    _drawStroke(canvas, drawingStrokes.last, size);
  }

  void _drawStroke(Canvas canvas, List<DrawingPoint> stroke, Size size) {
    if (stroke.isEmpty) return;

    for (int i = 0; i < stroke.length - 1; i++) {
      switch (stroke[i].tool) {
        case DrawingTool.crayon:
          _drawCrayon(canvas, stroke[i], stroke[i + 1], size);
          break;
        case DrawingTool.pencil:
          _drawPencil(canvas, stroke[i], stroke[i + 1]);
          break;
        case DrawingTool.paintbrush:
          _drawPaintbrush(canvas, stroke[i], stroke[i + 1]);
          break;
        case DrawingTool.marker:
          _drawMarker(canvas, stroke[i], stroke[i + 1]);
          break;
        case DrawingTool.pen:
          _drawPen(canvas, stroke[i], stroke[i + 1]);
          break;
        case DrawingTool.waterColor:
          _drawWaterColor(canvas, stroke[i], stroke[i + 1]);
          break;
      }
    }
  }

  Future<void> updateCachedImage(Size size) async {
    if (drawingStrokes.isEmpty) return;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // If there's a previous cached image, draw it first
    if (_cachedImage != null) {
      canvas.drawImage(_cachedImage!, Offset.zero, Paint());
    }

    // Draw only the last stroke
    _drawStroke(canvas, drawingStrokes.last, size);

    final picture = recorder.endRecording();
    _cachedImage =
        await picture.toImage(size.width.toInt(), size.height.toInt());
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
    paint.style = PaintingStyle.fill;
    p1.colorAlt ??= paint.color.withOpacity(0.4 + Random().nextDouble() * 0.2);
    paint.color = p1.colorAlt!;

    String pointPairKey = _getPointPairKey(p1, p2);

    // Use cached positions if they exist, otherwise calculate new ones
    List<Offset> randomPositions;
    if (_randomPositionsCache.containsKey(pointPairKey)) {
      randomPositions = _randomPositionsCache[pointPairKey]!;
    } else {
      var length = (sqrt(pow(p2.offset.dx - p1.offset.dx, 2) +
                  pow(p2.offset.dy - p1.offset.dy, 2)) /
              (5 / paint.strokeWidth))
          .round();
      var xUnit = (p2.offset.dx - p1.offset.dx) / length;
      var yUnit = (p2.offset.dy - p1.offset.dy) / length;

      // Calculate and store all random positions
      randomPositions = [];
      for (var i = 0; i < length; i++) {
        var xCurrent = p1.offset.dx + (i * xUnit);
        var yCurrent = p1.offset.dy + (i * yUnit);
        var xRandom =
            xCurrent + (Random().nextDouble() - 0.5) * paint.strokeWidth * 1.2;
        var yRandom =
            yCurrent + (Random().nextDouble() - 0.5) * paint.strokeWidth * 1.2;
        randomPositions.add(Offset(xRandom, yRandom));
      }

      // Cache the calculated positions
      _randomPositionsCache[pointPairKey] = randomPositions;
    }

    // Draw circles using the stored random positions
    for (var position in randomPositions) {
      canvas.drawCircle(position, paint.strokeWidth / 2, paint);
    }
  }

  /// Draws a custom shape for the crayon tool.
  void _drawCrayon(Canvas canvas, DrawingPoint p1, DrawingPoint p2, Size size) {
    // final center = Offset(size.width / 2, size.height / 2);
    var paint = p1.paint;
    // var paint2 = p1.paintAlt;
    var circleWidth = AppConstants.largeBrushSize / 2;
    developer.log('log me', name: 'my.app.category');
    developer.log('log me $circleWidth', name: 'my.app.category');
    var vertices = createVertices(p2.offset, circleWidth * 2);
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
  ui.Vertices createVertices(Offset center, double radius) {
    var vertexPoints = <Offset>[];
    var maxRadians = radians(360); //2 * pi;
    var degreStepInRadians = radians(45);
    vertexPoints.add(center);

    for (double i = 0; i < maxRadians; i += degreStepInRadians) {
      ///TODO UPDATE THIS TO PASS A LIST OF FIXED RANDOM OFFSETS
      // // random value between radius - 20 and radius + 20
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
        ui.Vertices(VertexMode.triangles, vertexPoints, indices: indices);
    return positionedVertices;
  }

  // Generate a unique key for each pair of points
  String _getPointPairKey(DrawingPoint p1, DrawingPoint p2) {
    return '${p1.offset.dx},${p1.offset.dy}-${p2.offset.dx},${p2.offset.dy}';
  }

  /// Draws a line for the marker tool with a flat cap and semi-transparent color.
  void _drawMarker(Canvas canvas, DrawingPoint p1, DrawingPoint p2) {
    final paint = p1.paint;
    paint.style = PaintingStyle.stroke;
    paint.strokeCap = StrokeCap.square; // Flat end for marker-like appearance
    paint.strokeJoin = StrokeJoin.round;
    paint.color = paint.color.withOpacity(0.7); // Semi-transparent
    canvas.drawLine(p1.offset, p2.offset, paint);
  }

  /// Draws a thin, precise line for the pen tool.
  void _drawPen(Canvas canvas, DrawingPoint p1, DrawingPoint p2) {
    final paint = p1.paint;
    paint.style = PaintingStyle.stroke;
    paint.strokeCap = StrokeCap.round;
    paint.strokeJoin = StrokeJoin.round;
    paint.strokeWidth = paint.strokeWidth * 0.5; // Thinner line for pen
    canvas.drawLine(p1.offset, p2.offset, paint);
  }

  /// Draws a watercolor-like effect with varying opacity.
  void _drawWaterColor(Canvas canvas, DrawingPoint p1, DrawingPoint p2) {
    final paint = p1.paint;
    paint.style = PaintingStyle.stroke;
    paint.strokeCap = StrokeCap.round;
    paint.color = paint.color.withOpacity(0.2); // Very transparent

    // Draw multiple overlapping lines with slight offsets
    for (int i = 0; i < 3; i++) {
      var offset = (i - 1) * 2.0;
      var p1Offset = p1.offset + Offset(offset, offset);
      var p2Offset = p2.offset + Offset(offset, offset);
      canvas.drawLine(p1Offset, p2Offset, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Represents a point on the canvas with its drawing properties.
class DrawingPoint {
  Offset offset;
  Offset? offsetAlt;
  Paint paint;
  Paint paintAlt;
  Color? colorAlt;
  double? radiusOffset;
  DrawingTool tool;

  /// Creates a new instance of [DrawingPoint] with the given properties.
  DrawingPoint(
    this.offset,
    this.paint,
    this.tool,
    this.paintAlt,
    this.radiusOffset, {
    this.colorAlt,
    this.offsetAlt,
  });
}
