import 'package:equatable/equatable.dart';
import '../models/slime_model.dart';
import 'package:flutter/material.dart';

class MonsterModel extends Equatable {
  final String id;
  final String name;
  final int level;
  final int hp;
  final int maxHp;
  final int atk;
  final int def;
  final int spd;
  final String imageKey;
  final SlimeElement element;

  const MonsterModel({
    required this.id,
    required this.name,
    this.level = 1,
    required this.hp,
    required this.maxHp,
    required this.atk,
    this.def = 0,
    this.spd = 100,
    required this.imageKey,
    this.element = SlimeElement.earth,
  });

  @override
  List<Object?> get props => [id, name, hp, level];
}

class BattleAction extends Equatable {
  final String attackerId;
  final String targetId;
  final int damage;
  final bool isCrit;
  final String? skillName;
  final Color effectColor;

  const BattleAction({
    required this.attackerId,
    required this.targetId,
    required this.damage,
    this.isCrit = false,
    this.skillName,
    this.effectColor = Colors.white,
  });

  @override
  List<Object?> get props => [attackerId, targetId, damage, skillName];
}
