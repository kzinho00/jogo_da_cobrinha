import 'package:flutter/material.dart';

enum GameMode {
  arcade,
  hardcore,
  zen,
  timeAttack,
  chaos,
  infinity,
  multiplayer,
  randomMix,
}

class SnakeSkin {
  final String name;
  final Color color;

  SnakeSkin({
    required this.name,
    required this.color,
  });
}

class Skill {
  final String name;
  final IconData icon;

  Skill({
    required this.name,
    required this.icon,
  });
}

final skins = [
  SnakeSkin(
    name: 'NEON',
    color: Colors.greenAccent,
  ),
  SnakeSkin(
    name: 'FIRE',
    color: Colors.orangeAccent,
  ),
  SnakeSkin(
    name: 'ICE',
    color: Colors.cyanAccent,
  ),
  SnakeSkin(
    name: 'PINK',
    color: Colors.pinkAccent,
  ),
];

final skills = [
  Skill(
    name: 'BOOST',
    icon: Icons.flash_on,
  ),
  Skill(
    name: 'GHOST',
    icon: Icons.visibility_off,
  ),
];