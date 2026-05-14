import 'dart:async' as async;
import 'dart:math' as math;

import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'game_data.dart';

class SnakeStarvingGame extends FlameGame {
  SnakeStarvingGame({
    required this.mode,
    required this.snakeColor,
    required this.gridSize,
    required this.frutaSeMovimenta,
    required this.selectedSkill,
  });

  final GameMode mode;

  final Color snakeColor;

  final int gridSize;

  final bool frutaSeMovimenta;

  final Skill selectedSkill;

  final math.Random random = math.Random();

  List<Vector2> snake = [];

  Vector2 direction = Vector2(1, 0);

  Vector2 nextDirection = Vector2(1, 0);

  Vector2 food = Vector2.zero();

  Vector2? specialFood;

  int score = 0;

  int combo = 0;

  int coins = 0;

  bool gameOver = false;

  bool paused = false;

  bool infinityMode = false;

  double pulse = 0;

  double backgroundPulse = 0;

  double accumulator = 0;

  late double moveInterval;

  async.Timer? fruitTimer;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    switch (mode) {
      case GameMode.arcade:
        moveInterval = 0.12;
        break;

      case GameMode.hardcore:
        moveInterval = 0.08;
        break;

      case GameMode.zen:
        moveInterval = 0.18;
        break;

      case GameMode.timeAttack:
        moveInterval = 0.09;
        break;

      case GameMode.chaos:
        moveInterval = 0.07;
        break;

      case GameMode.randomMix:
        moveInterval = 0.1;
        break;

      case GameMode.infinity:
        moveInterval = 0.12;
        infinityMode = true;
        break;

      case GameMode.multiplayer:
        moveInterval = 0.12;
        break;

      case GameMode.survival:
        moveInterval = 0.06;
        break;

      case GameMode.impossible:
        moveInterval = 0.045;
        break;

      case GameMode.ghost:
        moveInterval = 0.09;
        break;
    }

    resetGame();

