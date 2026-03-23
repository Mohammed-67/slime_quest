import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color primaryGreen = Color(0xFF4CAF50);
  static const Color slimeGreen = Color(0xFF81C784);
  static const Color slimeGreenLight = Color(0xFFA5D6A7);
  static const Color slimeGreenDark = Color(0xFF388E3C);
  
  static const Color surfaceDark = Color(0xFF1A1A2E);
  static const Color cardDark = Color(0xFF16213E);
  static const Color cardMedium = Color(0xFF1F2B4E);
  static const Color surfaceLight = Color(0xFF0F3460);
  
  static const Color accentOrange = Color(0xFFFF9800);
  static const Color accentCyan = Color(0xFF00D2FF);
  static const Color accentPink = Color(0xFFFF4081);
  static const Color accentGold = Color(0xFFFFD700);
  
  static const Color hpRed = Color(0xFFFF5252);
  static const Color expBlue = Color(0xFF448AFF);
  static const Color expYellow = Color(0xFFFFC107);
  
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFE0E0E0);
  static const Color textMuted = Color(0xFFB0B0B0);
  
  static const Color deepPurple = Color(0xFF2D1B4E);
  static const Color darkPurple = Color(0xFF1A0B2E);
  static const Color midPurple = Color(0xFF4E31AA);

  // Rarity Colors
  static const Color rarityCommon = Color(0xFF9E9E9E);
  static const Color rarityUncommon = Color(0xFF4CAF50);
  static const Color rarityRare = Color(0xFF2196F3);
  static const Color rarityEpic = Color(0xFF9C27B0);
  static const Color rarityLegendary = Color(0xFFFF9800);
  static const Color rarityMythic = Color(0xFFFF1744);

  // Gradients
  static const LinearGradient rareGradient = LinearGradient(
    colors: [Color(0xFF2196F3), Color(0xFF64B5F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient epicGradient = LinearGradient(
    colors: [Color(0xFF7B1FA2), Color(0xFF9C27B0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient legendaryGradient = LinearGradient(
    colors: [Color(0xFFFFA000), Color(0xFFFFD54F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static final BoxDecoration glassDecoration = BoxDecoration(
    color: Colors.white.withValues(alpha: 0.1),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1),
  );

  static final BoxDecoration borderGlow = BoxDecoration(
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: accentGold.withValues(alpha: 0.3),
        blurRadius: 10,
        spreadRadius: 2,
      ),
    ],
  );

  static BoxDecoration rarityBorder(Color color) => BoxDecoration(
    color: cardDark,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: color.withValues(alpha: 0.5), width: 2),
    boxShadow: [
      BoxShadow(color: color.withValues(alpha: 0.2), blurRadius: 8, spreadRadius: 1),
    ],
  );

  // Text Styles
  static const TextStyle titleLarge = TextStyle(
    color: textPrimary,
    fontSize: 28,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle titleMedium = TextStyle(
    color: textPrimary,
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle titleSmall = TextStyle(
    color: textPrimary,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle bodyLarge = TextStyle(
    color: textPrimary,
    fontSize: 16,
  );

  static const TextStyle bodyMedium = TextStyle(
    color: textPrimary,
    fontSize: 14,
  );

  static const TextStyle bodySmall = TextStyle(
    color: textMuted,
    fontSize: 12,
  );

  static const TextStyle labelBold = TextStyle(
    color: textPrimary,
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );

  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: surfaceDark,
      primaryColor: primaryGreen,
      cardColor: cardDark,
      textTheme: const TextTheme(
        headlineLarge: titleLarge,
        headlineMedium: TextStyle(
          color: textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: titleLarge,
        titleMedium: titleMedium,
        titleSmall: titleSmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
      ),
    );
  }

}
