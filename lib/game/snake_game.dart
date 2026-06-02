import 'dart:math';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flame_audio/flame_audio.dart';
import 'models/game_map.dart';
import 'components/map_component.dart';
import 'components/snake_component.dart';
import 'components/food_component.dart';

class SnakeGame extends FlameGame with KeyboardEvents, TapDetector {
  late GameMap gameMap;
  late MapComponent mapComponent;
  late SnakeComponent snakeComponent;
  late FoodComponent foodComponent;
  
  List<Vector2> snake = [];
  Vector2 direction = Vector2(1, 0);
  Vector2 nextDirection = Vector2(1, 0);
  int score = 0;
  bool isGameOver = false;
  final Random _random = Random();
  
  // Configurações do mapa
  static const int mapWidth = 20;
  static const int mapHeight = 15;
  final int tileSize = 32;
  
  @override
  Future<void> onLoad() async {
    super.onLoad();
    await _initializeGame();
  }
  
  Future<void> _initializeGame() async {
    // Inicializar mapa
    gameMap = GameMap(width: mapWidth, height: mapHeight);
    gameMap.generateProcedural(_random);
    
    // Criar cobrinha no centro
    final startPos = Vector2((mapWidth / 2).floorToDouble(), (mapHeight / 2).floorToDouble());
    snake = [startPos, startPos - Vector2(1, 0), startPos - Vector2(2, 0)];
    
    // Adicionar componentes
    mapComponent = MapComponent(gameMap: gameMap);
    snakeComponent = SnakeComponent(segments: snake, tileSize: tileSize.toDouble());
    await add(mapComponent);
    await add(snakeComponent);
    
    // Gerar comida
    _generateFood();
    
    // Configurar tamanho da tela
    camera.viewport = FixedResolutionViewport(
      Vector2(mapWidth * tileSize, mapHeight * tileSize),
    );
  }
  
  void _generateFood() {
    Vector2 position;
    do {
      position = gameMap.getRandomWalkablePosition(_random);
    } while (snake.contains(position));
    
    if (foodComponent != null) {
      remove(foodComponent);
    }
    
    foodComponent = FoodComponent(position: position, tileSize: tileSize.toDouble());
    add(foodComponent);
  }
  
  void updateSnake() {
    if (isGameOver) return;
    
    direction = nextDirection;
    final head = snake.first + direction;
    
    // Verificar colisão com mapa
    if (!gameMap.isWalkable(head.x.toInt(), head.y.toInt())) {
      gameOver();
      return;
    }
    
    // Verificar colisão com corpo
    if (snake.contains(head)) {
      gameOver();
      return;
    }
    
    snake.insert(0, head);
    
    // Verificar se comeu a comida
    if (head == foodComponent.position) {
      score++;
      FlameAudio.play('eat.mp3');
      _generateFood();
    } else {
      snake.removeLast();
    }
    
    // Atualizar componente visual
    snakeComponent.segments.clear();
    snakeComponent.segments.addAll(snake);
  }
  
  void gameOver() async {
    isGameOver = true;
    await FlameAudio.play('game_over.mp3');
    // Salvar pontuação máxima
    // Implementar lógica de save com SharedPreferences
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    _updateTimer += dt;
    if (_updateTimer >= 0.15) {
      _updateTimer = 0;
      updateSnake();
    }
  }
  
  double _updateTimer = 0;
  
  @override
  KeyEventResult onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is RawKeyDownEvent) {
      if (keysPressed.contains(LogicalKeyboardKey.arrowUp) && direction.y != 1) {
        nextDirection = Vector2(0, -1);
      } else if (keysPressed.contains(LogicalKeyboardKey.arrowDown) && direction.y != -1) {
        nextDirection = Vector2(0, 1);
      } else if (keysPressed.contains(LogicalKeyboardKey.arrowLeft) && direction.x != 1) {
        nextDirection = Vector2(-1, 0);
      } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight) && direction.x != -1) {
        nextDirection = Vector2(1, 0);
      }
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }
  
  @override
  void onTapDown(TapDownInfo info) {
    // Suporte para mobile (swipe)
    // Implementar lógica de swipe para mobile
    super.onTapDown(info);
  }
}