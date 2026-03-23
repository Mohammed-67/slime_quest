import 'package:flutter/material.dart';

enum SlimeElement {
  fire,
  water,
  earth,
  wind,
  light,
  dark;

  Color get color {
    switch (this) {
      case SlimeElement.fire: return Colors.orange;
      case SlimeElement.water: return Colors.blue;
      case SlimeElement.earth: return Colors.brown;
      case SlimeElement.wind: return Colors.greenAccent;
      case SlimeElement.light: return Colors.yellow;
      case SlimeElement.dark: return Colors.purple;
    }
  }

  IconData get icon {
    switch (this) {
      case SlimeElement.fire: return Icons.local_fire_department;
      case SlimeElement.water: return Icons.water_drop;
      case SlimeElement.earth: return Icons.terrain;
      case SlimeElement.wind: return Icons.air;
      case SlimeElement.light: return Icons.wb_sunny;
      case SlimeElement.dark: return Icons.nightlight_round;
    }
  }

  String get label => name[0].toUpperCase() + name.substring(1);
}

enum SlimeRarity {
  common,
  uncommon,
  rare,
  epic,
  legendary,
  mythic;

  Color get color {
    switch (this) {
      case SlimeRarity.common: return Colors.grey;
      case SlimeRarity.uncommon: return Colors.green;
      case SlimeRarity.rare: return Colors.blue;
      case SlimeRarity.epic: return Colors.purple;
      case SlimeRarity.legendary: return Colors.orange;
      case SlimeRarity.mythic: return Colors.redAccent;
    }
  }

  int get stars {
    switch (this) {
      case SlimeRarity.common: return 1;
      case SlimeRarity.uncommon: return 2;
      case SlimeRarity.rare: return 3;
      case SlimeRarity.epic: return 4;
      case SlimeRarity.legendary: return 5;
      case SlimeRarity.mythic: return 6;
    }
  }
}

enum SkillType { physical, magical, buff, heal }

class SlimeSkill {
  final String id;
  final String name;
  final String description;
  final double damageMultiplier;
  final int cooldown;
  final SkillType type;

  const SlimeSkill({
    required this.id,
    required this.name,
    required this.description,
    this.damageMultiplier = 1.0,
    this.cooldown = 0,
    this.type = SkillType.physical,
  });
}

class SlimeStats {
  final int hp;
  final int atk;
  final int def;
  final int spd;

  const SlimeStats({
    required this.hp,
    required this.atk,
    required this.def,
    required this.spd,
  });

  int get power => (hp ~/ 10) + atk + def + (spd ~/ 2);
}

class SlimeModel {
  final String id;
  final String name;
  final String description;
  final SlimeElement element;
  final SlimeRarity rarity;
  final int level;
  final int exp;
  final SlimeStats baseStats;
  final List<SlimeSkill> skills;
  final String? imageKey;

  const SlimeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.element,
    required this.rarity,
    this.level = 1,
    this.exp = 0,
    required this.baseStats,
    required this.skills,
    this.imageKey,
  });

  int get maxHp => baseStats.hp + (level * 20);
  int get atk => baseStats.atk + (level * 5);
  int get def => baseStats.def + (level * 3);
  int get spd => baseStats.spd + (level * 1);
  int get maxExp => level * 100;
  int get power => (maxHp ~/ 10) + atk + def + (spd ~/ 2);
  int get maxLevel => rarity.stars * 20;

  SlimeModel copyWith({
    String? id,
    String? name,
    String? description,
    SlimeElement? element,
    SlimeRarity? rarity,
    int? level,
    int? exp,
    SlimeStats? baseStats,
    List<SlimeSkill>? skills,
    String? imageKey,
  }) {
    return SlimeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      element: element ?? this.element,
      rarity: rarity ?? this.rarity,
      level: level ?? this.level,
      exp: exp ?? this.exp,
      baseStats: baseStats ?? this.baseStats,
      skills: skills ?? this.skills,
      imageKey: imageKey ?? this.imageKey,
    );
  }
}
