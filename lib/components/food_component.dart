import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class FoodComponent extends PositionComponent {
  final double tileSize;
  final Paint _paint = Paint();
  
  FoodComponent({
    required Vector2 position,
    required this.tileSize,
  }) : super(position: position, size: Vector2(tileSize, tileSize));
  
  @override
  void render(Canvas canvas) {
    final center = Offset(
      position.x * tileSize + tileSize / 2,
      position.y * tileSize + tileSize / 2,
    );
    
    // Efeito pulsante da comida
    final pulseValue = (DateTime.now().millisecondsSinceEpoch / 200).sin();
    final radius = (tileSize / 2) * (0.8 + pulseValue * 0.1);
    
    // Gradiente radial para a comida
    final gradient = RadialGradient(
      colors: [Colors.red.shade400, Colors.red.shade900],
      center: Alignment.center,
      radius: 0.8,
    );
    
    final rect = Rect.fromCircle(center: center, radius: radius);
    _paint.shader = gradient.createShader(rect);
    canvas.drawCircle(center, radius, _paint);
    
    // Brilho
    _paint.shader = null;
    _paint.color = Colors.white.withOpacity(0.5 + pulseValue * 0.2);
    canvas.drawCircle(
      Offset(center.dx - 3, center.dy - 3),
      3,
      _paint,
    );
  }
}