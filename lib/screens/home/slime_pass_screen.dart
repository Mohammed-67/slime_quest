import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/app_theme.dart';
import '../../providers/game_provider.dart';
import '../../widgets/game_button.dart';

class SlimePassScreen extends StatelessWidget {
  const SlimePassScreen({super.key});

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
                colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                   _buildHeader(context, game),
                   _buildProgressInfo(game),
                  Expanded(
                    child:  _buildRewardsList(game),
                  ),
                   _buildBottomBar(context, game),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, GameProvider game) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          Text('SLIME PASS', style: AppTheme.titleMedium.copyWith(color: AppTheme.accentGold)),
          const Spacer(),
          if (!game.slimePassActive)
             _buildBuyButton(game),
        ],
      ),
    );
  }

  Widget _buildBuyButton(GameProvider game) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: AppTheme.legendaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: AppTheme.accentGold.withValues(alpha: 0.3), blurRadius: 10),
        ],
      ),
      child: const Text('ACTIVATE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
    ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 2.seconds);
  }

  Widget _buildProgressInfo(GameProvider game) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('RANK 15', style: AppTheme.titleSmall.copyWith(color: Colors.white70)),
              Text('Exp: 1200 / 2000', style: AppTheme.bodySmall.copyWith(color: AppTheme.slimeGreen)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: 0.6,
              minHeight: 12,
              backgroundColor: Colors.white10,
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.slimeGreen),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardsList(GameProvider game) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 50,
      itemBuilder: (context, index) {
        final level = index + 1;
        final isUnlocked = level <= 15;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          height: 80,
          child: Row(
            children: [
              // Level Number
              Container(
                width: 40,
                alignment: Alignment.center,
                child: Text('$level', style: TextStyle(color: isUnlocked ? Colors.white : Colors.white24, fontWeight: FontWeight.bold)),
              ),
              
              // Free Reward
              Expanded(
                child:  _buildRewardCard(
                  'Free',
                  Icons.monetization_on,
                  '500',
                  AppTheme.accentGold,
                  isUnlocked,
                  false,
                ),
              ),
              
              const SizedBox(width: 8),
              
              // Premium Reward
              Expanded(
                child:  _buildRewardCard(
                  'Premium',
                  Icons.diamond,
                  '50',
                  AppTheme.accentCyan,
                  isUnlocked && game.slimePassActive,
                  true,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRewardCard(String type, IconData icon, String amount, Color color, bool isClaimed, bool isPremium) {
    return Container(
      decoration: BoxDecoration(
        color: isPremium ? AppTheme.accentGold.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPremium ? AppTheme.accentGold.withValues(alpha: 0.3) : Colors.white12,
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 24),
                Text(amount, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          if (isClaimed)
            Container(
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(child: Icon(Icons.check, color: AppTheme.slimeGreen)),
            ),
          if (isPremium && !isClaimed)
             const Positioned(
               top: 4,
               right: 4,
               child: Icon(Icons.lock, color: Colors.white38, size: 14),
             ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, GameProvider game) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black38,
        border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
      ),
      child: Row(
        children: [
          Expanded(
            child: GameButton(
              text: 'CLAIM ALL',
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
