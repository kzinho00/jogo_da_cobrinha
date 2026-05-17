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
          width: 420,
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: const Color(0xFF111827),
            borderRadius:
                BorderRadius.circular(30),
            border: Border.all(
              color: game.snakeColor,
              width: 3,
            ),
          ),
          child: Column(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              const Icon(
                Icons.close_rounded,
                color: Colors.redAccent,
                size: 80,
              ),

              const SizedBox(height: 20),

              const Text(
                'GAME OVER',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 38,
                  fontWeight:
                      FontWeight.w900,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                game.currentGameOverMessage,
                textAlign:
                    TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 25),

              Text(
                'SCORE: ${game.score}',
                style: TextStyle(
                  color:
                      game.snakeColor,
                  fontSize: 24,
                  fontWeight:
                      FontWeight.w900,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'RECORD: ${game.highScore}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () {
                  game.resetGame();
                },
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      game.snakeColor,
                  foregroundColor:
                      Colors.black,
                ),
                child: const Text(
                  'JOGAR NOVAMENTE',
                ),
              ),

              const SizedBox(height: 12),

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