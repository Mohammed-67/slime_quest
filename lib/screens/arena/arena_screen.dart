import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/app_theme.dart';
import '../../widgets/game_button.dart';

class ArenaScreen extends StatelessWidget {
  const ArenaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A0033), AppTheme.surfaceDark, Color(0xFF0D001A)],
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
                    Text('Arena', style: AppTheme.titleMedium),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppTheme.accentOrange.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.confirmation_number, size: 14, color: AppTheme.accentOrange),
                          const SizedBox(width: 4),
                          Text('5/5', style: AppTheme.labelBold.copyWith(color: AppTheme.accentOrange)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Rank display
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4A148C), Color(0xFF311B92)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.3)),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.midPurple.withValues(alpha: 0.3),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(Icons.emoji_events, size: 50, color: AppTheme.accentGold),
                    const SizedBox(height: 8),
                    Text('Your Rank', style: AppTheme.bodySmall),
                    Text('#9,999', style: AppTheme.titleLarge.copyWith(color: AppTheme.accentGold, fontSize: 36)),
                    const SizedBox(height: 8),
                    Text('Silver Division', style: AppTheme.bodyLarge.copyWith(color: AppTheme.textSecondary)),
                  ],
                ),
              ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.9, 0.9)),
              
              // Opponents
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text('Opponents', style: AppTheme.titleSmall.copyWith(fontSize: 15)),
                    const Spacer(),
                    TextButton.icon(
                      icon: const Icon(Icons.refresh, size: 16, color: AppTheme.accentCyan),
                      label: Text('Refresh', style: AppTheme.bodySmall.copyWith(color: AppTheme.accentCyan)),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: 5,
                  itemBuilder: (context, i) {
                    final names = ['SlimeKing99', 'DarkLord007', 'GreenWarrior', 'AquaMaster', 'FireStorm'];
                    final powers = [8500, 7200, 6800, 5400, 4200];
                    final ranks = [9990 + i, 9985 + i, 9980 + i, 9975 + i, 9970 + i];
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: AppTheme.cardDark.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.3)),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppTheme.midPurple,
                          child: Text('${i + 1}', style: AppTheme.labelBold),
                        ),
                        title: Text(names[i], style: AppTheme.bodyLarge.copyWith(color: AppTheme.textPrimary)),
                        subtitle: Row(
                          children: [
                            Text('Rank #${ranks[i]}', style: AppTheme.bodySmall),
                            const SizedBox(width: 10),
                            Icon(Icons.bolt, size: 12, color: AppTheme.accentOrange),
                            Text(' ${powers[i]}', style: AppTheme.bodySmall.copyWith(color: AppTheme.accentOrange)),
                          ],
                        ),
                        trailing: SizedBox(
                          width: 80,
                          child: GameButton(
                            text: 'Fight',
                            height: 35.0,
                            gradient: const LinearGradient(
                              colors: [AppTheme.hpRed, Color(0xFFB71C1C)],
                            ),
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('You defeated ${names[i]}!'),
                                  backgroundColor: AppTheme.slimeGreenDark,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ).animate()
                      .fadeIn(delay: Duration(milliseconds: i * 100), duration: 400.ms)
                      .slideX(begin: 0.1, end: 0);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
