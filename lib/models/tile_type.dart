enum TileType {
  grass,
  water,
  sand,
  wall,
  
  bool get isWalkable {
    switch (this) {
      case TileType.water:
      case TileType.wall:
        return false;
      default:
        return true;
    }
  }
  
  Color get color {
    switch (this) {
      case TileType.grass:
        return Colors.green.shade700;
      case TileType.water:
        return Colors.blue.shade400;
      case TileType.sand:
        return Colors.yellow.shade700;
      case TileType.wall:
        return Colors.grey.shade800;
    }
  }
}