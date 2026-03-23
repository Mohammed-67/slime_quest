import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/app_theme.dart';
import '../../providers/game_provider.dart';
import '../../widgets/stat_bar.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, game, child) {
        final completed = game.achievements.where((a) => a.isCompleted).length;
        
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1A0E3E), AppTheme.surfaceDark],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.textPrimary),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Text('Achievements', style: AppTheme.titleMedium),
                        const Spacer(),
                        Text('$completed/${game.achievements.length}', style: AppTheme.bodySmall.copyWith(color: AppTheme.accentGold)),
                      ],
                    ),
                  ),
                  
                  // Progress
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: AppTheme.glassDecoration,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.emoji_events, color: AppTheme.accentGold, size: 24),
                            const SizedBox(width: 8),
                            Text('Overall Progress', style: AppTheme.titleSmall.copyWith(fontSize: 15)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        StatBar(
                          label: '',
                          value: completed.toDouble(),
                          maxValue: game.achievements.length.toDouble(),
                          color: AppTheme.accentGold,
                          height: 8,
                          showLabel: false,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$completed / ${game.achievements.length} (${(completed / game.achievements.length * 100).toInt()}%)',
                          style: AppTheme.bodySmall.copyWith(color: AppTheme.accentGold),
                        ),
                      ],
                    ),
                  ),
                  
                  // List
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: game.achievements.length,
                      itemBuilder: (context, i) {
                        final ach = game.achievements[i];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: ach.isCompleted
                                ? AppTheme.accentGold.withValues(alpha: 0.08)
                                : AppTheme.cardDark.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: ach.isCompleted
                                  ? AppTheme.accentGold.withValues(alpha: 0.3)
                                  : AppTheme.accentGold.withValues(alpha: 0.1),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: ach.isCompleted
                                        ? AppTheme.accentGold.withValues(alpha: 0.2)
                                        : AppTheme.cardMedium,
                                  ),
                                  child: Icon(
                                    ach.isCompleted ? Icons.check_circle : Icons.emoji_events_outlined,
                                    color: ach.isCompleted ? AppTheme.accentGold : AppTheme.textMuted,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        ach.title,
                                        style: AppTheme.bodyLarge.copyWith(
                                          color: ach.isCompleted ? AppTheme.accentGold : AppTheme.textPrimary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(ach.description, style: AppTheme.bodySmall),
                                      const SizedBox(height: 6),
                                      StatBar(
                                        label: '',
                                        value: ach.currentValue.toDouble(),
                                        maxValue: ach.targetValue.toDouble(),
                                        color: ach.isCompleted ? AppTheme.accentGold : AppTheme.slimeGreen,
                                        height: 4,
                                        showLabel: false,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${ach.currentValue}/${ach.targetValue}',
                                        style: AppTheme.bodySmall.copyWith(fontSize: 10),
                                      ),
                                    ],
                                  ),
                                ),
                                if (ach.rewards.isNotEmpty)
                                  Column(
                                    children: ach.rewards.map((r) => Text(
                                      '${r.type == 'gems' ? '💎' : '🪙'} ${r.amount}',
                                      style: AppTheme.bodySmall.copyWith(
                                        color: r.type == 'gem' ? AppTheme.accentCyan : AppTheme.accentGold,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 11,
                                      ),
                                    )).toList(),
                                  ),
                              ],
                            ),
                          ),
                        ).animate()
                          .fadeIn(delay: Duration(milliseconds: i * 60), duration: 300.ms)
                          .slideX(begin: 0.05, end: 0);
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
}
