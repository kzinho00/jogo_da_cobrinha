import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flame/components.dart';

class ParticleEffect {
  ParticleEffect({
    required this.position,
    required this.color,
  });

  Vector2 position;

  Color color;

  double life = 1;

  double size =
      4 + (math.Random().nextDouble() * 8);

  Vector2 velocity = Vector2(
    (math.Random().nextDouble() * 2 - 1) * 120,
    (math.Random().nextDouble() * 2 - 1) * 120,
  );

  void update(double dt) {
    life -= dt;

    position += velocity * dt;

    velocity *= 0.96;
  }

  void render(Canvas canvas) {
    final paint = Paint()
      ..color = color.withOpacity(
        life.clamp(0, 1),
      );

    canvas.drawCircle(
      Offset(position.x, position.y),
      size * life,
      paint,
    );
  }
}