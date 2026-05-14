class PlayerData {
  static int coins = 0;

  static final List<String> unlockedSkins = [
    'NEON',
  ];

  static bool ownsRainbowTrail = false;

  static bool ownsShadowEffect = false;

  static bool ownsInfinityMode = false;

  static bool ownsUltraSpeed = false;

  static void addCoins(int amount) {
    coins += amount;
  }

  static bool buyItem(int price) {
    if (coins < price) {
      return false;
    }

    coins -= price;

    return true;
  }
}