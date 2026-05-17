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

  final random = math.Random();

  late double moveInterval;

  bool infinityMode = false;

  bool paused = false;

  bool gameOver = false;

  int score = 0;

  int highScore = 0;

  int coins = 0;

  String currentGameOverMessage =
      'Boa tentativa!';

  double accumulator = 0;

  double pulse = 0;

  double backgroundPulse = 0;

  List<Vector2> snake = [];

  Vector2 direction = Vector2(1, 0);

  Vector2 nextDirection = Vector2(1, 0);

  Vector2 food = Vector2.zero();

  List<Vector2> blocks = [];

  Rect pauseButtonRect = Rect.zero;

  async.Timer? fruitTimer;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    switch (mode) {
      case GameMode.arcade:
        moveInterval = 0.14;
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
        moveInterval = 0.09;
        break;

      case GameMode.infinity:
        moveInterval = 0.11;
        infinityMode = true;
        break;

      case GameMode.multiplayer:
        moveInterval = 0.12;
        break;

      case GameMode.randomMix:
        moveInterval = 0.10;
        infinityMode = random.nextBool();
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

    gameOver = false;

    paused = false;

    snake = [
      Vector2(10, 10),
      Vector2(9, 10),
      Vector2(8, 10),
    ];

    direction = Vector2(1, 0);

    nextDirection = Vector2(1, 0);

    spawnFood();

    generateBlocks();

    overlays.remove('GameOver');

    overlays.remove('PauseMenu');

    resumeEngine();
  }

  void generateBlocks() {
    blocks.clear();

    if (mode != GameMode.arcade) {
      return;
    }

    for (int i = 0; i < 8; i++) {
      blocks.add(
        Vector2(
          random.nextInt(gridSize).toDouble(),
          random.nextInt(gridSize).toDouble(),
        ),
      );
    }
  }

  void spawnFood() {
    food = Vector2(
      random.nextInt(gridSize).toDouble(),
      random.nextInt(gridSize).toDouble(),
    );
  }

  void startFruitMovement() {
    fruitTimer?.cancel();

    int milliseconds = 3000;

    if (mode == GameMode.hardcore) {
      milliseconds = 1500;
    }

    fruitTimer = async.Timer.periodic(
      Duration(milliseconds: milliseconds),
      (_) {
        if (!gameOver) {
          spawnFood();
          generateBlocks();
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

    accumulator += dt;

    pulse += dt * 6;

    backgroundPulse += dt * 2;

    if (accumulator >= moveInterval) {
      accumulator = 0;
      moveSnake();
    }
  }

  void moveSnake() {
    direction = nextDirection;

    Vector2 newHead =
        snake.first + direction;

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

    final blockCollision =
        blocks.contains(newHead);

    if (
        wallCollision ||
        selfCollision ||
        blockCollision
    ) {
      finishGame();
      return;
    }

    snake.insert(0, newHead);

    if (newHead == food) {
      score += 10;

      coins += 2;

      spawnFood();
    } else {
      snake.removeLast();
    }
  }

  void finishGame() {
    if (gameOver) {
      return;
    }

    gameOver = true;

    if (score > highScore) {
      highScore = score;
    }

    final messages = [
      'Quase! Tente novamente!',
      'Você consegue bater o recorde!',
      'Boa jogada!',
      'Mais uma partida?',
      'A próxima será melhor!',
    ];

    currentGameOverMessage =
        messages[random.nextInt(messages.length)];

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

    if (
        (key ==
                LogicalKeyboardKey
                    .arrowUp ||
            key ==
                LogicalKeyboardKey
                    .keyW) &&
        direction.y != 1
    ) {
      nextDirection = Vector2(0, -1);
    }

    else if (
        (key ==
                LogicalKeyboardKey
                    .arrowDown ||
            key ==
                LogicalKeyboardKey
                    .keyS) &&
        direction.y != -1
    ) {
      nextDirection = Vector2(0, 1);
    }

    else if (
        (key ==
                LogicalKeyboardKey
                    .arrowLeft ||
            key ==
                LogicalKeyboardKey
                    .keyA) &&
        direction.x != 1
    ) {
      nextDirection = Vector2(-1, 0);
    }

    else if (
        (key ==
                LogicalKeyboardKey
                    .arrowRight ||
            key ==
                LogicalKeyboardKey
                    .keyD) &&
        direction.x != -1
    ) {
      nextDirection = Vector2(1, 0);
    }

    if (key ==
        LogicalKeyboardKey.escape) {
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

    final background = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFF020617),
          const Color(0xFF111827),
          snakeColor.withOpacity(0.12),
        ],
      ).createShader(rect);

    canvas.drawRect(rect, background);

    final gridPaint = Paint()
      ..color = snakeColor.withOpacity(0.08)
      ..style = PaintingStyle.stroke;

    for (int x = 0; x < gridSize; x++) {
      for (int y = 0;
          y < gridSize;
          y++) {
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

    final blockPaint = Paint()
      ..color = Colors.redAccent;

    for (final block in blocks) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            block.x * cellSize,
            block.y * cellSize,
            cellSize,
            cellSize,
          ),
          const Radius.circular(8),
        ),
        blockPaint,
      );
    }

    for (int i = snake.length - 1;
        i >= 0;
        i--) {
      final part = snake[i];

      final opacity =
          1 - (i / snake.length);

      final scale =
          1 +
          (0.08 * math.sin(pulse));

      final snakePaint = Paint()
        ..color = snakeColor.withOpacity(
          opacity,
        );

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

    final hud = TextPainter(
      text: TextSpan(
        text:
            'SCORE $score   RECORD $highScore',
        style: TextStyle(
          color: snakeColor,
          fontSize: 24,
          fontWeight: FontWeight.w900,
        ),
      ),
      textDirection:
          TextDirection.ltr,
    );

    hud.layout();

    hud.paint(
      canvas,
      const Offset(20, 20),
    );

    pauseButtonRect =
        Rect.fromLTWH(
      size.x - 80,
      20,
      60,
      60,
    );

    final pausePaint = Paint()
      ..color = Colors.black87;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        pauseButtonRect,
        const Radius.circular(16),
      ),
      pausePaint,
    );

    final iconPaint = Paint()
      ..color = Colors.white;

    canvas.drawRect(
      Rect.fromLTWH(
        size.x - 62,
        34,
        8,
        32,
      ),
      iconPaint,
    );

    canvas.drawRect(
      Rect.fromLTWH(
        size.x - 46,
        34,
        8,
        32,
      ),
      iconPaint,
    );
  }

  @override
  void onRemove() {
    fruitTimer?.cancel();

    super.onRemove();
  }
}