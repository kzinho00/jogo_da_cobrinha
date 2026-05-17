// lib/overlays/pause_menu_overlay.dart

import 'package:flutter/material.dart';

import '../game/snake_game.dart';

class PauseMenuOverlay extends StatelessWidget {
  final SnakeStarvingGame game;

  const PauseMenuOverlay({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: const Color(0xFF111827),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'PAUSED',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () {
                  game.resumeGame();
                },
                child: const Text(
                  'CONTINUE',
                ),
              ),

              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'MENU',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}