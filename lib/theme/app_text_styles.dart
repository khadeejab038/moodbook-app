import 'package:flutter/material.dart';

/// All typography for MoodBook.
/// Every TextStyle in the app should derive from here.
class AppTextStyles {
  AppTextStyles._();

  static const String _font = 'Pangram';

  // ── Headings ─────────────────────────────────────────────────────────────

  /// Page-level titles (e.g. "History", "Settings", "Stats")
  static const TextStyle pageTitle = TextStyle(
    fontFamily: _font,
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );

  /// Wizard step headings (e.g. "What's your mood right now?")
  static const TextStyle heading1 = TextStyle(
    fontFamily: _font,
    fontWeight: FontWeight.bold,
    fontSize: 22,
  );

  /// Section headings (e.g. "Selected:", "All Emotions:")
  static const TextStyle heading2 = TextStyle(
    fontFamily: _font,
    fontWeight: FontWeight.bold,
    fontSize: 18,
  );

  /// Step progress text (e.g. "1/4")
  static const TextStyle stepIndicator = TextStyle(
    fontFamily: _font,
    fontWeight: FontWeight.bold,
    fontSize: 18,
  );

  // ── Body ─────────────────────────────────────────────────────────────────

  /// Regular body text
  static const TextStyle body = TextStyle(
    fontFamily: _font,
    fontSize: 16,
  );

  /// Body with semi-bold weight
  static const TextStyle bodySemiBold = TextStyle(
    fontFamily: _font,
    fontWeight: FontWeight.w600,
    fontSize: 16,
  );

  /// Large mood card label
  static const TextStyle bodyBold = TextStyle(
    fontFamily: _font,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  // ── Secondary / Caption ──────────────────────────────────────────────────

  /// Subdescriptions under headings
  static const TextStyle subtitle = TextStyle(
    fontFamily: _font,
    fontSize: 15,
  );

  /// Grey secondary text
  static const TextStyle caption = TextStyle(
    fontFamily: _font,
    fontSize: 12,
  );

  /// Small body text
  static const TextStyle bodySmall = TextStyle(
    fontFamily: _font,
    fontSize: 12,
  );

  /// Timestamp / metadata text
  static const TextStyle timestamp = TextStyle(
    fontFamily: _font,
    fontSize: 12,
  );

  // ── Interactive ──────────────────────────────────────────────────────────

  /// Button label
  static const TextStyle button = TextStyle(
    fontFamily: _font,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  /// Small link / TextButton
  static const TextStyle link = TextStyle(
    fontFamily: _font,
    fontWeight: FontWeight.bold,
    fontSize: 15,
  );

  // ── Chip ──────────────────────────────────────────────────────────────────

  static const TextStyle chip = TextStyle(
    fontFamily: _font,
    fontWeight: FontWeight.w500,
    fontSize: 14,
  );

  // ── Input ─────────────────────────────────────────────────────────────────

  static const TextStyle inputHint = TextStyle(
    fontFamily: _font,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle inputLabel = TextStyle(
    fontFamily: _font,
  );

  // ── Nav bar label ────────────────────────────────────────────────────────

  static const TextStyle navLabel = TextStyle(
    fontFamily: _font,
    fontWeight: FontWeight.w500,
    fontSize: 12,
  );

  // ── Settings ─────────────────────────────────────────────────────────────

  static const TextStyle settingsTile = TextStyle(
    fontFamily: _font,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle settingsSection = TextStyle(
    fontFamily: _font,
    fontWeight: FontWeight.w500,
    fontSize: 18,
  );
}
