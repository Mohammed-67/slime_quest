import 'package:flutter/material.dart';
import '../core/app_theme.dart';

class StatBar extends StatelessWidget {
  final String label;
  final double value;
  final double maxValue;
  final Color color;
  final double width;
  final double height;
  final bool showLabel;

  const StatBar({
    super.key,
    required this.label,
    required this.value,
    required this.maxValue,
    required this.color,
    this.width = 150,
    this.height = 10,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    final double ratio = (value / maxValue).clamp(0.0, 1.0);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: AppTheme.labelBold.copyWith(fontSize: 10)),
              Text('${value.toInt()}/${maxValue.toInt()}', style: AppTheme.bodySmall.copyWith(fontSize: 10)),
            ],
          ),
        if (showLabel) const SizedBox(height: 4),
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(height / 2),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Stack(
            children: [
              Container(
                width: width * ratio,
                height: height,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(height / 2),
                  boxShadow: [
                    BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 4, spreadRadius: 1)
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
