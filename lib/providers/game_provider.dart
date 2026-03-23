import 'package:flutter/material.dart';
import '../models/player_model.dart';
import '../models/slime_model.dart';
import '../models/game_models.dart';
import '../data/game_data.dart';

class GameProvider with ChangeNotifier {
  Player? _player;
  List<SlimeModel> _ownedSlimes = [];
  List<SlimeModel> _teamSlimes = [];
  final List<EquipmentModel> _inventory = [];
  List<ChapterModel> _chapters = [];
  ChapterModel? _currentChapter;
  List<MailModel> _mails = [];
  int _unreadMails = 0;
  List<AchievementModel> _achievements = [];
  
  bool _isInBattle = false;
  final int _currentWave = 1;
  int _gachaPity = 0;
  int _currentTab = 0;
  
  final int _arenaRank = 1000;
  final int _arenaTickets = 5;
  
  final bool _slimePassActive = false;

  // Getters
  Player? get player => _player;
  List<SlimeModel> get ownedSlimes => _ownedSlimes;
  List<SlimeModel> get teamSlimes => _teamSlimes;
  List<EquipmentModel> get inventory => _inventory;
  List<ChapterModel> get chapters => _chapters;
  ChapterModel? get currentChapter => _currentChapter;
  List<MailModel> get mails => _mails;
  int get unreadMails => _unreadMails;
  List<AchievementModel> get achievements => _achievements;
  bool get isInBattle => _isInBattle;
  int get currentWave => _currentWave;
  int get currentTab => _currentTab;
  int get totalPower => _teamSlimes.fold(0, (sum, s) => sum + s.power);
  int get gachaPity => _gachaPity;
  bool get slimePassActive => _slimePassActive;
  int get arenaRank => _arenaRank;
  int get arenaTickets => _arenaTickets;

  void setTab(int index) {
    _currentTab = index;
    notifyListeners();
  }

  void initGame() {
    _player = Player(
      id: 'p_001',
      name: 'SlimeHunter',
      level: 5,
      exp: 450,
      gems: 1250,
      gold: 45000,
      stamina: 80,
      maxStamina: 100,
    );

    _ownedSlimes = List.from(GameData.starterSlimes);
    _teamSlimes = [_ownedSlimes[0]];
    
    _chapters = GameData.sampleChapters;
    _currentChapter = _chapters.first;
    
    _mails = GameData.sampleMails;
    _unreadMails = _mails.where((m) => !m.isRead).length;
    
    _achievements = GameData.sampleAchievements;
    
    notifyListeners();
  }

  void addGold(int amount) {
    if (_player == null) return;
    _player = _player!.copyWith(gold: _player!.gold + amount);
    notifyListeners();
  }

  void addGems(int amount) {
    if (_player == null) return;
    _player = _player!.copyWith(gems: _player!.gems + amount);
    notifyListeners();
  }

  void spendGems(int amount) {
    addGems(-amount);
  }

  void useStamina(int amount) {
    if (_player == null) return;
    _player = _player!.copyWith(stamina: _player!.stamina - amount);
    notifyListeners();
  }

  void addToTeam(SlimeModel slime) {
    if (_teamSlimes.length < 5 && !_teamSlimes.contains(slime)) {
      _teamSlimes.add(slime);
      notifyListeners();
    }
  }

  void removeFromTeam(String slimeId) {
    _teamSlimes.removeWhere((s) => s.id == slimeId);
    notifyListeners();
  }

  void levelUpSlime(String slimeId) {
    int index = _ownedSlimes.indexWhere((s) => s.id == slimeId);
    if (index != -1) {
      final slime = _ownedSlimes[index];
      if (slime.level < slime.maxLevel) {
        _ownedSlimes[index] = slime.copyWith(level: slime.level + 1);
        
        // Also update in team if present
        int teamIndex = _teamSlimes.indexWhere((s) => s.id == slimeId);
        if (teamIndex != -1) {
          _teamSlimes[teamIndex] = _ownedSlimes[index];
        }
        notifyListeners();
      }
    }
  }

  SlimeModel pullGacha() {
    _gachaPity++;
    SlimeRarity rarity = (_gachaPity % 10 == 0) ? SlimeRarity.epic : SlimeRarity.rare;
    if (_gachaPity % 50 == 0) rarity = SlimeRarity.legendary;
    
    final newSlime = GameData.generateRandomSlime(rarity);
    _ownedSlimes.add(newSlime);
    notifyListeners();
    return newSlime;
  }

  List<SlimeModel> pullGacha10() {
    List<SlimeModel> results = [];
    for (int i = 0; i < 10; i++) {
      results.add(pullGacha());
    }
    return results;
  }

  void startBattle(StageModel stage) {
    _isInBattle = true;
    notifyListeners();
  }

  void markMailAsRead(String mailId) {
    int index = _mails.indexWhere((m) => m.id == mailId);
    if (index != -1 && !_mails[index].isRead) {
      _mails[index] = _mails[index].copyWith(isRead: true);
      _unreadMails = _mails.where((m) => !m.isRead).length;
      notifyListeners();
    }
  }

  void claimMailReward(String mailId) {
    int index = _mails.indexWhere((m) => m.id == mailId);
    if (index != -1 && !_mails[index].isClaimed) {
      final mail = _mails[index];
      for (var reward in mail.rewards) {
        if (reward.type == 'gold') addGold(reward.amount);
        if (reward.type == 'gems') addGems(reward.amount);
      }
      _mails[index] = mail.copyWith(isClaimed: true, isRead: true);
      _unreadMails = _mails.where((m) => !m.isRead).length;
      notifyListeners();
    }
  }

  void endBattle(bool won) {
    _isInBattle = false;
    if (won) {
      addGold(800);
      _player = _player!.copyWith(exp: _player!.exp + 350);
    }
    notifyListeners();
  }

}
