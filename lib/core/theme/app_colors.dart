import 'package:flutter/material.dart';

/// Centralized color system strictly adhering to the design specification:
/// - Terracotta/Red-Orange accents (#C44730)
/// - Primary Dark / Charcoal typography (#1E1816)
/// - Secondary Brown (#634946)
/// - Warm Beige (#C38B70)
/// - Soft Peach (#D8B7AA)
/// - Neutral Light Gray (#EBEBEB)
/// - Text Gray (#9A9898)
/// - Warm Off-White App Background (#F8F7F5)
class AppColors {
  AppColors._();

  // Primary Accent
  static const Color primary = Color(0xFFC44730); // Terracotta
  static const Color primaryLight = Color(0xFFD35E49);
  static const Color primaryDarkAccent = Color(0xFFA63925);

  // Typography & Dark Surfaces
  static const Color primaryDark = Color(0xFF1E1816); // Dark Brown / Charcoal
  static const Color secondaryBrown = Color(0xFF634946); // Brown
  static const Color warmBeige = Color(0xFFC38B70); // Warm Beige
  static const Color softPeach = Color(0xFFD8B7AA); // Soft Peach / Accent
  static const Color textGray = Color(0xFF9A9898); // Muted Secondary Text
  static const Color textLight = Color(0xFF706E6B);

  // Neutrals & Surfaces
  static const Color background = Color(0xFFF8F7F5); // Warm Off-White
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF2EFEB);
  static const Color neutralLight = Color(0xFFEBEBEB); // Light Gray
  static const Color neutralBorder = Color(0x141E1816); // rgba(30, 24, 22, 0.08)
  static const Color borderFocused = Color(0xFFC44730);

  // Status & Utility Colors
  static const Color statusActiveBg = Color(0xFFF1E3DC);
  static const Color statusActiveText = Color(0xFF634946);
  static const Color statusPendingBg = Color(0xFFFBF0E4);
  static const Color statusPendingText = Color(0xFFB45309);
  static const Color statusApprovedBg = Color(0xFFE6F4EA);
  static const Color statusApprovedText = Color(0xFF137333);
  static const Color statusRejectedBg = Color(0xFFFCE8E6);
  static const Color statusRejectedText = Color(0xFFC5221F);

  // Mesh Gradient Colors for Hero & Cards
  static const List<Color> heroGradient = [
    Color(0xFFE26145),
    Color(0xFFC44730),
    Color(0xFF8E3424),
    Color(0xFF35201A),
  ];

  static const List<Color> eCardGradient = [
    Color(0xFFE65D43),
    Color(0xFFC44730),
    Color(0xFF9B3723),
  ];

  static const List<Color> softWarmGradient = [
    Color(0xFFFDFBF9),
    Color(0xFFF6F0EC),
  ];
}
