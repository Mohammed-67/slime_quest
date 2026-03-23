import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/app_theme.dart';
import '../../providers/game_provider.dart';
import '../../widgets/slime_avatar.dart';
import '../../widgets/stat_bar.dart';
import '../../widgets/game_button.dart';
import '../battle/chapter_select_screen.dart';
import '../gacha/gacha_screen.dart';
import '../team/team_screen.dart';
import '../shop/shop_screen.dart';
import '../mail/mail_screen.dart';
import '../../core/audio_manager.dart';
import 'slime_pass_screen.dart';
import 'missions_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

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
                colors: [
                  AppTheme.deepPurple,
                  AppTheme.surfaceDark,
                  AppTheme.darkPurple,
                ],
              ),
            ),
            child: Stack(
              children: [
                _buildEnvironmentBg(),
                Column(
                  children: [
                    _buildTopBar(game),
                    Expanded(
                      child: Stack(
                        children: [
                          _buildLobbySlime(game),
                          _buildFloatingSideMenu(game),
                          Positioned(
                            bottom: 20,
                            left: 16,
                            right: 16,
                            child: _buildBottomQuickActions(game),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          bottomNavigationBar: _buildBottomNav(game),
        );
      },
    );
  }

  Widget _buildEnvironmentBg() {
    return Stack(
      children: [
        Positioned(
          top: 100,
          right: -50,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.accentCyan.withValues(alpha: 0.05),
            ),
          ).animate(onPlay: (c) => c.repeat()).scale(
                begin: const Offset(1, 1),
                end: const Offset(1.2, 1.2),
                duration: 5.seconds,
                curve: Curves.easeInOut,
              ),
        ),
      ],
    );
  }

  Widget _buildTopBar(GameProvider game) {
    final player = game.player;
    if (player == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 20),
      child: Row(
        children: [
          _buildPlayerProfile(player),
          const Spacer(),
          _buildResourceChip(player.gold.toString(), Icons.monetization_on, Colors.amber),
          const SizedBox(width: 8),
          _buildResourceChip(player.gems.toString(), Icons.diamond, AppTheme.accentCyan),
        ],
      ),
    );
  }

  Widget _buildPlayerProfile(player) {
    return Row(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.slimeGreen, width: 2),
                boxShadow: [
                  BoxShadow(color: AppTheme.slimeGreen.withValues(alpha: 0.3), blurRadius: 10)
                ],
              ),
              child: const ClipOval(
                child: Icon(Icons.person, color: Colors.white, size: 30),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(color: AppTheme.accentOrange, shape: BoxShape.circle),
                child: Text(
                  player.level.toString(),
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(player.name, style: AppTheme.titleSmall),
            const SizedBox(height: 4),
            StatBar(
              label: 'EXP',
              value: player.exp.toDouble(),
              maxValue: player.expToNext.toDouble(),
              color: AppTheme.expBlue,
              width: 100,
              height: 6,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildResourceChip(String text, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppTheme.cardDark.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 4),
          Text(text, style: AppTheme.bodySmall.copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildLobbySlime(GameProvider game) {
    if (game.teamSlimes.isEmpty) return const SizedBox.shrink();
    final mainSlime = game.teamSlimes[0];

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SlimeAvatar(
            element: mainSlime.element,
            rarity: mainSlime.rarity,
            size: 200,
            imageKey: mainSlime.imageKey,
            showGlow: true,
          ).animate(onPlay: (c) => c.repeat(reverse: true))
           .scale(begin: const Offset(1, 1), end: const Offset(1.05, 0.95), duration: 1.5.seconds, curve: Curves.easeInOut),
          
          const SizedBox(height: 20),
          
          Text(
            mainSlime.name,
            style: AppTheme.titleMedium.copyWith(color: mainSlime.rarity.color, letterSpacing: 2),
          ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2, end: 0),
          
          const SizedBox(height: 5),
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.cardDark.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.bolt, color: AppTheme.accentOrange, size: 14),
                const SizedBox(width: 4),
                Text('Power: ${mainSlime.power}', style: AppTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingSideMenu(GameProvider game) {
    return Positioned(
      right: 16,
      top: 150,
      child: Column(
        children: [
          _buildFloatingBtn('Missions', Icons.assignment, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MissionsScreen()))),
          const SizedBox(height: 12),
          _buildFloatingBtn('Slime Pass', Icons.confirmation_number, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SlimePassScreen()))),
          const SizedBox(height: 12),
          _buildFloatingBtn('Mail', Icons.mail, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MailScreen())), badgeCount: game.unreadMails),
        ],
      ),
    );
  }

  Widget _buildFloatingBtn(String label, IconData icon, VoidCallback onTap, {int badgeCount = 0}) {
    return GestureDetector(
      onTap: () {
        AudioManager.instance.playClick();
        onTap();
      },
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceLight.withValues(alpha: 0.8),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                ),
                child: Icon(icon, color: Colors.white, size: 22),
              ),
              if (badgeCount > 0)
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    child: Text(badgeCount.toString(), style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: AppTheme.textMuted, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildBottomQuickActions(GameProvider game) {
    return Row(
      children: [
        Expanded(
          child: GameButton(
            text: 'ADVENTURE',
            onTap: () {
              AudioManager.instance.playClick();
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ChapterSelectScreen()));
            },
            gradient: const LinearGradient(colors: [AppTheme.slimeGreen, AppTheme.primaryGreen]),
            icon: Icons.play_arrow,
            height: 60,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav(GameProvider game) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(0, 'Home', Icons.home, game),
          _buildNavItem(1, 'Team', Icons.group, game),
          _buildNavItem(2, 'Gacha', Icons.auto_awesome, game),
          _buildNavItem(3, 'Shop', Icons.shopping_cart, game),
          _buildNavItem(4, 'Mail', Icons.mail, game),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, String label, IconData icon, GameProvider game) {
    final isSelected = game.currentTab == index;
    return GestureDetector(
      onTap: () {
        AudioManager.instance.playClick();
        game.setTab(index);
        
        switch (index) {
          case 1: Navigator.push(context, MaterialPageRoute(builder: (_) => const TeamScreen())); break;
          case 2: Navigator.push(context, MaterialPageRoute(builder: (_) => const GachaScreen())); break;
          case 3: Navigator.push(context, MaterialPageRoute(builder: (_) => const ShopScreen())); break;
          case 4: Navigator.push(context, MaterialPageRoute(builder: (_) => const MailScreen())); break;
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isSelected ? AppTheme.slimeGreen : AppTheme.textMuted, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? AppTheme.slimeGreen : AppTheme.textMuted,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
