import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../widgets/game_button.dart';

class MissionsScreen extends StatelessWidget {
  const MissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: AppTheme.surfaceDark,
        ),
        child: SafeArea(
          child: Column(
            children: [
                _buildHeader(context),
                _buildTabs(),
               Expanded(
                 child:  _buildMissionsList(),
               ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          Text('DAILY MISSIONS', style: AppTheme.titleMedium),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
           _buildTab('Daily', true),
          const SizedBox(width: 12),
           _buildTab('Weekly', false),
          const SizedBox(width: 12),
           _buildTab('Achievement', false),
        ],
      ),
    );
  }

  Widget _buildTab(String label, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: active ? AppTheme.slimeGreen.withValues(alpha: 0.2) : Colors.white10,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: active ? AppTheme.slimeGreen : Colors.transparent),
      ),
      child: Text(label, style: TextStyle(color: active ? AppTheme.slimeGreen : Colors.white60, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildMissionsList() {
    final missions = [
       Mission('Login to the game', '1/1', true, '500 Gold', Icons.monetization_on),
       Mission('Clear 1 Chapter', '0/1', false, '50 Gems', Icons.diamond),
       Mission('Upgrade a Slime 3 times', '1/3', false, '10 Pieces', Icons.auto_awesome),
       Mission('Spend 50 Stamina', '20/50', false, '1000 Gold', Icons.monetization_on),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: missions.length,
      itemBuilder: (context, index) {
        final m = missions[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.cardDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(m.title, style: AppTheme.bodyLarge),
                    const SizedBox(height: 4),
                    Text(m.progress, style: TextStyle(color: m.isDone ? AppTheme.slimeGreen : Colors.white38)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(m.rewardIcon, size: 14, color: AppTheme.accentGold),
                        const SizedBox(width: 4),
                        Text(m.rewardText, style: const TextStyle(color: AppTheme.accentGold, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 80,
                child: GameButton(
                  height: 36,
                  text: m.isDone ? 'CLAIM' : 'GO',
                  gradient: LinearGradient(
                    colors: m.isDone 
                      ? [AppTheme.slimeGreen, AppTheme.slimeGreenDark] 
                      : [AppTheme.accentCyan, AppTheme.accentCyan.withValues(alpha: 0.7)],
                  ),
                  onTap: () {},
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class  Mission {
  final String title;
  final String progress;
  final bool isDone;
  final String rewardText;
  final IconData rewardIcon;

   Mission(this.title, this.progress, this.isDone, this.rewardText, this.rewardIcon);
}
