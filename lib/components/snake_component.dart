import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class SnakeComponent extends PositionComponent {
  final List<Vector2> segments;
  final double tileSize;
  final Paint _paint = Paint();
  
  SnakeComponent({
    required this.segments,
    required this.tileSize,
  }) : super(size: Vector2(tileSize, tileSize));
  
  @override
  void render(Canvas canvas) {
    for (int i = 0; i < segments.length; i++) {
      final segment = segments[i];
      final isHead = i == 0;
      
      final rect = Rect.fromLTWH(
        segment.x * tileSize,
        segment.y * tileSize,
        tileSize - 2,
        tileSize - 2,
      );
      
      // Gradiente para corpo da cobrinha
      final gradient = LinearGradient(
        colors: isHead 
            ? [Colors.green.shade800, Colors.green.shade600]
            : [Colors.green.shade600, Colors.green.shade400],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
      
      _paint.shader = gradient.createShader(rect);
      _paint.style = PaintingStyle.fill;
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(4)),
        _paint,
      );
      
      // Olhos da cobra
      if (isHead) {
        _paint.shader = null;
        _paint.color = Colors.white;
        canvas.drawCircle(
          Offset(rect.left + 8, rect.top + 8),
          3,
          _paint,
        );
        canvas.drawCircle(
          Offset(rect.right - 8, rect.top + 8),
          3,
          _paint,
        );
        
        _paint.color = Colors.black;
        canvas.drawCircle(
          Offset(rect.left + 7, rect.top + 7),
          1.5,
          _paint,
        );
        canvas.drawCircle(
          Offset(rect.right - 9, rect.top + 7),
          1.5,
          _paint,
        );
      }
    }
  }
}