import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/app_theme.dart';
import '../../core/audio_manager.dart';
import '../../providers/game_provider.dart';
import '../home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  double _progress = 0.0;
  String _loadingText = 'Loading...';
  late AnimationController _slimeController;
  late AnimationController _bgController;

  final List<String> _loadingMessages = [
    'Summoning slimes...',
    'Loading _chapters...',
    'Preparing battle arena...',
    'Brewing potions...',
    'Sharpening swords...',
    'Polishing gems...',
    'Waking up the dragon...',
    'Ready to quest!',
  ];

  @override
  void initState() {
    super.initState();
    _slimeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    _bgController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
    
    _startLoading();
  }

  void _startLoading() async {
    for (int i = 0; i < _loadingMessages.length; i++) {
      await Future.delayed(Duration(milliseconds: 300 + Random().nextInt(400)));
      if (!mounted) return;
      setState(() {
        _progress = (i + 1) / _loadingMessages.length;
        _loadingText = _loadingMessages[i];
      });
    }
    
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    
    // Initialize audio
    await AudioManager.instance.init();
    AudioManager.instance.playBgm('audio/3_BGM.wav');
    if (!mounted) return;
    
    // Initialize game data
    context.read<GameProvider>().initGame();
    
    // Navigate to home
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, _, _) => const HomeScreen(),
        transitionsBuilder: (_, animation, _, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  void dispose() {
    _slimeController.dispose();
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildAnimatedBg(),
          ...List.generate(20, (i) => _buildParticle(i)),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                _buildAnimatedSlimeLogo(),
                const SizedBox(height: 40),
                _buildTitle(),
                const SizedBox(height: 8),
                Text(
                  'The Idle RPG Adventure',
                  style: AppTheme.bodyLarge.copyWith(color: AppTheme.textMuted, letterSpacing: 2),
                ).animate().fadeIn(delay: 600.ms, duration: 500.ms),
                const Spacer(flex: 2),
                _buildLoadingBar(),
                const SizedBox(height: 40),
                Text(
                  'v1.0.4 • LoadComplete',
                  style: AppTheme.bodySmall.copyWith(fontSize: 11),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBg() {
    return AnimatedBuilder(
      animation: _bgController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(sin(_bgController.value * 2 * pi) * 0.5, cos(_bgController.value * 2 * pi) * 0.5),
              end: Alignment(cos(_bgController.value * 2 * pi) * 0.5, sin(_bgController.value * 2 * pi) * -0.5),
              colors: const [
                AppTheme.surfaceDark,
                AppTheme.deepPurple,
                AppTheme.darkPurple,
                AppTheme.surfaceDark,
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedSlimeLogo() {
    return AnimatedBuilder(
      animation: _slimeController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, sin(_slimeController.value * pi) * 15),
          child: child,
        );
      },
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const RadialGradient(
            center: Alignment(-0.3, -0.3),
            colors: [
              AppTheme.slimeGreenLight,
              AppTheme.slimeGreen,
              AppTheme.slimeGreenDark,
            ],
          ),
          boxShadow: [
            BoxShadow(color: AppTheme.slimeGreen.withValues(alpha: 0.4), blurRadius: 30, spreadRadius: 10),
          ],
        ),
        child: Stack(
          children: [
            Positioned(left: 35, top: 45, child: _buildEye()),
            Positioned(right: 35, top: 45, child: _buildEye()),
            Positioned(
              left: 45, bottom: 40,
              child: Container(
                width: 50, height: 20,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25)),
                  color: Colors.white.withValues(alpha: 0.3),
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 800.ms).scale(begin: const Offset(0.5, 0.5), end: const Offset(1, 1), duration: 800.ms, curve: Curves.elasticOut);
  }

  Widget _buildEye() {
    return Container(
      width: 22, height: 28,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(11)),
      child: Center(
        child: Container(
          width: 12, height: 14,
          decoration: BoxDecoration(color: AppTheme.deepPurple, borderRadius: BorderRadius.circular(6)),
          child: Align(
            alignment: const Alignment(0.3, -0.3),
            child: Container(width: 5, height: 5, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [AppTheme.slimeGreen, AppTheme.accentCyan, AppTheme.slimeGreenLight],
      ).createShader(bounds),
      child: Text(
        'SLIME QUEST',
        style: AppTheme.titleLarge.copyWith(fontSize: 42, fontWeight: FontWeight.w900, letterSpacing: 4, color: Colors.white),
      ),
    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.3, end: 0);
  }

  Widget _buildLoadingBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 60),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: _progress,
              minHeight: 8,
              backgroundColor: AppTheme.cardDark,
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.slimeGreen),
            ),
          ),
          const SizedBox(height: 12),
          Text(_loadingText, style: AppTheme.bodySmall.copyWith(color: AppTheme.slimeGreen.withValues(alpha: 0.8))),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms);
  }

  Widget _buildParticle(int index) {
    final random = Random(index);
    return Positioned(
      left: random.nextDouble() * 400,
      top: random.nextDouble() * 800,
      child: Container(
        width: 4, height: 4,
        decoration: BoxDecoration(shape: BoxShape.circle, color: AppTheme.slimeGreen.withValues(alpha: 0.2)),
      ).animate(onPlay: (c) => c.repeat(reverse: true))
       .fadeIn(duration: 2.seconds).then().fadeOut(duration: 2.seconds),
    );
  }
}
