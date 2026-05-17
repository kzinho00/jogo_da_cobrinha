// lib/game/snake_game.dart

import 'dart:async' as async;
import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'game_data.dart';

class Bullet {
  Bullet({
    required this.position,
    required this.direction,
  });

  Vector2 position;

  Vector2 direction;
}

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

  List<Vector2> obstacles = [];

  List<Bullet> bullets = [];

  Vector2 direction = Vector2(1, 0);

  Vector2 nextDirection = Vector2(1, 0);

  Vector2 food = Vector2.zero();

  Vector2? specialFood;

  Vector2? goldenFood;

  int score = 0;

  int coins = 0;

  int combo = 0;

  int highScore = 0;

  int ammo = 0;

  bool gameOver = false;

  bool paused = false;

  bool infinityMode = false;

  double pulse = 0;

  double accumulator = 0;

  late double moveInterval;

  async.Timer? fruitTimer;

  final List<String> gameOverMessages = [
    'Quase! Tente novamente.',
    'Você consegue bater o recorde.',
    'Mais uma partida?',
    'Continue evoluindo.',
    'Você foi longe.',
  ];

  String currentGameOverMessage = '';

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
        moveInterval = 0.10;
        break;

      case GameMode.chaos:
        moveInterval = 0.07;
        break;

      case GameMode.infinity:
        moveInterval = 0.11;
        infinityMode = true;
        break;

      case GameMode.multiplayer:
        moveInterval = 0.10;
        break;

      case GameMode.randomMix:
        moveInterval = 0.09;
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

    coins = 0;

    combo = 0;

    ammo = 0;

    gameOver = false;

    paused = false;

    bullets.clear();

    obstacles.clear();

    snake = [
      Vector2(10, 10),
      Vector2(9, 10),
      Vector2(8, 10),
    ];

    direction = Vector2(1, 0);

    nextDirection = Vector2(1, 0);

    spawnFood();

    spawnObstacles();

    overlays.remove('GameOver');

    overlays.remove('PauseMenu');

    resumeEngine();
  }

  void spawnFood() {
    food = Vector2(
      random.nextInt(gridSize).toDouble(),
      random.nextInt(gridSize).toDouble(),
    );

    if (random.nextDouble() > 0.65) {
      specialFood = Vector2(
        random.nextInt(gridSize).toDouble(),
        random.nextInt(gridSize).toDouble(),
      );
    }

    if (random.nextDouble() > 0.8) {
      goldenFood = Vector2(
        random.nextInt(gridSize).toDouble(),
        random.nextInt(gridSize).toDouble(),
      );
    }
  }

  void spawnObstacles() {
    obstacles.clear();

    int amount = 0;

    if (mode == GameMode.hardcore) {
      amount = 10;
    }

    if (mode == GameMode.chaos) {
      amount = 15;
    }

    if (mode == GameMode.impossible) {
      amount = 25;
    }

    for (int i = 0; i < amount; i++) {
      obstacles.add(
        Vector2(
          random.nextInt(gridSize).toDouble(),
          random.nextInt(gridSize).toDouble(),
        ),
      );
    }
  }

  void startFruitMovement() {
    int milliseconds = 3000;

    if (mode == GameMode.hardcore) {
      milliseconds = 2200;
    }

    if (mode == GameMode.impossible) {
      milliseconds = 1200;
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

    accumulator += dt;

    if (accumulator >= moveInterval) {
      accumulator = 0;

      moveSnake();

      updateBullets();
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

    final wallCollision =
        !infinityMode &&
        (
          newHead.x < 0 ||
          newHead.y < 0 ||
          newHead.x >= gridSize ||
          newHead.y >= gridSize
        );

    final selfCollision =
        snake.contains(newHead);

    final obstacleCollision =
        obstacles.contains(newHead);

    if (
      wallCollision ||
      selfCollision ||
      obstacleCollision
    ) {
      finishGame();

      return;
    }

    snake.insert(0, newHead);

    if (newHead == food) {
      score += 10;

      coins += 2;

      combo++;

      spawnFood();
    }

    else if (
        specialFood != null &&
        newHead == specialFood
    ) {
      score += 40;

      coins += 10;

      ammo += 3;

      specialFood = null;
    }

    else if (
        goldenFood != null &&
        newHead == goldenFood
    ) {
      score += 100;

      coins += 25;

      ammo += 3;

      goldenFood = null;
    }

    else {
      snake.removeLast();
    }

    if (score > highScore) {
      highScore = score;
    }
  }

  void updateBullets() {
    final bulletsToRemove = <Bullet>[];

    final obstaclesToRemove = <Vector2>[];

    for (final bullet in bullets) {
      bullet.position += bullet.direction;

      for (final obstacle in obstacles) {
        if (
          obstacle.x == bullet.position.x &&
          obstacle.y == bullet.position.y
        ) {
          bulletsToRemove.add(bullet);

          obstaclesToRemove.add(obstacle);

          score += 5;

          break;
        }
      }

      if (
        bullet.position.x < 0 ||
        bullet.position.y < 0 ||
        bullet.position.x >= gridSize ||
        bullet.position.y >= gridSize
      ) {
        bulletsToRemove.add(bullet);
      }
    }

    bullets.removeWhere(
      (bullet) => bulletsToRemove.contains(bullet),
    );

    obstacles.removeWhere(
      (obstacle) => obstaclesToRemove.contains(obstacle),
    );
  }

  void shoot() {
    if (ammo <= 0) {
      return;
    }

    ammo--;

    bullets.add(
      Bullet(
        position: snake.first.clone(),
        direction: direction.clone(),
      ),
    );
  }

  void finishGame() {
    if (gameOver) return;

    gameOver = true;

    paused = true;

    currentGameOverMessage =
        gameOverMessages[
          random.nextInt(
            gameOverMessages.length,
          )
        ];

    pauseEngine();

    overlays.remove('PauseMenu');

    overlays.add('GameOver');
  }

  void pauseGame() {
    paused = true;

    pauseEngine();

    overlays.add('PauseMenu');
  }

  void resumeGame() {
    paused = false;

    resumeEngine();

    overlays.remove('PauseMenu');
  }

  void handleInput(KeyEvent event) {
    if (event is! KeyDownEvent) {
      return;
    }

    final key = event.logicalKey;

    if (
      (key == LogicalKeyboardKey.arrowUp ||
       key == LogicalKeyboardKey.keyW) &&
      direction.y != 1
    ) {
      nextDirection = Vector2(0, -1);
    }

    else if (
      (key == LogicalKeyboardKey.arrowDown ||
       key == LogicalKeyboardKey.keyS) &&
      direction.y != -1
    ) {
      nextDirection = Vector2(0, 1);
    }

    else if (
      (key == LogicalKeyboardKey.arrowLeft ||
       key == LogicalKeyboardKey.keyA) &&
      direction.x != 1
    ) {
      nextDirection = Vector2(-1, 0);
    }

    else if (
      (key == LogicalKeyboardKey.arrowRight ||
       key == LogicalKeyboardKey.keyD) &&
      direction.x != -1
    ) {
      nextDirection = Vector2(1, 0);
    }

    if (key == LogicalKeyboardKey.space) {
      shoot();
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

    final backgroundPaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFF020617),
          Color(0xFF0F172A),
          Color(0xFF111827),
        ],
      ).createShader(
        Rect.fromLTWH(
          0,
          0,
          size.x,
          size.y,
        ),
      );

    canvas.drawRect(
      Rect.fromLTWH(
        0,
        0,
        size.x,
        size.y,
      ),
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

    for (final obstacle in obstacles) {
      final obstaclePaint = Paint()
        ..color = Colors.grey.shade800;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            obstacle.x * cellSize,
            obstacle.y * cellSize,
            cellSize,
            cellSize,
          ),
          const Radius.circular(8),
        ),
        obstaclePaint,
      );
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
          const Radius.circular(12),
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
        ..color = Colors.blueAccent;

      canvas.drawCircle(
        Offset(
          specialFood!.x * cellSize +
              (cellSize / 2),
          specialFood!.y * cellSize +
              (cellSize / 2),
        ),
        cellSize / 2.5,
        specialPaint,
      );
    }

    if (goldenFood != null) {
      final goldPaint = Paint()
        ..color = Colors.amber;

      canvas.drawCircle(
        Offset(
          goldenFood!.x * cellSize +
              (cellSize / 2),
          goldenFood!.y * cellSize +
              (cellSize / 2),
        ),
        cellSize / 2.3,
        goldPaint,
      );
    }

    for (final bullet in bullets) {
      final bulletPaint = Paint()
        ..color = Colors.cyanAccent;

      canvas.drawCircle(
        Offset(
          bullet.position.x * cellSize +
              (cellSize / 2),
          bullet.position.y * cellSize +
              (cellSize / 2),
        ),
        cellSize / 5,
        bulletPaint,
      );
    }

    final hud = TextPainter(
      text: TextSpan(
        text:
            'SCORE $score   RECORD $highScore   COINS $coins   TIROS $ammo',
        style: TextStyle(
          color: snakeColor,
          fontSize: 20,
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