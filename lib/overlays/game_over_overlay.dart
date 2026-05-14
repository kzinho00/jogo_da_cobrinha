import 'package:flutter/material.dart';

import '../game/save_data.dart';
import '../game/snake_game.dart';

class GameOverOverlay extends StatelessWidget {
  final SnakeStarvingGame game;

  const GameOverOverlay({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.82),
      child: Center(
        child: Container(
          width: 420,
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(
              colors: [
                Color(0xFF111827),
                Color(0xFF1F2937),
              ],
            ),
            border: Border.all(
              color: game.snakeColor,
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: game.snakeColor.withOpacity(0.45),
                blurRadius: 35,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 80,
                color: game.snakeColor,
              ),

              const SizedBox(height: 18),

              Text(
                'GAME OVER',
                style: TextStyle(
                  color: game.snakeColor,
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3,
                ),
              ),

              const SizedBox(height: 30),

              stats(
                'SCORE',
                '${game.score}',
              ),

              stats(
                'RECORD',
                '${SaveData.highScore}',
              ),

              stats(
                'MOEDAS',
                '${SaveData.coins}',
              ),

              const SizedBox(height: 35),

              ElevatedButton(
                onPressed: () {
                  game.resetGame();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: game.snakeColor,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 22,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
                child: const Text(
                  'JOGAR NOVAMENTE',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget stats(
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 18,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: game.snakeColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}