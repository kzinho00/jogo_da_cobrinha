import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'snake_game.dart';

void main() {
  runApp(const SnakeGameApp());
}

class SnakeGameApp extends StatelessWidget {
  const SnakeGameApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snake Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: Colors.green,
        fontFamily: GoogleFonts.pressStart2p().fontFamily,
      ),
      home: const SnakeGameScreen(),
    );
  }
}

class SnakeGameScreen extends StatefulWidget {
  const SnakeGameScreen({super.key});
  
  @override
  State<SnakeGameScreen> createState() => _SnakeGameScreenState();
}

class _SnakeGameScreenState extends State<SnakeGameScreen> {
  late SnakeGame game;
  
  @override
  void initState() {
    super.initState();
    game = SnakeGame();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.green.shade900,
                  Colors.teal.shade900,
                ],
              ),
            ),
          ),
          Center(
            child: Card(
              elevation: 20,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: GameWidget(game: game),
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(30),
                backdropFilter: BlurFilter(5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.score, color: Colors.yellow),
                      const SizedBox(width: 10),
                      Text(
                        'Score: ${game.score}',
                        style: GoogleFonts.pressStart2p(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  if (game.isGameOver)
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          game = SnakeGame();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('Restart'),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}