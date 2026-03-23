import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/app_theme.dart';
import '../core/audio_manager.dart';

class GameButton extends StatefulWidget {
  final String text;
  final VoidCallback? onTap;
  final Gradient? gradient;
  final IconData? icon;
  final double? width;
  final double height;
  final bool isPulsing;

  const GameButton({
    super.key,
    required this.text,
    this.onTap,
    this.gradient,
    this.icon,
    this.width,
    this.height = 50,
    this.isPulsing = false,
  });

  @override
  State<GameButton> createState() => _GameButtonState();
}

class _GameButtonState extends State<GameButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final gradient = widget.gradient ?? AppTheme.rareGradient;
    
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () {
        if (widget.onTap != null) {
          AudioManager.instance.playClick();
          widget.onTap!();
        }
      },
      child: AnimatedContainer(
        duration: 100.ms,
        width: widget.width,
        height: widget.height,
        transform: Matrix4.diagonal3Values(_isPressed ? 0.95 : 1.0, _isPressed ? 0.95 : 1.0, 1.0),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1),
          boxShadow: [
            BoxShadow(
              color: (gradient.colors.first).withValues(alpha: 0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, color: Colors.white, size: 20),
                const SizedBox(width: 8),
              ],
              Text(
                widget.text,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ),
      ).animate(
        onPlay: (controller) => controller.repeat(reverse: true),
        autoPlay: widget.isPulsing,
      ).scale(begin: const Offset(1, 1), end: const Offset(1.05, 1.05), duration: 1.seconds),
    );
  }
}
