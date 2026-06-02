import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'tile_type.dart';

class GameMap {
  final int width;
  final int height;
  final int tileSize = 32;
  late List<List<TileType>> tiles;
  
  GameMap({required this.width, required this.height}) {
    _initializeEmptyMap();
  }
  
  void _initializeEmptyMap() {
    tiles = List.generate(
      height,
      (_) => List.generate(width, (_) => TileType.grass),
    );
  }
  
  // Carregar mapa do JSON
  Future<void> loadFromJson(String path) async {
    final jsonString = await rootBundle.loadString(path);
    final Map<String, dynamic> data = json.decode(jsonString);
    
    final List<dynamic> mapData = data['map'];
    for (int y = 0; y < height && y < mapData.length; y++) {
      final row = mapData[y] as List<dynamic>;
      for (int x = 0; x < width && x < row.length; x++) {
        tiles[y][x] = TileType.values[row[x]];
      }
    }
  }
  
  // Gerar mapa procedural com biomas
  void generateProcedural(Random random) {
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        // Água nas bordas
        if (x == 0 || y == 0 || x == width - 1 || y == height - 1) {
          tiles[y][x] = TileType.water;
        }
        // Ilhas de areia
        else if (random.nextDouble() < 0.05 && 
                 (x > 2 && y > 2 && x < width - 3 && y < height - 3)) {
          tiles[y][x] = TileType.sand;
        }
        // Obstáculos (paredes)
        else if (random.nextDouble() < 0.03) {
          tiles[y][x] = TileType.wall;
        }
        else {
          tiles[y][x] = TileType.grass;
        }
      }
    }
  }
  
  bool isWalkable(int x, int y) {
    if (x < 0 || y < 0 || x >= width || y >= height) return false;
    return tiles[y][x].isWalkable;
  }
  
  // Obter posição aleatória válida
  Vector2 getRandomWalkablePosition(Random random) {
    List<Vector2> walkablePositions = [];
    
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        if (isWalkable(x, y)) {
          walkablePositions.add(Vector2(x.toDouble(), y.toDouble()));
        }
      }
    }
    
    if (walkablePositions.isEmpty) return Vector2(1, 1);
    return walkablePositions[random.nextInt(walkablePositions.length)];
  }
}