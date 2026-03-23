// ═══════════════════════════════════════════
// 📊 GAME CONSTANTS - Extracted from ZTL tables
// ═══════════════════════════════════════════

class GameConstants {
  // Player defaults
  static const int startingLevel = 1;
  static const int maxLevel = 300;
  static const int startingGold = 100;
  static const int startingGems = 50;
  static const int startingStamina = 120;
  static const int maxStamina = 120;
  static const int staminaRegenMinutes = 5;

  // Battle _static const int maxTeamSize = 5;
  static const int maxWaves = 10;
  static const double baseCritRate = 0.05;
  static const double baseCritDamage = 1.5;
  static const int battleSpeedMultiplier = 2;
  
  // Gacha _static const int gachaSingleCost = 300;
  static const int gacha10Cost = 2700;
  static const double gachaRareRate = 0.80;
  static const double gachaEpicRate = 0.15;
  static const double gachaLegendaryRate = 0.04;
  static const double gachaMythicRate = 0.01;
  
  // Equipment _static const int maxEquipLevel = 100;
  static const int maxEquipEnhance = 15;
  static const int maxPotentialSlots = 4;
  
  // Arena _static const int arenaTicketsPerDay = 5;
  static const int arenaTicketCostGem = 50;
  
  // Raid _static const int raidTicketsPerDay = 3;
  static const int maxRaidPlayers = 30;
  
  // Season Pass _static const int seasonPassMaxLevel = 100;
  
  // Housing _static const int maxHousingItems = 50;
}

class AssetPaths {
  static const String images = 'assets/images/';
  static const String audio = 'assets/audio/';
  static const String data = 'assets/data/';
}
