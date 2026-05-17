// lib/overlays/game_over_overlay.dart

import 'package:flutter/material.dart';

import '../game/snake_game.dart';

class GameOverOverlay extends StatelessWidget {
  final SnakeStarvingGame game;

  const GameOverOverlay({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.85),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          margin: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF111827),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: game.snakeColor,
              width: 3,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'GAME OVER',
                style: TextStyle(
                  color: game.snakeColor,
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                game.currentGameOverMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              Text(
                'SCORE ${game.score}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'RECORD ${game.highScore}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 35),

              ElevatedButton(
                onPressed: () {
                  game.resetGame();
                },
                child: const Text(
                  'PLAY AGAIN',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}