import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';
import '../../core/app_theme.dart';
import '../../providers/game_provider.dart';
import '../../models/slime_model.dart';
import '../../widgets/slime_avatar.dart';
import '../../widgets/game_button.dart';

class GachaScreen extends StatefulWidget {
  const GachaScreen({super.key});

  @override
  State<GachaScreen> createState() =>  GachaScreenState();
}

class  GachaScreenState extends State<GachaScreen> with TickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _orbController;
  SlimeModel? _lastPulled;
  List<SlimeModel>? _multiPullResults;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _orbController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _orbController.dispose();
    super.dispose();
  }

  void _singlePull(GameProvider game) async {
    if (game.player == null || game.player!.gems < 300 || _isAnimating) return;
    
    game.spendGems(300);
    setState(() => _isAnimating = true);
    
    await Future.delayed(const Duration(seconds: 1));
    
    final slime = game.pullGacha();
    setState(() {
      _lastPulled = slime;
      _multiPullResults = null;
      _isAnimating = false;
    });
    
    if (slime.rarity.stars >= 4) {
      _confettiController.play();
    }
  }

  void _multiPull(GameProvider game) async {
    if (game.player == null || game.player!.gems < 2700 || _isAnimating) return;
    
    game.spendGems(2700);
    setState(() => _isAnimating = true);
    
    await Future.delayed(const Duration(seconds: 2));
    
    final slimes = game.pullGacha10();
    setState(() {
      _multiPullResults = slimes;
      _lastPulled = null;
      _isAnimating = false;
    });
    
    if (slimes.any((s) => s.rarity.stars >= 4)) {
      _confettiController.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, game, child) {
        return Scaffold(
          body: Stack(
            children: [
              // Background
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF1A0033),
                      Color(0xFF0D0628),
                      Color(0xFF1A0E3E),
                    ],
                  ),
                ),
              ),
              
              // Stars background
              ...List.generate(30, (i) {
                final rng = Random(i);
                return Positioned(
                  top: rng.nextDouble() * MediaQuery.of(context).size.height,
                  left: rng.nextDouble() * MediaQuery.of(context).size.width,
                  child: Container(
                    width: rng.nextDouble() * 3 + 1,
                    height: rng.nextDouble() * 3 + 1,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: rng.nextDouble() * 0.5 + 0.1),
                    ),
                  ).animate(onPlay: (c) => c.repeat(reverse: true))
                    .fadeIn(duration: Duration(milliseconds: 1000 + rng.nextInt(2000)))
                    .then()
                    .fadeOut(duration: Duration(milliseconds: 1000 + rng.nextInt(2000))),
                );
              }),
              
              // Main content
              SafeArea(
                child: Column(
                  children: [
                    // App bar
                    _buildAppBar(context, game),
                    
                    Expanded(
                      child: _isAnimating
                          ? _buildAnimatingState()
                          : _multiPullResults != null
                              ? _buildMultiPullResults()
                              : _lastPulled != null
                                  ? _buildSingleResult()
                                  : _buildGachaMain(game),
                    ),
                  ],
                ),
              ),
              
              // Confetti
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: false,
                  colors: const [
                    AppTheme.accentGold,
                    AppTheme.accentPink,
                    AppTheme.accentCyan,
                    AppTheme.slimeGreen,
                    AppTheme.rarityLegendary,
                  ],
                ),
              ),
            ],
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
          Text('Summon', style: AppTheme.titleMedium),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppTheme.accentCyan.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.accentCyan.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.diamond, size: 16, color: AppTheme.accentCyan),
                const SizedBox(width: 4),
                Text('${game.player?.gems ?? 0}', style: AppTheme.labelBold.copyWith(color: AppTheme.accentCyan)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.textMuted.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text('Pity: ${game.gachaPity}/90', style: AppTheme.bodySmall.copyWith(fontSize: 10)),
          ),
        ],
      ),
    );
  }

  Widget _buildGachaMain(GameProvider game) {
    return Column(
      children: [
        const Spacer(),
        
        // Summon orb
        AnimatedBuilder(
          animation: _orbController,
          builder: (context, child) {
            return Transform.rotate(
              angle: _orbController.value * 2 * pi,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: SweepGradient(
                    colors: [
                      AppTheme.accentCyan.withValues(alpha: 0.0),
                      AppTheme.accentCyan.withValues(alpha: 0.3),
                      AppTheme.accentPink.withValues(alpha: 0.3),
                      AppTheme.accentGold.withValues(alpha: 0.3),
                      AppTheme.accentCyan.withValues(alpha: 0.0),
                    ],
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const RadialGradient(
                        colors: [
                          Color(0xFF4A148C),
                          Color(0xFF1A0033),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.midPurple.withValues(alpha: 0.5),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(Icons.auto_awesome, size: 50, color: AppTheme.accentGold),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        
        const SizedBox(height: 20),
        
        Text('Slime Summoning', style: AppTheme.titleMedium.copyWith(letterSpacing: 2)),
        const SizedBox(height: 6),
        Text('Summon powerful slimes to your team!', style: AppTheme.bodySmall),
        
        const SizedBox(height: 12),
        
        // Rate info
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          padding: const EdgeInsets.all(12),
          decoration: AppTheme.glassDecoration,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _rateChip('Mythic', '1%', AppTheme.rarityMythic),
              _rateChip('Legend', '4%', AppTheme.rarityLegendary),
              _rateChip('Epic', '15%', AppTheme.rarityEpic),
              _rateChip('Rare', '80%', AppTheme.rarityRare),
            ],
          ),
        ),
        
        const Spacer(),
        
        // Pull buttons
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            children: [
              Expanded(
                child: GameButton(
                  text: '300 GEM x1',
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7B1FA2), Color(0xFF4A148C)],
                  ),
                  onTap: () => _singlePull(game),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GameButton(
                  text: '2700 GEM x10',
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE91E63), Color(0xFFAD1457)],
                  ),
                  onTap: () => _multiPull(game),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _rateChip(String label, String rate, Color color) {
    return Column(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(height: 4),
        Text(rate, style: AppTheme.bodySmall.copyWith(color: color, fontWeight: FontWeight.w700, fontSize: 11)),
        Text(label, style: AppTheme.bodySmall.copyWith(fontSize: 9)),
      ],
    );
  }

  Widget _buildAnimatingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.midPurple.withValues(alpha: 0.3),
            ),
            child: const Center(
              child: Icon(Icons.auto_awesome, size: 60, color: AppTheme.accentGold),
            ),
          ).animate(onPlay: (c) => c.repeat())
            .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.2, 1.2), duration: 500.ms)
            .then()
            .scale(begin: const Offset(1.2, 1.2), end: const Offset(0.8, 0.8), duration: 500.ms),
          const SizedBox(height: 20),
          Text('Summoning...', style: AppTheme.titleSmall.copyWith(color: AppTheme.accentGold))
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .fadeIn(duration: 500.ms)
            .then()
            .fadeOut(duration: 500.ms),
        ],
      ),
    );
  }

  Widget _buildSingleResult() {
    final slime = _lastPulled!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SlimeAvatar(element: slime.element, rarity: slime.rarity, size: 120, imageKey: slime.imageKey)
            .animate()
            .scale(begin: const Offset(0, 0), end: const Offset(1, 1), duration: 800.ms, curve: Curves.elasticOut),
          const SizedBox(height: 20),
          Text(slime.name, style: AppTheme.titleLarge.copyWith(color: slime.rarity.color))
            .animate().fadeIn(delay: 300.ms),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(slime.rarity.stars, (i) => 
              Icon(Icons.star, color: slime.rarity.color, size: 20)
                .animate().fadeIn(delay: Duration(milliseconds: 400 + i * 100)).scale(begin: const Offset(0, 0)),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(slime.element.icon, size: 16, color: slime.element.color),
              const SizedBox(width: 4),
              Text(slime.element.label, style: AppTheme.bodyMedium.copyWith(color: slime.element.color)),
            ],
          ).animate().fadeIn(delay: 600.ms),
          const SizedBox(height: 4),
          Text('Power: ${slime.power}', style: AppTheme.bodySmall.copyWith(color: AppTheme.accentOrange))
            .animate().fadeIn(delay: 700.ms),
          const SizedBox(height: 30),
          GameButton(
            text: 'Continue',
            onTap: () => setState(() => _lastPulled = null),
          ),
        ],
      ),
    );
  }

  Widget _buildMultiPullResults() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text('Summoning Results!', style: AppTheme.titleMedium),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.7,
            ),
            itemCount: _multiPullResults!.length,
            itemBuilder: (context, i) {
              final slime = _multiPullResults![i];
              return Column(
                children: [
                  SlimeAvatar(element: slime.element, rarity: slime.rarity, size: 40, imageKey: slime.imageKey),
                  const SizedBox(height: 4),
                  Text(
                    slime.name,
                    style: TextStyle(color: slime.rarity.color, fontSize: 8, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ).animate().fadeIn(delay: Duration(milliseconds: i * 150)).scale(begin: const Offset(0, 0));
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: GameButton(
            text: 'Continue',
            onTap: () => setState(() => _multiPullResults = null),
          ),
        ),
      ],
    );
  }
}
