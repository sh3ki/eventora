import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF7C3AED);    // Purple
  static const Color secondary = Color(0xFFF59E0B);  // Gold/Amber
  static const Color accent = Color(0xFFEC4899);     // Pink
  static const Color success = Color(0xFF10B981);    // Green
  static const Color surface = Color(0xFFF5F3FF);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1E1B4B);
  static const Color textSecondary = Color(0xFF6B7280);

  static const List<Color> categoryColors = [
    Color(0xFF7C3AED), // Conference
    Color(0xFFEC4899), // Wedding
    Color(0xFF3B82F6), // Birthday
    Color(0xFF10B981), // Networking
    Color(0xFFF59E0B), // Music
    Color(0xFFEF4444), // Sports
    Color(0xFF06B6D4), // Workshop
    Color(0xFFF97316), // Festival
  ];

  static LinearGradient get heroGradient => const LinearGradient(
        colors: [Color(0xFF7C3AED), Color(0xFF6D28D9)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient get goldGradient => const LinearGradient(
        colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static List<BoxShadow> get cardShadow => [
        BoxShadow(color: const Color(0xFF7C3AED).withOpacity(0.1), blurRadius: 16, offset: const Offset(0, 4)),
      ];

  static List<BoxShadow> get softShadow => [
        BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 2)),
      ];

  static ThemeData get lightTheme {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
        surface: surface,
      ),
    );
    return base.copyWith(
      scaffoldBackgroundColor: surface,
      textTheme: base.textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: primary.withOpacity(0.15),
      ),
    );
  }
}