    if (frutaSeMovimenta) {
      startFruitMovement();
    }
  }

  void resetGame() {
    score = 0;

    combo = 0;

    gameOver = false;

    snake = [
      Vector2(10, 10),
      Vector2(9, 10),
      Vector2(8, 10),
    ];

    direction = Vector2(1, 0);

    nextDirection = Vector2(1, 0);

    spawnFood();

    overlays.remove('GameOver');

    resumeEngine();
  }

  void spawnFood() {
    food = Vector2(
      random.nextInt(gridSize).toDouble(),
      random.nextInt(gridSize).toDouble(),
    );

    if (random.nextDouble() > 0.7) {
      specialFood = Vector2(
        random.nextInt(gridSize).toDouble(),
        random.nextInt(gridSize).toDouble(),
      );
    }
  }

  void startFruitMovement() {
    int milliseconds = 3000;

    if (mode == GameMode.hardcore) {
      milliseconds = 1600;
    }

    if (mode == GameMode.impossible) {
      milliseconds = 900;
    }

    fruitTimer?.cancel();

    fruitTimer = async.Timer.periodic(
      Duration(milliseconds: milliseconds),
      (_) {
        if (!gameOver) {
          spawnFood();
        }
      },
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (paused || gameOver) {
      return;
    }

    pulse += dt * 6;

    backgroundPulse += dt * 2;

    accumulator += dt;

    if (accumulator >= moveInterval) {
      accumulator = 0;

      moveSnake();
    }
  }

  void moveSnake() {
    direction = nextDirection;

    Vector2 newHead = snake.first + direction;

    if (infinityMode) {
      if (newHead.x < 0) {
        newHead.x = gridSize - 1;
      }

      if (newHead.x >= gridSize) {
        newHead.x = 0;
      }

      if (newHead.y < 0) {
        newHead.y = gridSize - 1;
      }

      if (newHead.y >= gridSize) {
        newHead.y = 0;
      }
    }

    final collided =
        (!infinityMode &&
                (newHead.x < 0 ||
                    newHead.y < 0 ||
                    newHead.x >= gridSize ||
                    newHead.y >= gridSize)) ||
            snake.contains(newHead);

    if (collided) {
      finishGame();
      return;
    }

    snake.insert(0, newHead);

    if (newHead == food) {
      score += 10;

      coins += 2;

      combo++;

      spawnFood();
    } else if (specialFood != null &&
        newHead == specialFood) {
      score += 50;

      coins += 10;

      combo += 3;

      specialFood = null;
    } else {
      snake.removeLast();
    }
  }

  void finishGame() {
    gameOver = true;

    pauseEngine();

    overlays.add('GameOver');
  }

  void pauseGame() {
    paused = true;

    pauseEngine();

    overlays.add('PauseMenu');
  }

  void resumeGame() {
    paused = false;

    overlays.remove('PauseMenu');

    resumeEngine();
  }

  void handleInput(KeyEvent event) {
    if (event is! KeyDownEvent) {
      return;
    }

    final key = event.logicalKey;

    if ((key == LogicalKeyboardKey.arrowUp ||
            key == LogicalKeyboardKey.keyW) &&
        direction.y != 1) {
      nextDirection = Vector2(0, -1);
    }

    else if ((key ==
                LogicalKeyboardKey.arrowDown ||
            key == LogicalKeyboardKey.keyS) &&
        direction.y != -1) {
      nextDirection = Vector2(0, 1);
    }

    else if ((key ==
                LogicalKeyboardKey.arrowLeft ||
            key == LogicalKeyboardKey.keyA) &&
        direction.x != 1) {
      nextDirection = Vector2(-1, 0);
    }

    else if ((key ==
                LogicalKeyboardKey.arrowRight ||
            key == LogicalKeyboardKey.keyD) &&
        direction.x != -1) {
      nextDirection = Vector2(1, 0);
    }

    if (key == LogicalKeyboardKey.escape) {
      if (paused) {
        resumeGame();
      } else {
        pauseGame();
      }
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final cellSize = size.x / gridSize;

    final rect = Rect.fromLTWH(
      0,
      0,
      size.x,
      size.y,
    );

    final backgroundGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color.lerp(
          const Color(0xFF020617),
          const Color(0xFF0F172A),
          (math.sin(backgroundPulse) + 1) / 2,
        )!,
        const Color(0xFF111827),
        const Color(0xFF1E293B),
      ],
    );

    final backgroundPaint = Paint()
      ..shader = backgroundGradient.createShader(rect);

    canvas.drawRect(
      rect,
      backgroundPaint,
    );

    final gridPaint = Paint()
      ..color = snakeColor.withOpacity(0.08)
      ..style = PaintingStyle.stroke;

    for (int x = 0; x < gridSize; x++) {
      for (int y = 0; y < gridSize; y++) {
        canvas.drawRect(
          Rect.fromLTWH(
            x * cellSize,
            y * cellSize,
            cellSize,
            cellSize,
          ),
          gridPaint,
        );
      }
    }

    for (int i = snake.length - 1;
        i >= 0;
        i--) {
      final part = snake[i];

      final opacity =
          1 - (i / snake.length);

      final scale =
          1 + (0.08 * math.sin(pulse));

      final snakePaint = Paint()
        ..color =
            snakeColor.withOpacity(opacity);

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(
              part.x * cellSize +
                  (cellSize / 2),
              part.y * cellSize +
                  (cellSize / 2),
            ),
            width: cellSize * scale,
            height: cellSize * scale,
          ),
          const Radius.circular(10),
        ),
        snakePaint,
      );
    }

    final foodPaint = Paint()
      ..color = Colors.redAccent;

    canvas.drawCircle(
      Offset(
        food.x * cellSize +
            (cellSize / 2),
        food.y * cellSize +
            (cellSize / 2),
      ),
      cellSize / 2.8,
      foodPaint,
    );

    if (specialFood != null) {
      final specialPaint = Paint()
        ..color = Colors.amberAccent;

      canvas.drawCircle(
        Offset(
          specialFood!.x * cellSize +
              (cellSize / 2),
          specialFood!.y * cellSize +
              (cellSize / 2),
        ),
        cellSize / 2.2,
        specialPaint,
      );
    }

    final hud = TextPainter(
      text: TextSpan(
        text:
            'SCORE $score   COINS $coins',
        style: TextStyle(
          color: snakeColor,
          fontSize: 24,
          fontWeight: FontWeight.w900,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    hud.layout();

    hud.paint(
      canvas,
      const Offset(20, 20),
    );
  }

  @override
  void onRemove() {
    fruitTimer?.cancel();

    super.onRemove();
  }
}