import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/app_theme.dart';
import '../../providers/game_provider.dart';
import '../../models/slime_model.dart';
import '../../widgets/slime_avatar.dart';
import '../../widgets/stat_bar.dart';

class TeamScreen extends StatelessWidget {
  const TeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, game, child) {
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppTheme.deepPurple, AppTheme.surfaceDark],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                   _buildAppBar(context, game),
                  
                  // Team slots
                  Container(
                    height: 130,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(5, (i) {
                        final hasSlime = i < game.teamSlimes.length;
                        return _buildTeamSlot(context, game, i, hasSlime ? game.teamSlimes[i] : null);
                      }),
                    ),
                  ).animate().fadeIn(duration: 500.ms),
                  
                  // Power display
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: AppTheme.glassDecoration,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.bolt, color: AppTheme.accentOrange, size: 20),
                        const SizedBox(width: 6),
                        Text('Team Power: ', style: AppTheme.bodyMedium),
                        Text(
                          '${game.totalPower}',
                          style: AppTheme.titleSmall.copyWith(color: AppTheme.accentOrange),
                        ),
                      ],
                    ),
                  ),
                  
                  // Divider
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Text('Owned Slimes (${game.ownedSlimes.length})', style: AppTheme.titleSmall.copyWith(fontSize: 15)),
                        const Spacer(),
                        Icon(Icons.sort, color: AppTheme.textMuted, size: 18),
                      ],
                    ),
                  ),
                  
                  // Owned slimes grid
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: game.ownedSlimes.length,
                      itemBuilder: (context, i) {
                        return _buildSlimeCard(context, game, game.ownedSlimes[i], i);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBar(BuildContext context, GameProvider game) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppTheme.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
          Text('Team', style: AppTheme.titleMedium),
        ],
      ),
    );
  }

  Widget _buildTeamSlot(BuildContext context, GameProvider game, int index, SlimeModel? slime) {
    return GestureDetector(
      onTap: slime != null ? () => _showSlimeDetail(context, game, slime) : null,
      onLongPress: slime != null ? () => game.removeFromTeam(slime.id) : null,
      child: SizedBox(
        width: 60,
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: slime != null ? null : AppTheme.cardDark,
                border: Border.all(
                  color: slime != null 
                      ? slime.rarity.color.withValues(alpha: 0.6) 
                      : AppTheme.textMuted.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: slime != null
                  ? SlimeAvatar(element: slime.element, rarity: slime.rarity, size: 52, showGlow: false, imageKey: slime.imageKey)
                  : Icon(Icons.add, color: AppTheme.textMuted.withValues(alpha: 0.5), size: 24),
            ),
            const SizedBox(height: 4),
            if (slime != null) ...[
              Text(
                slime.name,
                style: TextStyle(color: slime.rarity.color, fontSize: 10, fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text('Lv.${slime.level}', style: AppTheme.bodySmall.copyWith(fontSize: 9)),
            ] else
              Text('Slot ${index + 1}', style: AppTheme.bodySmall.copyWith(fontSize: 9)),
          ],
        ),
      ),
    );
  }

  Widget _buildSlimeCard(BuildContext context, GameProvider game, SlimeModel slime, int index) {
    final isInTeam = game.teamSlimes.any((s) => s.id == slime.id);
    
    return GestureDetector(
      onTap: () => _showSlimeDetail(context, game, slime),
      child: Container(
        decoration: AppTheme.rarityBorder(slime.rarity.color),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  SlimeAvatar(element: slime.element, rarity: slime.rarity, size: 50, showGlow: false, imageKey: slime.imageKey),
                  const SizedBox(height: 4),
                  Text(
                    slime.name,
                    style: TextStyle(color: slime.rarity.color, fontSize: 11, fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(slime.element.icon, size: 10, color: slime.element.color),
                      const SizedBox(width: 2),
                      Text('Lv.${slime.level}', style: AppTheme.bodySmall.copyWith(fontSize:9.0)),
 ],
 ),
 Text('_${slime.power}', style: AppTheme.bodySmall.copyWith(fontSize: 9, color: AppTheme.accentOrange)),
                ],
              ),
            ),
            if (isInTeam)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: AppTheme.slimeGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, size: 10, color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    ).animate()
      .fadeIn(delay: Duration(milliseconds: index * 50), duration: 300.ms)
      .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1), delay: Duration(milliseconds: index * 50));
  }

  void _showSlimeDetail(BuildContext context, GameProvider game, SlimeModel slime) {
    final isInTeam = game.teamSlimes.any((s) => s.id == slime.id);
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.surfaceLight,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: slime.rarity.color.withValues(alpha: 0.3)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.textMuted,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              SlimeAvatar(element: slime.element, rarity: slime.rarity, size: 90, imageKey: slime.imageKey),
              const SizedBox(height: 12),
              Text(slime.name, style: AppTheme.titleMedium.copyWith(color: slime.rarity.color)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(slime.rarity.stars, (i) => 
                  Icon(Icons.star, size: 16, color: slime.rarity.color)),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(slime.element.icon, size: 14, color: slime.element.color),
                  const SizedBox(width: 4),
                  Text(slime.element.label, style: AppTheme.bodySmall.copyWith(color: slime.element.color)),
                  const SizedBox(width: 12),
                  Text('Lv.${slime.level}/${slime.maxLevel}', style: AppTheme.bodySmall),
                  const SizedBox(width: 12),
                  Text('${slime.power}', style: AppTheme.bodySmall.copyWith(color: AppTheme.accentOrange)),
                ],
              ),
              const SizedBox(height: 16),
              
              _statRow('ATK', slime.baseStats.atk, AppTheme.accentOrange),
              _statRow('DEF', slime.baseStats.def, AppTheme.accentCyan),
              _statRow('SPD', slime.baseStats.spd, AppTheme.slimeGreen),
              
              const SizedBox(height: 12),
              
              if (slime.skills.isNotEmpty) ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Skills', style: AppTheme.labelBold),
                ),
                const SizedBox(height: 8),
                ...slime.skills.map((sk) => Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.cardDark.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        sk.type == SkillType.heal ? Icons.favorite : Icons.flash_on,
                        size: 16.0,
                        color: sk.type == SkillType.heal ? AppTheme.slimeGreen : AppTheme.accentOrange,
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(child: Text(sk.name, style: AppTheme.bodyMedium.copyWith(color: AppTheme.textPrimary))),
                      Text('${sk.damageMultiplier.toStringAsFixed(1)}x', style: AppTheme.bodySmall),
                    ],
                  ),
                )),
              ],
              
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isInTeam ? AppTheme.hpRed : AppTheme.slimeGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        if (isInTeam) {
                          game.removeFromTeam(slime.id);
                        } else {
                          game.addToTeam(slime);
                        }
                        Navigator.pop(context);
                      },
                      child: Text(isInTeam ? 'Remove' : 'Add to Team'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentCyan,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        game.levelUpSlime(slime.id);
                        Navigator.pop(context);
                      },
                      child: const Text('Level Up'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statRow(String label, int value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(width: 40, child: Text(label, style: AppTheme.bodySmall.copyWith(fontWeight: FontWeight.w600))),
          Expanded(child: StatBar(label: '', value: value.toDouble(), maxValue: 2000, color: color, height: 6, showLabel: false)),
          const SizedBox(width: 8),
          SizedBox(width: 40, child: Text('$value', style: AppTheme.bodySmall.copyWith(color: color), textAlign: TextAlign.right)),
        ],
      ),
    );
  }
}

