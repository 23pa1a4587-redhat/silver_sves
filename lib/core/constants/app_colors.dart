import 'package:flutter/material.dart';

/// App color palette for Leave Management System
class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // Primary Colors - Professional Blue Gradient
  static const Color primaryBlue = Color(0xFF2563EB); // Blue-600
  static const Color primaryBlueDark = Color(0xFF1E40AF); // Blue-700
  static const Color primaryBlueLight = Color(0xFF3B82F6); // Blue-500
  static const Color primaryBlueExtraLight = Color(0xFFDCEAFE); // Blue-100

  // Secondary Colors
  static const Color secondaryPurple = Color(0xFF7C3AED); // Purple-600
  static const Color secondaryIndigo = Color(0xFF4F46E5); // Indigo-600

  // Status Colors
  static const Color success = Color(0xFF10B981); // Green-500
  static const Color successLight = Color(0xFFD1FAE5); // Green-100
  static const Color warning = Color(0xFFF59E0B); // Amber-500
  static const Color warningLight = Color(0xFFFEF3C7); // Amber-100
  static const Color error = Color(0xFFEF4444); // Red-500
  static const Color errorLight = Color(0xFFFEE2E2); // Red-100
  static const Color info = Color(0xFF3B82F6); // Blue-500
  static const Color infoLight = Color(0xFFDBEAFE); // Blue-100

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey50 = Color(0xFFF9FAFB);
  static const Color grey100 = Color(0xFFF3F4F6);
  static const Color grey200 = Color(0xFFE5E7EB);
  static const Color grey300 = Color(0xFFD1D5DB);
  static const Color grey400 = Color(0xFF9CA3AF);
  static const Color grey500 = Color(0xFF6B7280);
  static const Color grey600 = Color(0xFF4B5563);
  static const Color grey700 = Color(0xFF374151);
  static const Color grey800 = Color(0xFF1F2937);
  static const Color grey900 = Color(0xFF111827);

  // Background Colors
  static const Color background = Color(0xFFF9FAFB); // Grey-50
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF3F4F6); // Grey-100

  // Text Colors
  static const Color textPrimary = Color(0xFF111827); // Grey-900
  static const Color textSecondary = Color(0xFF6B7280); // Grey-500
  static const Color textDisabled = Color(0xFF9CA3AF); // Grey-400
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryBlue, primaryBlueDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [secondaryPurple, secondaryIndigo],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Shadows
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: grey400.withValues(alpha: 0.1),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get elevatedShadow => [
    BoxShadow(
      color: grey400.withValues(alpha: 0.15),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];
}
