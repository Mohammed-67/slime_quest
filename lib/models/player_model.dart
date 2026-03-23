import 'package:equatable/equatable.dart';

// ═══════════════════════════════════════════
// 🧙 PLAYER MODEL
// ═══════════════════════════════════════════

class Player extends Equatable {
  final String id;
  final String name;
  final int level;
  final int exp;
  final int expToNext;
  final int gold;
  final int gems;
  final int stamina;
  final int maxStamina;
  final int power;
  final PlayerStats stats;
  final List<String> ownedSlimeIds;
  final List<String> teamSlimeIds;
  final String selectedSlimeId;
  final int arenaRank;
  final int arenaTickets;
  final int raidTickets;
  final int slimePieces;
  final int rainbowSlimePieces;

  const Player({
    required this.id,
    required this.name,
    this.level = 1,
    this.exp = 0,
    this.expToNext = 100,
    this.gold = 100,
    this.gems = 50,
    this.stamina = 120,
    this.maxStamina = 120,
    this.power = 100,
    this.stats = const PlayerStats(),
    this.ownedSlimeIds = const [],
    this.teamSlimeIds = const [],
    this.selectedSlimeId = '',
    this.arenaRank = 0,
    this.arenaTickets = 5,
    this.raidTickets = 3,
    this.slimePieces = 0,
    this.rainbowSlimePieces = 0,
  });

  Player copyWith({
    String? id,
    String? name,
    int? level,
    int? exp,
    int? expToNext,
    int? gold,
    int? gems,
    int? stamina,
    int? maxStamina,
    int? power,
    PlayerStats? stats,
    List<String>? ownedSlimeIds,
    List<String>? teamSlimeIds,
    String? selectedSlimeId,
    int? arenaRank,
    int? arenaTickets,
    int? raidTickets,
    int? slimePieces,
    int? rainbowSlimePieces,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
      exp: exp ?? this.exp,
      expToNext: expToNext ?? this.expToNext,
      gold: gold ?? this.gold,
      gems: gems ?? this.gems,
      stamina: stamina ?? this.stamina,
      maxStamina: maxStamina ?? this.maxStamina,
      power: power ?? this.power,
      stats: stats ?? this.stats,
      ownedSlimeIds: ownedSlimeIds ?? this.ownedSlimeIds,
      teamSlimeIds: teamSlimeIds ?? this.teamSlimeIds,
      selectedSlimeId: selectedSlimeId ?? this.selectedSlimeId,
      arenaRank: arenaRank ?? this.arenaRank,
      arenaTickets: arenaTickets ?? this.arenaTickets,
      raidTickets: raidTickets ?? this.raidTickets,
      slimePieces: slimePieces ?? this.slimePieces,
      rainbowSlimePieces: rainbowSlimePieces ?? this.rainbowSlimePieces,
    );
  }

  @override
  List<Object?> get props => [id, name, level, exp, gold, gems, stamina, power];
}

class PlayerStats extends Equatable {
  final int hp;
  final int maxHp;
  final int atk;
  final int def;
  final int spd;
  final double critRate;
  final double critDamage;

  const PlayerStats({
    this.hp = 1000,
    this.maxHp = 1000,
    this.atk = 50,
    this.def = 30,
    this.spd = 100,
    this.critRate = 0.05,
    this.critDamage = 1.5,
  });

  @override
  List<Object?> get props => [hp, maxHp, atk, def, spd, critRate, critDamage];
}
