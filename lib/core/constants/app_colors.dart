import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Deep Emerald Teal & Mint Palette
  static const Color primary = Color(0xFF00695C); // Emerald Teal
  static const Color primaryLight = Color(0xFF00A884); // Vibrant Mint
  static const Color primaryDark = Color(0xFF004D40); // Deep Forest Teal
  static const Color primaryContainer = Color(0xFFE0F2F1);
  static const Color onPrimaryContainer = Color(0xFF00201A);

  // Secondary Palette (Ocean Cyan Accent)
  static const Color secondary = Color(0xFF0288D1); // Warm Cyan
  static const Color secondaryLight = Color(0xFF4FC3F7);
  static const Color secondaryDark = Color(0xFF01579B);
  static const Color secondaryContainer = Color(0xFFE1F5FE);
  static const Color onSecondaryContainer = Color(0xFF001F3F);

  // Tertiary / Eco Highlights
  static const Color tertiary = Color(0xFFFF8F00); // Amber Gold
  static const Color tertiaryContainer = Color(0xFFFFF8E1);

  // Eco Gradients
  static const LinearGradient ecoGradient = LinearGradient(
    colors: [Color(0xFF004D40), Color(0xFF00695C), Color(0xFF00A884)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient impactGradient = LinearGradient(
    colors: [Color(0xFF005B4F), Color(0xFF00897B), Color(0xFF26A69A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient amberGradient = LinearGradient(
    colors: [Color(0xFFE65100), Color(0xFFFF8F00), Color(0xFFFFC107)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Background & Surface (Light)
  static const Color backgroundLight = Color(0xFFF4F7F6);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceVariantLight = Color(0xFFE8ECEB);
  static const Color cardLight = Color(0xFFFFFFFF);

  // Background & Surface (Dark)
  static const Color backgroundDark = Color(0xFF101413);
  static const Color surfaceDark = Color(0xFF181C1B);
  static const Color surfaceVariantDark = Color(0xFF222826);
  static const Color cardDark = Color(0xFF1D2220);

  // Status & Feedback
  static const Color success = Color(0xFF00897B);
  static const Color warning = Color(0xFFFFB300);
  static const Color error = Color(0xFFD32F2F);
  static const Color info = Color(0xFF0288D1);

  // CO2 Impact Badge
  static const Color co2Green = Color(0xFF00897B);
  static const Color co2BadgeBackground = Color(0xFFE0F2F1);

  // Listing Type Badges
  static const Color freeType = Color(0xFF00695C); // Emerald
  static const Color swapType = Color(0xFF0288D1); // Cyan
  static const Color paidType = Color(0xFFFF8F00); // Amber

  // Neutrals (Light)
  static const Color textPrimaryLight = Color(0xFF1A1C1E);
  static const Color textSecondaryLight = Color(0xFF5A6065);
  static const Color textMutedLight = Color(0xFF8C9399);
  static const Color borderLight = Color(0xFFE0E4E0);

  // Neutrals (Dark)
  static const Color textPrimaryDark = Color(0xFFE2E3E5);
  static const Color textSecondaryDark = Color(0xFFA1A6AA);
  static const Color textMutedDark = Color(0xFF6E7377);
  static const Color borderDark = Color(0xFF323632);
}
