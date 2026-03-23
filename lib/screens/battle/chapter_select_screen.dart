import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/app_theme.dart';
import '../../providers/game_provider.dart';
import '../../widgets/game_button.dart';

class ChapterSelectScreen extends StatelessWidget {
  const ChapterSelectScreen({super.key});

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
                colors: [Color(0xFF1A0E3E), AppTheme.surfaceDark],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // App bar
                  _buildAppBar(context, game),
                  
                  // Chapter list
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: game.chapters.length,
                      itemBuilder: (context, index) {
                        final chapter = game.chapters[index];
                        final isLocked = index > 0;
                        
                        return _buildChapterCard(context, game, chapter, isLocked, index);
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
          Text('Adventure', style: AppTheme.titleMedium),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppTheme.slimeGreen.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.flash_on, size: 14, color: AppTheme.slimeGreen),
                const SizedBox(width: 4),
                Text('${game.player?.stamina ?? 0}', style: AppTheme.labelBold.copyWith(color: AppTheme.slimeGreen)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChapterCard(BuildContext context, GameProvider game, dynamic chapter, bool isLocked, int index) {
    final colors = [
      [const Color(0xFF2E7D32), const Color(0xFF1B5E20)],
      [const Color(0xFF0277BD), const Color(0xFF01579B)],
      [const Color(0xFFE65100), const Color(0xFFBF360C)],
      [const Color(0xFF4FC3F7), const Color(0xFF0288D1)],
      [const Color(0xFF37474F), const Color(0xFF263238)],
      [const Color(0xFF795548), const Color(0xFF4E342E)],
      [const Color(0xFFD32F2F), const Color(0xFFB71C1C)],
      [const Color(0xFF64B5F6), const Color(0xFF1976D2)],
      [const Color(0xFF311B92), const Color(0xFF1A237E)],
      [const Color(0xFFE91E63), const Color(0xFFC62828)],
    ];

    final colorPair = colors[index % colors.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Opacity(
        opacity: isLocked ? 0.5 : 1.0,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorPair[0].withValues(alpha: 0.3),
                colorPair[1].withValues(alpha: 0.15),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isLocked 
                  ? AppTheme.textMuted.withValues(alpha: 0.2)
                  : colorPair[0].withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: isLocked ? null : () => _showStageList(context, game, chapter),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Chapter number
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(colors: colorPair),
                        boxShadow: [
                          BoxShadow(
                            color: colorPair[0].withValues(alpha: 0.4),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Center(
                        child: isLocked
                            ? const Icon(Icons.lock, color: Colors.white70, size: 22)
                            : Text(
                                '${chapter.chapterNumber}',
                                style: AppTheme.titleSmall.copyWith(fontSize: 20),
                              ),
                      ),
                    ),
                    
                    const SizedBox(width: 16),
                    
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Chapter ${chapter.chapterNumber}',
                            style: AppTheme.bodySmall.copyWith(fontSize: 10, color: colorPair[0]),
                          ),
                          Text(chapter.name, style: AppTheme.titleSmall.copyWith(fontSize: 16)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.star, size: 14, color: AppTheme.accentGold.withValues(alpha: isLocked ? 0.3 : 1)),
                              const SizedBox(width: 4),
                              Text(
                                '${chapter.starsEarned}/${chapter.maxStars}',
                                style: AppTheme.bodySmall.copyWith(
                                  color: isLocked ? AppTheme.textMuted : AppTheme.accentGold,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '${chapter.stages.length} stages',
                                style: AppTheme.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    Icon(
                      isLocked ? Icons.lock : Icons.chevron_right,
                      color: isLocked ? AppTheme.textMuted : colorPair[0],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ).animate()
      .fadeIn(delay: Duration(milliseconds: index * 80), duration: 400.ms)
      .slideX(begin: 0.1, end: 0, delay: Duration(milliseconds: index * 80));
  }

  void _showStageList(BuildContext context, GameProvider game, dynamic chapter) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: AppTheme.surfaceLight,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.textMuted,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(chapter.name, style: AppTheme.titleMedium),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: (chapter.stages as List).length,
                    itemBuilder: (context, i) {
                      final stage = chapter.stages[i];
                      final isBoss = stage.name.contains('Boss');
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: isBoss 
                              ? AppTheme.hpRed.withValues(alpha: 0.1) 
                              : AppTheme.cardDark.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12),
                          border: isBoss 
                              ? Border.all(color: AppTheme.hpRed.withValues(alpha: 0.3))
                              : null,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isBoss ? AppTheme.hpRed : AppTheme.midPurple,
                            child: isBoss
                                ? const Icon(Icons.whatshot, color: Colors.white, size: 20)
                                : Text('${stage.stageNumber}', style: const TextStyle(color: Colors.white)),
                          ),
                          title: Text(
                            isBoss ? 'BOSS: ${stage.name}' : stage.name,
                            style: AppTheme.bodyLarge.copyWith(
                              color: isBoss ? AppTheme.hpRed : AppTheme.textPrimary,
                              fontWeight: isBoss ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                          subtitle: Row(
                            children: [
                              Icon(Icons.flash_on, size: 12, color: AppTheme.slimeGreen.withValues(alpha: 0.7)),
                              Text(' 5 ', style: AppTheme.bodySmall.copyWith(fontSize: 11)),
                              Icon(Icons.bolt, size: 12, color: AppTheme.accentOrange.withValues(alpha: 0.7)),
                              Text(' ${stage.recommendedPower}', style: AppTheme.bodySmall.copyWith(fontSize: 11)),
                            ],
                          ),
                          trailing: GameButton(
                            text: 'GO',
                            height: 35.0,
                            gradient: LinearGradient(
                              colors: isBoss
                                  ? [AppTheme.hpRed, const Color(0xFFB71C1C)]
                                  : [AppTheme.slimeGreen, AppTheme.slimeGreenDark],
                            ),
                            onTap: () {
                              game.useStamina(5);
                              Navigator.pop(context);
                              _startBattle(context, game);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _startBattle(BuildContext context, GameProvider game) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return BattleDialog(game: game);
      },
    );
  }
}

class BattleDialog extends StatefulWidget {
  final GameProvider game;
  const BattleDialog({super.key, required this.game});

  @override
  State<BattleDialog> createState() => _BattleDialogState();
}

class _BattleDialogState extends State<BattleDialog> {
  int _wave = 1;
  bool _won = false;
  bool _done = false;
  double _enemyHp = 1.0;
  double _playerHp = 1.0;

  @override
  void initState() {
    super.initState();
    _runBattle();
  }

  void _runBattle() async {
    for (int w = 1; w <= 3; w++) {
      if (!mounted) return;
      setState(() {
        _wave = w;
        _enemyHp = 1.0;
      });
      
      for (int i = 0; i < 5; i++) {
        await Future.delayed(const Duration(milliseconds: 600));
        if (!mounted) return;
        setState(() {
          _enemyHp -= 0.2;
          _playerHp -= 0.05;
        });
      }
    }
    
    setState(() {
      _won = true;
      _done = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.surfaceLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!_done) ...[
              Text('Wave $_wave/3', style: AppTheme.titleMedium),
              const SizedBox(height: 20),
              _barRow('Your HP', _playerHp.clamp(0, 1), AppTheme.slimeGreen),
              const SizedBox(height: 8),
              _barRow('Enemy HP', _enemyHp.clamp(0, 1), AppTheme.hpRed),
              const SizedBox(height: 20),
              const CircularProgressIndicator(color: AppTheme.slimeGreen),
            ] else ...[
              Icon(
                _won ? Icons.emoji_events : Icons.sentiment_very_dissatisfied,
                size: 60,
                color: _won ? AppTheme.accentGold : AppTheme.hpRed,
              ),
              const SizedBox(height: 12),
              Text(
                _won ? 'VICTORY!' : 'DEFEAT',
                style: AppTheme.titleLarge.copyWith(
                  color: _won ? AppTheme.accentGold : AppTheme.hpRed,
                ),
              ),
              const SizedBox(height: 8),
              if (_won) ...[
                Text('+800 Gold', style: AppTheme.bodyLarge.copyWith(color: AppTheme.accentGold)),
                Text('+350 EXP', style: AppTheme.bodyLarge.copyWith(color: AppTheme.expYellow)),
              ],
              const SizedBox(height: 20),
              GameButton(
                text: 'Continue',
                onTap: () {
                  widget.game.endBattle(_won);
                  Navigator.pop(context);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _barRow(String label, double value, Color color) {
    return Row(
      children: [
        SizedBox(width: 70, child: Text(label, style: AppTheme.bodySmall)),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 10,
              backgroundColor: AppTheme.cardDark,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text('${(value * 100).toInt()}%', style: AppTheme.bodySmall.copyWith(color: color)),
      ],
    );
  }
}
