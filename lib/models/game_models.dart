import 'package:equatable/equatable.dart';

enum EquipSlot { weapon, armor, helmet, boots, ring, necklace }
enum EquipRarity { common, uncommon, rare, epic, legendary, mythic }

class EquipmentModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final EquipSlot slot;
  final EquipRarity rarity;
  final int level;
  final int maxLevel;
  final int enhanceLevel;
  final int maxEnhanceLevel;
  final EquipStats stats;
  final List<EquipPotential> potentials;
  final String imageKey;

  const EquipmentModel({
    required this.id,
    required this.name,
    required this.description,
    required this.slot,
    required this.rarity,
    this.level = 1,
    this.maxLevel = 100,
    this.enhanceLevel = 0,
    this.maxEnhanceLevel = 15,
    this.stats = const EquipStats(),
    this.potentials = const [],
    this.imageKey = 'equip_default',
  });

  int get power {
    final base = stats.atk * 3 + stats.def * 2 + stats.hp ~/ 10 + stats.spd;
    return (base * (1 + enhanceLevel * 0.1)).round();
  }

  EquipmentModel copyWith({
    int? level,
    int? enhanceLevel,
    EquipStats? stats,
    List<EquipPotential>? potentials,
  }) {
    return EquipmentModel(
      id: id,
      name: name,
      description: description,
      slot: slot,
      rarity: rarity,
      level: level ?? this.level,
      maxLevel: maxLevel,
      enhanceLevel: enhanceLevel ?? this.enhanceLevel,
      maxEnhanceLevel: maxEnhanceLevel,
      stats: stats ?? this.stats,
      potentials: potentials ?? this.potentials,
      imageKey: imageKey,
    );
  }

  @override
  List<Object?> get props => [id, name, level, enhanceLevel, rarity];
}

class EquipStats extends Equatable {
  final int hp;
  final int atk;
  final int def;
  final int spd;
  final double critRate;
  final double critDamage;

  const EquipStats({
    this.hp = 0,
    this.atk = 0,
    this.def = 0,
    this.spd = 0,
    this.critRate = 0,
    this.critDamage = 0,
  });

  @override
  List<Object?> get props => [hp, atk, def, spd, critRate, critDamage];
}

class EquipPotential extends Equatable {
  final String id;
  final String statName;
  final double value;
  final bool isPercentage;

  const EquipPotential({
    required this.id,
    required this.statName,
    required this.value,
    this.isPercentage = false,
  });

  @override
  List<Object?> get props => [id, statName, value];
}

class ChapterModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final int chapterNumber;
  final List<StageModel> stages;
  final bool isUnlocked;
  final int starsEarned;
  final int maxStars;

  const ChapterModel({
    required this.id,
    required this.name,
    required this.description,
    required this.chapterNumber,
    this.stages = const [],
    this.isUnlocked = false,
    this.starsEarned = 0,
    this.maxStars = 0,
  });

  ChapterModel copyWith({
    bool? isUnlocked,
    int? starsEarned,
    List<StageModel>? stages,
  }) {
    return ChapterModel(
      id: id,
      name: name,
      description: description,
      chapterNumber: chapterNumber,
      stages: stages ?? this.stages,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      starsEarned: starsEarned ?? this.starsEarned,
      maxStars: maxStars,
    );
  }

  @override
  List<Object?> get props => [id, chapterNumber, isUnlocked, starsEarned];
}

class StageModel extends Equatable {
  final String id;
  final String name;
  final int stageNumber;
  final int staminaCost;
  final int recommendedPower;
  final int waves;
  final List<String> enemyIds;
  final String? bossId;
  final List<RewardItem> rewards;
  final int starsEarned;
  final bool isCompleted;

  const StageModel({
    required this.id,
    required this.name,
    required this.stageNumber,
    this.staminaCost = 6,
    this.recommendedPower = 100,
    this.waves = 3,
    this.enemyIds = const [],
    this.bossId,
    this.rewards = const [],
    this.starsEarned = 0,
    this.isCompleted = false,
  });

  StageModel copyWith({
    int? starsEarned,
    bool? isCompleted,
  }) {
    return StageModel(
      id: id,
      name: name,
      stageNumber: stageNumber,
      staminaCost: staminaCost,
      recommendedPower: recommendedPower,
      waves: waves,
      enemyIds: enemyIds,
      bossId: bossId,
      rewards: rewards,
      starsEarned: starsEarned ?? this.starsEarned,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [id, stageNumber, isCompleted, starsEarned];
}

class RewardItem extends Equatable {
  final String itemId;
  final String name;
  final int amount;
  final String type; // gold, gems, exp, equipment, slime

  const RewardItem({
    required this.itemId,
    required this.name,
    required this.amount,
    required this.type,
  });

  @override
  List<Object?> get props => [itemId, amount, type];
}

class MailModel extends Equatable {
  final String id;
  final String title;
  final String body;
  final DateTime sentAt;
  final DateTime? expiresAt;
  final List<RewardItem> rewards;
  final bool isRead;
  final bool isClaimed;

  const MailModel({
    required this.id,
    required this.title,
    required this.body,
    required this.sentAt,
    this.expiresAt,
    this.rewards = const [],
    this.isRead = false,
    this.isClaimed = false,
  });

  MailModel copyWith({
    bool? isRead,
    bool? isClaimed,
  }) {
    return MailModel(
      id: id,
      title: title,
      body: body,
      sentAt: sentAt,
      expiresAt: expiresAt,
      rewards: rewards,
      isRead: isRead ?? this.isRead,
      isClaimed: isClaimed ?? this.isClaimed,
    );
  }

  @override
  List<Object?> get props => [id, isRead, isClaimed];
}

class AchievementModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final int targetValue;
  final int currentValue;
  final List<RewardItem> rewards;
  final bool isClaimed;
  final String category;

  const AchievementModel({
    required this.id,
    required this.title,
    required this.description,
    required this.targetValue,
    this.currentValue = 0,
    this.rewards = const [],
    this.isClaimed = false,
    this.category = 'general',
  });

  bool get isCompleted => currentValue >= targetValue;
  double get progress => (currentValue / targetValue).clamp(0.0, 1.0);

  AchievementModel copyWith({
    int? currentValue,
    bool? isClaimed,
  }) {
    return AchievementModel(
      id: id,
      title: title,
      description: description,
      targetValue: targetValue,
      currentValue: currentValue ?? this.currentValue,
      rewards: rewards,
      isClaimed: isClaimed ?? this.isClaimed,
      category: category,
    );
  }

  @override
  List<Object?> get props => [id, currentValue, isClaimed];
}
