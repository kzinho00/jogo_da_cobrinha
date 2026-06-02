import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../models/game_map.dart';
import '../models/tile_type.dart';

class MapComponent extends PositionComponent {
  final GameMap gameMap;
  late Paint _paint;
  
  MapComponent({required this.gameMap}) {
    size = Vector2(
      gameMap.width * gameMap.tileSize,
      gameMap.height * gameMap.tileSize,
    );
  }
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _paint = Paint()..style = PaintingStyle.fill;
  }
  
  @override
  void render(Canvas canvas) {
    for (int y = 0; y < gameMap.height; y++) {
      for (int x = 0; x < gameMap.width; x++) {
        final tile = gameMap.tiles[y][x];
        
        // Efeito de gradiente para tiles especiais
        _drawTile(canvas, x, y, tile);
        
        // Adicionar bordas suaves
        _drawTileBorder(canvas, x, y, tile);
      }
    }
  }
  
  void _drawTile(Canvas canvas, int x, int y, TileType tile) {
    final rect = Rect.fromLTWH(
      x * gameMap.tileSize,
      y * gameMap.tileSize,
      gameMap.tileSize.toDouble(),
      gameMap.tileSize.toDouble(),
    );
    
    // Cores base
    _paint.color = tile.color;
    canvas.drawRect(rect, _paint);
    
    // Adicionar textura simples
    if (tile == TileType.grass) {
      _paint.color = Colors.green.shade900;
      canvas.drawLine(
        Offset(rect.left, rect.center.dy),
        Offset(rect.right, rect.center.dy),
        _paint..strokeWidth = 2,
      );
    } else if (tile == TileType.sand) {
      _paint.color = Colors.orange.shade900;
      for (int i = 0; i < 3; i++) {
        canvas.drawPoints(
          PointMode.points,
          [
            Offset(rect.left + 5 + i * 10, rect.top + 10 + i * 5),
            Offset(rect.left + 15, rect.bottom - 8),
          ],
          _paint,
        );
      }
    } else if (tile == TileType.water) {
      // Efeito de onda
      _paint.color = Colors.blue.shade200;
      canvas.drawCircle(
        Offset(rect.center.dx, rect.center.dy),
        4,
        _paint,
      );
    }
  }
  
  void _drawTileBorder(Canvas canvas, int x, int y, TileType tile) {
    final rect = Rect.fromLTWH(
      x * gameMap.tileSize,
      y * gameMap.tileSize,
      gameMap.tileSize.toDouble(),
      gameMap.tileSize.toDouble(),
    );
    
    _paint.color = Colors.black26;
    _paint.style = PaintingStyle.stroke;
    _paint.strokeWidth = 1;
    canvas.drawRect(rect, _paint);
  }
}