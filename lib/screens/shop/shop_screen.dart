import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/app_theme.dart';
import '../../providers/game_provider.dart';
import '../../widgets/game_button.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() =>  ShopScreenState();
}

class ShopScreenState extends State<ShopScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
                colors: [Color(0xFF1A0E3E), AppTheme.surfaceDark],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // App bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.textPrimary),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Text('Shop', style: AppTheme.titleMedium),
                        const Spacer(),
                        _buildResourceChip(Icons.monetization_on, '${game.player?.gold ?? 0}', AppTheme.accentGold),
                        const SizedBox(width: 8),
                        _buildResourceChip(Icons.diamond, '${game.player?.gems ?? 0}', AppTheme.accentCyan),
                      ],
                    ),
                  ),
                  
                  // Tabs
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppTheme.cardDark.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: AppTheme.slimeGreen.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      labelColor: AppTheme.slimeGreen,
                      unselectedLabelColor: AppTheme.textMuted,
                      dividerColor: Colors.transparent,
                      tabs: const [
                        Tab(text: 'Items'),
                        Tab(text: 'Gems'),
                        Tab(text: 'Special'),
                      ],
                    ),
                  ),
                  
                  // Tab content
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildItemsTab(game),
                        _buildGemsTab(game),
                        _buildSpecialTab(game),
                      ],
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

  Widget _buildResourceChip(IconData icon, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 3),
          Text(value, style: AppTheme.bodySmall.copyWith(color: color, fontWeight: FontWeight.w600, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildItemsTab(GameProvider game) {
    final items = [
      ('Stamina Potion', 'Restores 60 stamina', 500, Icons.flash_on, AppTheme.slimeGreen),
      ('EXP Boost x2', 'Double EXP for 1 hour', 1000, Icons.speed, AppTheme.expYellow),
      ('Gold Boost x2', 'Double Gold for 1 hour', 1000, Icons.monetization_on, AppTheme.accentGold),
      ('Growth Crystal', 'Level up a slime', 2000, Icons.auto_awesome, AppTheme.accentCyan),
      ('Arena Ticket', 'Extra arena battle', 800, Icons.confirmation_number, AppTheme.accentOrange),
      ('Raid Ticket', 'Extra raid attempt', 1200, Icons.shield, AppTheme.accentPink),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, i) {
        final (name, desc, cost, icon, color) = items[i];
        final canAfford = (game.player?.gold ?? 0) >= cost;
        return Container(
          margin: const EdgeInsets.only(bottom: 10.0),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withValues(alpha: 0.15)),
          ),
          child: ListTile(
            leading: Container(
              width: 44.0,
              height: 44.0,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24.0),
            ),
            title: Text(name, style: AppTheme.bodyLarge.copyWith(color: AppTheme.textPrimary)),
            subtitle: Text(desc, style: AppTheme.bodySmall),
            trailing: GameButton(
              text: '💰$cost',
              height: 35,
              onTap: !canAfford ? null : () {
                game.addGold(-cost);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Purchased $name!'), backgroundColor: AppTheme.slimeGreenDark),
                );
              },
            ),
          ),
        ).animate()
          .fadeIn(delay: Duration(milliseconds: i * 80), duration: 400.ms)
          .slideX(begin: 0.05, end: 0);
      },
    );
  }

  Widget _buildGemsTab(GameProvider game) {
    final packs = [
      ('Starter Pack', 100, '\$0.99', AppTheme.rarityUncommon),
      ('Value Pack', 500, '\$4.99', AppTheme.rarityRare),
      ('Super Pack', 1200, '\$9.99', AppTheme.rarityEpic),
      ('Mega Pack', 3000, '\$24.99', AppTheme.rarityLegendary),
      ('Ultimate Pack', 7000, '\$49.99', AppTheme.rarityMythic),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: packs.length,
      itemBuilder: (context, i) {
        final (name, gems, price, color) = packs[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 12.0),
          padding: const EdgeInsets.all(16),
          decoration: AppTheme.rarityBorder(color),
          child: Row(
            children: [
              Container(
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: [color, color.withValues(alpha: 0.5)]),
                ),
                child: const Center(child: Icon(Icons.diamond, color: Colors.white, size: 28.0)),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: AppTheme.titleSmall.copyWith(color: color, fontSize: 15.0)),
                    Text('$gems gems', style: AppTheme.bodySmall),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [color, color.withValues(alpha: 0.7)]),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(price, style: AppTheme.labelBold),
              ),
            ],
          ),
        ).animate()
          .fadeIn(delay: Duration(milliseconds: i * 100), duration: 400.ms);
      },
    );
  }

  Widget _buildSpecialTab(GameProvider game) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.access_time, size: 60, color: AppTheme.textMuted),
          const SizedBox(height: 16),
          Text('Coming Soon!', style: AppTheme.titleMedium.copyWith(color: AppTheme.textMuted)),
          const SizedBox(height: 8),
          Text('Special offers will appear here.', style: AppTheme.bodySmall),
        ],
      ),
    );
  }
}
