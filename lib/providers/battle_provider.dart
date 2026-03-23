import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/slime_model.dart';
import '../models/monster_model.dart';

class BattleProvider extends ChangeNotifier {
  final SlimeModel playerSlime;
  final List<MonsterModel> enemies;
  
  int _currentSlimeHp;
  int _currentMonsterHp;
  bool _isPlayerTurn = true;
  bool _isBattleOver = false;
  String? _battleLog;
  
  BattleProvider({
    required this.playerSlime,
    required this.enemies,
  }) :  _currentSlimeHp = playerSlime.baseStats.hp,
        _currentMonsterHp = (enemies.isNotEmpty) ? enemies.first.hp : 0;

  int get currentSlimeHp =>  _currentSlimeHp;
  int get currentMonsterHp =>  _currentMonsterHp;
  bool get isPlayerTurn =>  _isPlayerTurn;
  bool get isBattleOver =>  _isBattleOver;
  String? get battleLog =>  _battleLog;
  MonsterModel? get currentMonster => enemies.isNotEmpty ? enemies.first : null;

  void attack() {
    if (_isBattleOver || !_isPlayerTurn) return;

    final monster = enemies.first;
    final advantage = _getElementalAdvantage(playerSlime.element, monster.element);
    
    // Critical hit chance (base 10%)
    final isCrit = DateTime.now().millisecond % 10 == 0;
    final critMult = isCrit ? 1.5 : 1.0;
    
    // Damage = ((Atk * Adv * Crit) - (Def / 2))
    int rawDamage = (playerSlime.atk * advantage * critMult).round();
    int damage = (rawDamage - (monster.def / 2)).round().clamp(5, 9999);
    
    _currentMonsterHp -= damage;
    _battleLog = "Player's ${playerSlime.name} ${isCrit ? 'CRITICAL ' : ''}dealt $damage damage!";
    
    if (_currentMonsterHp <= 0) {
      _currentMonsterHp = 0;
      _isBattleOver = true;
      _battleLog = "Victory! ${monster.name} defeated.";
    } else {
      _isPlayerTurn = false;
      notifyListeners();
      
      Future.delayed(const Duration(milliseconds: 1000), () {
        monsterAttack();
      });
    }
    notifyListeners();
  }

  void monsterAttack() {
    if (_isBattleOver) return;

    final monster = enemies.first;
    final advantage = _getElementalAdvantage(monster.element, playerSlime.element);
    
    // Damage = ((Atk * Adv) - (Def / 2))
    int rawDamage = (monster.atk * advantage).round();
    int damage = (rawDamage - (playerSlime.def / 2)).round().clamp(5, 9999);
    
    _currentSlimeHp -= damage;
    _battleLog = "${monster.name} attacked for $damage damage!";
    
    if (_currentSlimeHp <= 0) {
      _currentSlimeHp = 0;
      _isBattleOver = true;
      _battleLog = "Defeat! Slime collapsed.";
    } else {
      _isPlayerTurn = true;
    }
    notifyListeners();
  }

  double _getElementalAdvantage(SlimeElement attacker, SlimeElement defender) {
    // Fire > Wind > Earth > Water > Fire
    if (attacker == SlimeElement.fire && defender == SlimeElement.wind) return 1.5;
    if (attacker == SlimeElement.wind && defender == SlimeElement.earth) return 1.5;
    if (attacker == SlimeElement.earth && defender == SlimeElement.water) return 1.5;
    if (attacker == SlimeElement.water && defender == SlimeElement.fire) return 1.5;
    
    // Light <-> Dark
    if (attacker == SlimeElement.light && defender == SlimeElement.dark) return 1.5;
    if (attacker == SlimeElement.dark && defender == SlimeElement.light) return 1.5;
    
    // Resistance (optional, typically 0.5x or 0.8x)
    if (attacker == SlimeElement.wind && defender == SlimeElement.fire) return 0.7;
    if (attacker == SlimeElement.earth && defender == SlimeElement.wind) return 0.7;
    if (attacker == SlimeElement.water && defender == SlimeElement.earth) return 0.7;
    if (attacker == SlimeElement.fire && defender == SlimeElement.water) return 0.7;
    
    return 1.0;
  }
}
