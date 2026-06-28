import 'package:flutter/material.dart';

/// Central colour palette for MoodBook.
/// Every colour used anywhere in the app should come from here.
class AppColors {
  AppColors._();

  // ── Brand ────────────────────────────────────────────────────────────────
  static const Color primary        = Color(0xFF8B4CFC);
  static const Color primaryLight   = Color(0xFFE8D9FF);
  static const Color primaryDark    = Color(0xFF6A2FD4);

  // ── Mood (canonical – used consistently across charts, tiles, heatmap) ──
  static const Color moodTerrible   = Color(0xFFEF4444); // red
  static const Color moodBad        = Color(0xFFF97316); // orange
  static const Color moodNeutral    = Color(0xFFEAB308); // amber
  static const Color moodGood       = Color(0xFF3B82F6); // blue
  static const Color moodExcellent  = Color(0xFF22C55E); // green

  /// Returns the canonical colour for a mood string.
  static Color forMood(String mood) {
    switch (mood.toLowerCase()) {
      case 'terrible': return moodTerrible;
      case 'bad':      return moodBad;
      case 'neutral':  return moodNeutral;
      case 'good':     return moodGood;
      case 'excellent':return moodExcellent;
      default:         return Colors.grey;
    }
  }

  // ── Light surface ────────────────────────────────────────────────────────
  static const Color surfaceLight       = Colors.white;
  static const Color backgroundLight    = Color(0xFFF5F5F5);
  static const Color cardLight          = Colors.white;
  static const Color cardStatsLight     = Color(0xFFEDE8FC); // lavender card
  static const Color navBarLight        = Colors.white;

  // ── Dark surface ─────────────────────────────────────────────────────────
  static const Color surfaceDark        = Color(0xFF1E1E2E);
  static const Color backgroundDark     = Color(0xFF12121C);
  static const Color cardDark           = Color(0xFF2A2A3E);
  static const Color cardStatsDark      = Color(0xFF2D2646);
  static const Color navBarDark         = Color(0xFF1E1E2E);

  // ── Text ─────────────────────────────────────────────────────────────────
  static const Color textPrimaryLight   = Color(0xFF100F11);
  static const Color textSecondaryLight = Color(0xFF6B6B6B);
  static const Color textPrimaryDark    = Color(0xFFF0F0F0);
  static const Color textSecondaryDark  = Color(0xFFAAAAAA);

  // ── Semantic ─────────────────────────────────────────────────────────────
  static const Color error   = Color(0xFFE53935);
  static const Color success = Color(0xFF43A047);
  static const Color warning = Color(0xFFFB8C00);
  static const Color info    = Color(0xFF1E88E5);

  // ── Check-in widget ──────────────────────────────────────────────────────
  static const Color checkInGoalBg       = Color(0xFFE3F2FD); // blue[50]
  static const Color checkInGoalIcon     = Color(0xFF90CAF9); // blue[100]
  static const Color checkInGoalAccent   = Color(0xFF1E88E5); // blue
  static const Color checkInActiveBg     = Color(0xFFFCE4EC); // pink[50]
  static const Color checkInActiveIcon   = Color(0xFFF48FB1); // pink[100]
  static const Color checkInActiveAccent = Color(0xFFE91E63); // pink

  // ── Gradients stored as gradient specs ───────────────────────────────────
  static const Gradient addMoodGradient = RadialGradient(
    center: Alignment.center,
    radius: 1.4,
    colors: [Color(0xFFCCEFFF), Color(0xFFEFF9F2), Color(0xFFCFCFCF)],
    stops: [0.3, 0.8, 1.0],
  );

  static const Gradient addMoodGradientDark = RadialGradient(
    center: Alignment.center,
    radius: 1.4,
    colors: [Color(0xFF1A2A3A), Color(0xFF121C20), Color(0xFF0A0A12)],
    stops: [0.3, 0.8, 1.0],
  );

  static const Gradient pageGradientLight = LinearGradient(
    colors: [Color(0xAAC7DFFF), Color(0xFFFFCEB7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient pageGradientDark = LinearGradient(
    colors: [Color(0xFF1A2035), Color(0xFF2A1A1A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient homeGradientLight = LinearGradient(
    colors: [Color(0x99F8E3D9), Colors.white],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const Gradient homeGradientDark = LinearGradient(
    colors: [Color(0xFF1A1A2E), Color(0xFF12121C)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const Gradient signInGradient = RadialGradient(
    center: Alignment(-0.5, -0.5),
    radius: 1.8,
    colors: [Color(0xFFF3EAF8), Color(0xFFFF92A9), Color(0xFFCCEFFF)],
    stops: [0.0, 0.4, 0.9],
  );

  static const Gradient signInGradientDark = RadialGradient(
    center: Alignment(-0.5, -0.5),
    radius: 1.8,
    colors: [Color(0xFF1A0A2E), Color(0xFF2E0A1A), Color(0xFF0A1A2E)],
    stops: [0.0, 0.4, 0.9],
  );
}
