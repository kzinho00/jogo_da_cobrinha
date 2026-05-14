import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../game/game_data.dart';
import '../../game/snake_game.dart';
import '../../overlays/game_over_overlay.dart';
import '../shop/shop_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  GameMode selectedMode = GameMode.arcade;

  SnakeSkin selectedSkin = skins.first;

  Skill selectedSkill = skills.first;

  bool movingFruit = true;

  bool particles = true;

  bool screenShake = true;

  bool neonGrid = true;

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
          body: FocusScope(
            autofocus: true,
            child: Focus(
              autofocus: true,
              focusNode: focusNode,
              onKeyEvent: (node, event) {
                game.handleInput(event);

                return KeyEventResult.handled;
              },
              child: GameWidget<SnakeStarvingGame>(
  game: game,

  overlayBuilderMap: {
    'GameOver': (
      context,
      SnakeStarvingGame game,
    ) {
      return GameOverOverlay(
        game: game,
      );
    },
  },

  initialActiveOverlays: const [],
),
            ),
          ),
        ),
      ),
    );

    Future.delayed(
      const Duration(milliseconds: 200),
      () {
        focusNode.requestFocus();
      },
    );
  }

  Widget sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        text,
        style: TextStyle(
          color: selectedSkin.color,
          fontSize: 22,
          fontWeight: FontWeight.w900,
          letterSpacing: 2,
          shadows: [
            Shadow(
              color: selectedSkin.color.withOpacity(0.6),
              blurRadius: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget modeButton(
    String title,
    String subtitle,
    IconData icon,
    GameMode mode,
  ) {
    final selected = selectedMode == mode;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMode = mode;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        width: 170,
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: selected
              ? LinearGradient(
                  colors: [
                    selectedSkin.color,
                    selectedSkin.color.withOpacity(0.7),
                  ],
                )
              : null,
          color: selected ? null : Colors.white10,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: selected ? Colors.white : Colors.white12,
            width: 2,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: selectedSkin.color.withOpacity(0.45),
                    blurRadius: 25,
                  ),
                ]
              : [],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 34,
              color: selected ? Colors.black : Colors.white,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: selected ? Colors.black : Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: selected ? Colors.black87 : Colors.white54,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget optionSwitch({
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(
          0.05,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: SwitchListTile(
        value: value,
        activeColor: selectedSkin.color,
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }

  Widget gridButton(int size) {
    final selected = gridSize == size;

    return GestureDetector(
      onTap: () {
        setState(() {
          gridSize = size;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.symmetric(
          horizontal: 22,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: selected ? selectedSkin.color : Colors.white10,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          '$size x $size',
          style: TextStyle(
            color: selected ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030712),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF020617),
              Color(0xFF0F172A),
              Color(0xFF111827),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(
                    Icons.auto_awesome,
                    color: selectedSkin.color,
                    size: 52,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'SNAKE EVOLUTION',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: selectedSkin.color,
                      fontSize: 44,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 3,
                      shadows: [
                        Shadow(
                          color: selectedSkin.color.withOpacity(
                            0.7,
                          ),
                          blurRadius: 30,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'NEXT GEN ARCADE EXPERIENCE',
                    style: TextStyle(
                      color: Colors.white54,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 45),
                  sectionTitle(
                    'GAME MODES',
                  ),
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      modeButton(
                        'ARCADE',
                        'Classic competitive mode',
                        Icons.sports_esports,
                        GameMode.arcade,
                      ),
                      modeButton(
                        'HARDCORE',
                        'One mistake = defeat',
                        Icons.warning_amber,
                        GameMode.hardcore,
                      ),
                      modeButton(
                        'ZEN',
                        'Relax and survive',
                        Icons.spa,
                        GameMode.zen,
                      ),
                      modeButton(
                        'TIME ATTACK',
                        'Race against time',
                        Icons.timer,
                        GameMode.timeAttack,
                      ),
                      modeButton(
                        'CHAOS',
                        'Random events',
                        Icons.bolt,
                        GameMode.chaos,
                      ),
                      modeButton(
                        'RANDOM MIX',
                        'Random events + chaos',
                        Icons.auto_awesome,
                        GameMode.randomMix,
                      ),
                      modeButton(
                        'INFINITY',
                        'Infinite map teleport',
                        Icons.all_inclusive,
                        GameMode.infinity,
                      ),

                      modeButton(
                        'MULTIPLAYER',
                        '2 Players Local',
                        Icons.people,
                        GameMode.multiplayer,
                      ),

                      modeButton(
                        'SURVIVAL',
                        'Extreme survival',
                        Icons.local_fire_department,
                        GameMode.survival,
                      ),

                      modeButton(
                        'IMPOSSIBLE',
                        'Maximum speed',
                        Icons.whatshot,
                        GameMode.impossible,
                      ),
                      modeButton(
                        'GHOST',
                        'Phasing abilities',
                        Icons.visibility_off,
                        GameMode.ghost,
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  sectionTitle(
                    'GRID SIZE',
                  ),
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      gridButton(15),
                      gridButton(20),
                      gridButton(30),
                      gridButton(40),
                    ],
                  ),
                  const SizedBox(height: 40),
                  sectionTitle(
                    'SKINS',
                  ),
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: skins.map((skin) {
                      final selected = selectedSkin == skin;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedSkin = skin;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(
                            milliseconds: 200,
                          ),
                          margin: const EdgeInsets.all(
                            10,
                          ),
                          width: 82,
                          height: 82,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                skin.color,
                                skin.color.withOpacity(
                                  0.6,
                                ),
                              ],
                            ),
                            border: Border.all(
                              color:
                                  selected ? Colors.white : Colors.transparent,
                              width: 4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: skin.color.withOpacity(
                                  0.55,
                                ),
                                blurRadius: 22,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              skin.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 40),
                  sectionTitle(
                    'SKILLS',
                  ),
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: skills.map((skill) {
                      final selected = selectedSkill == skill;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedSkill = skill;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(
                            milliseconds: 220,
                          ),
                          width: 170,
                          margin: const EdgeInsets.all(
                            10,
                          ),
                          padding: const EdgeInsets.all(
                            18,
                          ),
                          decoration: BoxDecoration(
                            color:
                                selected ? selectedSkin.color : Colors.white10,
                            borderRadius: BorderRadius.circular(
                              20,
                            ),
                            border: Border.all(
                              color: selected ? Colors.white : Colors.white12,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                skill.icon,
                                size: 36,
                                color: selected ? Colors.black : Colors.white,
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Text(
                                skill.name,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: selected ? Colors.black : Colors.white,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 40),
                  sectionTitle(
                    'OPTIONS',
                  ),
                  optionSwitch(
                    title: 'Dynamic Fruits',
                    value: movingFruit,
                    onChanged: (v) {
                      setState(() {
                        movingFruit = v;
                      });
                    },
                  ),
                  optionSwitch(
                    title: 'Particle Effects',
                    value: particles,
                    onChanged: (v) {
                      setState(() {
                        particles = v;
                      });
                    },
                  ),
                  optionSwitch(
                    title: 'Screen Shake',
                    value: screenShake,
                    onChanged: (v) {
                      setState(() {
                        screenShake = v;
                      });
                    },
                  ),
                  optionSwitch(
                    title: 'Neon Grid',
                    value: neonGrid,
                    onChanged: (v) {
                      setState(() {
                        neonGrid = v;
                      });
                    },
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ShopScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white10,
                      foregroundColor: Colors.white,
                      padding:
                          const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    ),
                    child: const Text(
                      'LOJA',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: startGame,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedSkin.color,
                      foregroundColor: Colors.black,
                      elevation: 12,
                      shadowColor: selectedSkin.color,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 100,
                        vertical: 26,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          24,
                        ),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.play_arrow,
                          size: 30,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'START GAME',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 22,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
