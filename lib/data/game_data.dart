import 'dart:math';
import '../models/slime_model.dart';
import '../models/game_models.dart';

class GameData {
  static final Random _random = Random();

  static final List<SlimeModel> starterSlimes = [
    const SlimeModel(
      id: 'slime_001',
      name: 'Greeny',
      description: 'A friendly green slime. Your first companion!',
      element: SlimeElement.earth,
      rarity: SlimeRarity.common,
      baseStats: SlimeStats(hp: 800, atk: 45, def: 35, spd: 90),
      skills: [],
      imageKey: '10000_slime',
    ),
    const SlimeModel(
      id: 'slime_002',
      name: 'Blazey',
      description: 'A fiery slime that burns with passion!',
      element: SlimeElement.fire,
      rarity: SlimeRarity.uncommon,
      baseStats: SlimeStats(hp: 600, atk: 60, def: 20, spd: 95),
      skills: [],
      imageKey: '10002_slime',
    ),
  ];

  static const List<SlimeTemplate> slimePool = [
    SlimeTemplate('Verdant King', SlimeElement.earth, SlimeRarity.rare, 1200, 80, 60, 100),
    SlimeTemplate('Inferno Lord', SlimeElement.fire, SlimeRarity.epic, 900, 120, 40, 110),
    SlimeTemplate('Tidal Queen', SlimeElement.water, SlimeRarity.legendary, 1100, 70, 70, 95),
  ];

  static SlimeModel generateRandomSlime(SlimeRarity rarity) {
    final pool = slimePool.where((s) => s.rarity == rarity).toList();
    final template = pool.isNotEmpty ? pool[_random.nextInt(pool.length)] : slimePool[0];
    
    return SlimeModel(
      id: 'slime_${DateTime.now().millisecondsSinceEpoch}',
      name: template.name,
      description: 'A newly summoned ${template.name}!',
      element: template.element,
      rarity: template.rarity,
      baseStats: SlimeStats(
        hp: template.hp,
        atk: template.atk,
        def: template.def,
        spd: template.spd,
      ),
      skills: [],
      imageKey: '10003_slime',
    );
  }

  static final List<ChapterModel> sampleChapters = [
    const ChapterModel(
      id: 'chap_1',
      name: 'Slime Forest',
      description: 'The journey begins in the dense green forest.',
      chapterNumber: 1,
      isUnlocked: true,
      stages: [
        StageModel(id: 'stg_1_1', name: 'Forest Path', stageNumber: 1, recommendedPower: 100),
        StageModel(id: 'stg_1_2', name: 'Deep Thicket', stageNumber: 2, recommendedPower: 250),
      ],
    ),
  ];

  static final List<MailModel> sampleMails = [
    MailModel(
      id: 'mail_1',
      title: 'Welcome Gift',
      body: 'Thank you for playing Slime Quest! Here is a small gift to get you started.',
      sentAt: DateTime.now(),
      rewards: const [
        RewardItem(itemId: 'gold', name: 'Gold', amount: 1000, type: 'gold'),
        RewardItem(itemId: 'gems', name: 'Gems', amount: 100, type: 'gems'),
      ],
    ),
  ];

  static final List<AchievementModel> sampleAchievements = [
    const AchievementModel(
      id: 'ach_1',
      title: 'First Recruit',
      description: 'Summon your first slime.',
      targetValue: 1,
      currentValue: 1,
      rewards: [RewardItem(itemId: 'gems', name: 'Gems', amount: 50, type: 'gems')],
    ),
  ];
}

class SlimeTemplate {
  final String name;
  final SlimeElement element;
  final SlimeRarity rarity;
  final int hp;
  final int atk;
  final int def;
  final int spd;

  const SlimeTemplate(this.name, this.element, this.rarity, this.hp, this.atk, this.def, this.spd);
}
