import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/app_theme.dart';
import '../../providers/game_provider.dart';

class MailScreen extends StatelessWidget {
  const MailScreen({super.key});

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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.textPrimary),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Text('Mail', style: AppTheme.titleMedium),
                        const Spacer(),
                        if (game.unreadMails > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.hpRed.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${game.unreadMails} new',
                              style: AppTheme.bodySmall.copyWith(color: AppTheme.hpRed, fontWeight: FontWeight.w600),
                            ),
                          ),
                      ],
                    ),
                  ),
                  
                  Expanded(
                    child: game.mails.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.mail_outline, size: 60, color: AppTheme.textMuted.withValues(alpha: 0.3)),
                                const SizedBox(height: 12),
                                Text('No mail', style: AppTheme.bodyLarge.copyWith(color: AppTheme.textMuted)),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: game.mails.length,
                            itemBuilder: (context, i) {
                              final mail = game.mails[i];
                              return GestureDetector(
                                onTap: () {
                                  game.markMailAsRead(mail.id);
                                  _showMailDetail(context, game, mail);
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 10.0),
                                  decoration: BoxDecoration(
                                    color: mail.isRead
                                        ? AppTheme.cardDark.withValues(alpha: 0.3)
                                        : AppTheme.expBlue.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: mail.isRead
                                          ? AppTheme.accentGold.withValues(alpha: 0.1)
                                          : AppTheme.expBlue.withValues(alpha: 0.3),
                                    ),
                                  ),
                                  child: ListTile(
                                    leading: Stack(
                                      children: [
                                        Container(
                                          width: 44.0,
                                          height: 44.0,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: mail.isRead
                                                ? AppTheme.cardMedium
                                                : AppTheme.expBlue.withValues(alpha: 0.2),
                                          ),
                                          child: Icon(
                                            mail.isRead ? Icons.drafts : Icons.mail,
                                            color: mail.isRead ? AppTheme.textMuted : AppTheme.expBlue,
                                            size: 22.0,
                                          ),
                                        ),
                                        if (!mail.isRead)
                                          Positioned(
                                            top: 0.0,
                                            right: 0.0,
                                            child: Container(
                                              width: 10.0,
                                              height: 10.0,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppTheme.hpRed,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    title: Text(
                                      mail.title,
                                      style: AppTheme.bodyLarge.copyWith(
                                        color: mail.isRead ? AppTheme.textSecondary : AppTheme.textPrimary,
                                        fontWeight: mail.isRead ? FontWeight.w400 : FontWeight.w600,
                                      ),
                                    ),
                                    subtitle: Text(
                                      mail.body,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTheme.bodySmall,
                                    ),
                                    trailing: mail.rewards.isNotEmpty && !mail.isClaimed
                                        ? Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                            decoration: BoxDecoration(
                                              color: AppTheme.accentGold.withValues(alpha: 0.2),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: const Text('🎁', style: TextStyle(fontSize: 18)),
                                          )
                                        : const Icon(Icons.chevron_right, color: AppTheme.textMuted),
                                  ),
                                ),
                              ).animate()
                                .fadeIn(delay: Duration(milliseconds: i * 80), duration: 300.ms);
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

  void _showMailDetail(BuildContext context, GameProvider game, dynamic mail) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppTheme.surfaceLight,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(
              color: AppTheme.textMuted, borderRadius: BorderRadius.circular(2),
            ))),
            const SizedBox(height: 16),
            Text(mail.title, style: AppTheme.titleSmall),
            const SizedBox(height: 12),
            Text(mail.body, style: AppTheme.bodyMedium),
            if (mail.rewards.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text('Rewards:', style: AppTheme.labelBold),
              const SizedBox(height: 8),
              ...mail.rewards.map<Widget>((r) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Text(
                      r.type == 'gem' ? '💎' : '💰',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(width: 8),
                    Text('${r.name} x${r.amount}', style: AppTheme.bodyLarge.copyWith(
                      color: r.type == 'gem' ? AppTheme.accentCyan : AppTheme.accentGold,
                    )),
                  ],
                ),
              )).toList(),
              const SizedBox(height: 16.0),
              if (!mail.isClaimed)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.slimeGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () {
                      game.claimMailReward(mail.id);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Rewards claimed!'), backgroundColor: AppTheme.slimeGreenDark),
                      );
                    },
                    child: const Text('Claim Rewards', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                )
              else
                Center(
                  child: Text('Already claimed', style: AppTheme.bodySmall.copyWith(color: AppTheme.slimeGreen)),
                ),
            ],
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
