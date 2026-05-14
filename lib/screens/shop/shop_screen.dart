import 'package:flutter/material.dart';

import '../../game/player_data.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() =>
      _ShopScreenState();
}

class _ShopScreenState
    extends State<ShopScreen> {
  Widget item({
    required String title,
    required String description,
    required int price,
    required bool owned,
    required VoidCallback onBuy,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 12,
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius:
            BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            description,
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),

          const SizedBox(height: 18),

          ElevatedButton(
            onPressed:
                owned ? null : onBuy,
            child: Text(
              owned
                  ? 'COMPRADO'
                  : '$price MOEDAS',
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF050816),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'LOJA • ${PlayerData.coins} moedas',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            item(
              title: 'Rainbow Trail',
              description:
                  'Rastro RGB animado.',
              price: 100,
              owned:
                  PlayerData
                      .ownsRainbowTrail,
              onBuy: () {
                if (PlayerData.buyItem(
                  100,
                )) {
                  setState(() {
                    PlayerData
                            .ownsRainbowTrail =
                        true;
                  });
                }
              },
            ),

            item(
              title: 'Shadow FX',
              description:
                  'Sombras cinematográficas.',
              price: 140,
              owned:
                  PlayerData
                      .ownsShadowEffect,
              onBuy: () {
                if (PlayerData.buyItem(
                  140,
                )) {
                  setState(() {
                    PlayerData
                            .ownsShadowEffect =
                        true;
                  });
                }
              },
            ),

            item(
              title: 'Infinity Mode',
              description:
                  'Mapa atravessável.',
              price: 250,
              owned:
                  PlayerData
                      .ownsInfinityMode,
              onBuy: () {
                if (PlayerData.buyItem(
                  250,
                )) {
                  setState(() {
                    PlayerData
                            .ownsInfinityMode =
                        true;
                  });
                }
              },
            ),

            item(
              title: 'Ultra Speed',
              description:
                  'Velocidade extrema.',
              price: 300,
              owned:
                  PlayerData
                      .ownsUltraSpeed,
              onBuy: () {
                if (PlayerData.buyItem(
                  300,
                )) {
                  setState(() {
                    PlayerData
                            .ownsUltraSpeed =
                        true;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}