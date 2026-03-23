import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/app_theme.dart';
import '../../models/monster_model.dart';
import '../../providers/battle_provider.dart';
import '../../providers/game_provider.dart';
import '../../widgets/slime_avatar.dart';
import '../../widgets/game_button.dart';

class BattleScreen extends StatefulWidget {
  const BattleScreen({super.key});

  @override
  State<BattleScreen> createState() =>  BattleScreenState();
}

class BattleScreenState extends State<BattleScreen> {
  bool _isAttacking = false;
  bool _isMonsterAttacking = false;

  @override
  Widget build(BuildContext context) {
    // We assume the game provider selects the current slime and a target monster
    final game = Provider.of<GameProvider>(context, listen: false);
    final slime = game.teamSlimes.isNotEmpty ? game.teamSlimes.first : game.ownedSlimes.first;
    
    // First monster for now (Chicken)
    final monster = const MonsterModel(
      id: "20000",
      name: "Giant Chicken",
      hp: 1200,
      maxHp: 1200,
      atk: 45,
      imageKey: "20000 chicken",
    );

    return ChangeNotifierProvider(
      create: (_) => BattleProvider(playerSlime: slime, enemies: [monster]),
      child: Consumer<BattleProvider>(
        builder: (context, battle, child) {
          return Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF2C1B4D),
                    Color(0xFF0D0628),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Environment Background (BATTLE FIELD)
                  _buildBattlefield(),
                  
                  SafeArea(
                    child: Column(
                      children: [
                        _buildTopInfo(battle),
                        const Spacer(),
                        _buildFighters(battle),
                        const Spacer(),
                        _buildBattleControl(battle),
                      ],
                    ),
                  ),
                  
                  if (battle.isBattleOver)
                    _buildResults(battle),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBattlefield() {
    return Positioned.fill(
      child: Opacity(
        opacity: 0.15,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg battle field.png'), // Need placeholder or real extracted bg
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopInfo(BattleProvider battle) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'CHAPTER 1-1',
            style: AppTheme.labelBold.copyWith(color: AppTheme.accentCyan, letterSpacing: 2),
          ),
          const SizedBox(height: 10),
          // Wave info or Log
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              battle.battleLog ?? "A wild monster appears!",
              style: AppTheme.bodySmall.copyWith(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFighters(BattleProvider battle) {
    return Column(
      children: [
        // Monster (Enemy)
        _buildMonster(battle),
        const SizedBox(height: 50),
        // Player (Slime)
        _buildPlayer(battle),
      ],
    );
  }

  Widget _buildMonster(BattleProvider battle) {
    final monster = battle.currentMonster!;
    final hpProgress = (battle.currentMonsterHp / (monster.maxHp > 0 ? monster.maxHp : 1)).clamp(0.0, 1.0);
    
    return Column(
      children: [
        Text(monster.name, style: AppTheme.titleSmall.copyWith(color: AppTheme.hpRed)),
        const SizedBox(height: 6),
        _buildHealthBar(hpProgress, AppTheme.hpRed),
        const SizedBox(height: 16),
        Image.asset(
          'assets/images/${monster.imageKey}.png',
          width: 140,
          height: 140,
          fit: BoxFit.contain,
          errorBuilder: (c, e, s) => const Icon(Icons.bug_report, size: 80, color: Colors.red),
        ).animate(target: _isMonsterAttacking ? 1 : 0)
         .shake(duration: 300.ms, hz: 4)
         .scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2)),
      ],
    );
  }

  Widget _buildPlayer(BattleProvider battle) {
    final slime = battle.playerSlime;
    final hpProgress = (battle.currentSlimeHp / (slime.baseStats.hp > 0 ? slime.baseStats.hp : 1)).clamp(0.0, 1.0);
    
    return Column(
      children: [
        SlimeAvatar(
          imageKey: slime.imageKey,
          size: 100,
          rarity: slime.rarity,
          element: slime.element,
        ).animate(target: _isAttacking ? 1 : 0)
         .moveY(begin: 0, end: -40, duration: 250.ms, curve: Curves.easeOut)
         .then()
         .moveY(begin: -40, end: 0, duration: 200.ms, curve: Curves.bounceIn),
        const SizedBox(height: 16),
        _buildHealthBar(hpProgress, AppTheme.slimeGreen),
        const SizedBox(height: 6),
        Text('LV.${slime.level} ${slime.name}', style: AppTheme.labelBold),
      ],
    );
  }

  Widget _buildHealthBar(double progress, Color color) {
    return Container(
      width: 200,
      height: 12,
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white24),
      ),
      child: Stack(
        children: [
          FractionallySizedBox(
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 4),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBattleControl(BattleProvider battle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      child: Column(
        children: [
          if (!battle.isBattleOver)
            GameButton(
              text: 'ATTACK!',
              onTap: !battle.isPlayerTurn ? null : () async {
                setState(() => _isAttacking = true);
                battle.attack();
                await Future.delayed(500.ms);
                if (mounted) setState(() => _isAttacking = false);
                
                // Show monster attack anim if it's their turn
                if (!battle.isPlayerTurn && !battle.isBattleOver) {
                  await Future.delayed(500.ms);
                  if (mounted) setState(() => _isMonsterAttacking = true);
                  await Future.delayed(300.ms);
                  if (mounted) setState(() => _isMonsterAttacking = false);
                }
              },
              gradient: const LinearGradient(colors: [Color(0xFFFFA000), Color(0xFFFF6F00)]),
            ),
        ],
      ),
    );
  }

  Widget _buildResults(BattleProvider battle) {
    final win = battle.currentMonsterHp <= 0;
    
    return Container(
      color: Colors.black87,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              win ? "VICTORY!" : "DEFEAT",
              style: AppTheme.titleLarge.copyWith(
                color: win ? AppTheme.accentGold : AppTheme.hpRed,
                fontSize: 48,
              ),
            ).animate().scale(delay: 200.ms, duration: 400.ms, curve: Curves.elasticOut),
            const SizedBox(height: 40),
            GameButton(
              text: "BACK TO LOBBY",
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

