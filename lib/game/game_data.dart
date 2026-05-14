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
  survival,
  impossible,
  ghost,
}

class SnakeSkin {
  final String name;

  final Color color;

  final int price;

  final bool unlocked;

  const SnakeSkin({
    required this.name,
    required this.color,
    required this.price,
    required this.unlocked,
  });
}

class Skill {
  final String name;

  final IconData icon;

  final String description;

  const Skill({
    required this.name,
    required this.icon,
    required this.description,
  });
}

final List<SnakeSkin> skins = [
  const SnakeSkin(
    name: 'NEON',
    color: Colors.greenAccent,
    price: 0,
    unlocked: true,
  ),

  const SnakeSkin(
    name: 'FIRE',
    color: Colors.orangeAccent,
    price: 250,
    unlocked: false,
  ),

  const SnakeSkin(
    name: 'ICE',
    color: Colors.lightBlueAccent,
    price: 400,
    unlocked: false,
  ),

  const SnakeSkin(
    name: 'VOID',
    color: Colors.purpleAccent,
    price: 700,
    unlocked: false,
  ),

  const SnakeSkin(
    name: 'GOLD',
    color: Colors.amber,
    price: 1200,
    unlocked: false,
  ),
];

final List<Skill> skills = [
  const Skill(
    name: 'DASH',
    icon: Icons.flash_on,
    description: 'Speed boost',
  ),

  const Skill(
    name: 'GHOST',
    icon: Icons.visibility_off,
    description: 'Pass through walls',
  ),

  const Skill(
    name: 'MAGNET',
    icon: Icons.blur_circular,
    description: 'Pull apples',
  ),

  const Skill(
    name: 'SLOW TIME',
    icon: Icons.hourglass_bottom,
    description: 'Slow motion',
  ),
];