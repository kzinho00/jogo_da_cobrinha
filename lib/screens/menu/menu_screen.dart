import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../game/game_data.dart';
import '../../game/snake_game.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() =>
      _MenuScreenState();
}

class _MenuScreenState
    extends State<MenuScreen> {
  GameMode selectedMode =
      GameMode.arcade;

  SnakeSkin selectedSkin = skins.first;

  Skill selectedSkill = skills.first;

  bool movingFruit = true;

  int gridSize = 20;

  void startGame() {
    final game = SnakeStarvingGame(
      mode: selectedMode,
      snakeColor: selectedSkin.color,
      gridSize: gridSize,
      frutaSeMovimenta: movingFruit,
      selectedSkill: selectedSkill,
    );

    final focusNode = FocusNode();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          body: Focus(
            autofocus: true,
            focusNode: focusNode,
            onKeyEvent: (node, event) {
              game.handleInput(event);

              return KeyEventResult.handled;
            },
            child: GameWidget(
              autofocus: true,
              game: game,

              // lib/screens/menu/menu_screen.dart
// DENTRO DO GameWidget, ADICIONE:

overlayBuilderMap: {
  'GameOver': (_, SnakeStarvingGame game) {
    return Container(
      color: Colors.black.withOpacity(0.85),
      child: Center(
        child: Container(
          width: 420,
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: const Color(0xFF111827),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: game.snakeColor,
              width: 3,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                game.currentGameOverMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              Text(
                'SCORE: ${game.score}',
                style: TextStyle(
                  color: game.snakeColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                'RECORD: ${game.highScore}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
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
                    vertical: 18,
                  ),
                ),
                child: const Text(
                  'JOGAR NOVAMENTE',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white10,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 18,
                  ),
                ),
                child: const Text(
                  'MENU',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  },

  'PauseMenu': (_, SnakeStarvingGame game) {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(20),
        width: 280,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.92),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: game.snakeColor,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'PAUSADO',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w900,
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                game.resumeGame();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: game.snakeColor,
                foregroundColor: Colors.black,
              ),
              child: const Text(
                'CONTINUAR',
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'VOLTAR AO MENU',
              ),
            ),
          ],
        ),
      ),
    );
  },
},
            ),
          ),
        ),
      ),
    );

    Future.delayed(
      const Duration(milliseconds: 150),
      () {
        focusNode.requestFocus();
      },
    );
  }

  Widget modeButton(
    String title,
    GameMode mode,
    IconData icon,
  ) {
    final selected = selectedMode == mode;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMode = mode;
        });
      },
      child: AnimatedContainer(
        duration:
            const Duration(milliseconds: 200),
        width: 160,
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: selected
              ? selectedSkin.color
              : Colors.white10,
          borderRadius:
              BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 34,
              color: selected
                  ? Colors.black
                  : Colors.white,
            ),

            const SizedBox(height: 10),

            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: selected
                    ? Colors.black
                    : Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF030712),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.all(24),
            child: Column(
              children: [
                Text(
                  'SNAKE EVOLUTION',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color:
                        selectedSkin.color,
                    fontSize: 42,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 40),

                Wrap(
                  alignment:
                      WrapAlignment.center,
                  children: [
                    modeButton(
                      'ARCADE',
                      GameMode.arcade,
                      Icons.sports_esports,
                    ),

                    modeButton(
                      'HARDCORE',
                      GameMode.hardcore,
                      Icons.warning,
                    ),

                    modeButton(
                      'ZEN',
                      GameMode.zen,
                      Icons.spa,
                    ),

                    modeButton(
                      'TIME ATTACK',
                      GameMode.timeAttack,
                      Icons.timer,
                    ),

                    modeButton(
                      'CHAOS',
                      GameMode.chaos,
                      Icons.bolt,
                    ),

                    modeButton(
                      'INFINITY',
                      GameMode.infinity,
                      Icons.all_inclusive,
                    ),

                    modeButton(
                      'MULTIPLAYER',
                      GameMode.multiplayer,
                      Icons.people,
                    ),

                    modeButton(
                      'RANDOM MIX',
                      GameMode.randomMix,
                      Icons.auto_awesome,
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                ElevatedButton(
                  onPressed: startGame,
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        selectedSkin.color,
                    foregroundColor:
                        Colors.black,
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 80,
                      vertical: 24,
                    ),
                  ),
                  child: const Text(
                    'START GAME',
                    style: TextStyle(
                      fontWeight:
                          FontWeight.w900,
                      fontSize: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}