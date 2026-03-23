import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/slime_model.dart';

class SlimeAvatar extends StatelessWidget {
  final SlimeElement element;
  final SlimeRarity rarity;
  final double size;
  final bool showGlow;
  final String? imageKey;
  final bool showElement;
  final bool showLevel;
  final int level;

  const SlimeAvatar({
    super.key,
    this.element = SlimeElement.earth,
    this.rarity = SlimeRarity.common,
    this.size = 100,
    this.showGlow = false,
    this.imageKey,
    this.showElement = true,
    this.showLevel = false,
    this.level = 1,
  });

  @override
  Widget build(BuildContext context) {
    // Attempt to load asset or use fallback
    Widget image;
    if (imageKey != null) {
      image = Image.asset(
        'assets/images/$imageKey.png',
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    } else {
      image = _buildPlaceholder();
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        if (showGlow)
          Container(
            width: size * 1.2,
            height: size * 1.2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: rarity.color.withValues(alpha: 0.3),
                  blurRadius: size / 2,
                  spreadRadius: size / 4,
                ),
              ],
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true))
           .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1), duration: 2.seconds),
        
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                rarity.color.withValues(alpha: 0.2),
                Colors.transparent,
              ],
            ),
          ),
          child: Center(child: image),
        ),
        
        if (showElement)
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(color: element.color, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
              child: Icon(element.icon, color: Colors.white, size: size * 0.15),
            ),
          ),
          
        if (showLevel)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(8)),
              child: Text('Lv.$level', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: size * 0.8,
      height: size * 0.8,
      decoration: BoxDecoration(color: rarity.color.withValues(alpha: 0.5), shape: BoxShape.circle),
      child: Icon(Icons.psychology, color: Colors.white, size: size * 0.4),
    );
  }
}
