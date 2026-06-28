import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

/// Wires light and dark ThemeData for the entire app.
class AppTheme {
  AppTheme._();

  // ── Common component themes ───────────────────────────────────────────────

  static ElevatedButtonThemeData _elevatedButtonTheme(Color bg) =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: Colors.white,
          textStyle: AppTextStyles.button,
          shape: const StadiumBorder(),
          elevation: 0,
        ),
      );

  static InputDecorationTheme _inputDecorationTheme(Color fillColor, Color border) =>
      InputDecorationTheme(
        filled: true,
        fillColor: fillColor,
        hintStyle: AppTextStyles.inputHint.copyWith(color: Colors.grey),
        labelStyle: AppTextStyles.inputLabel,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: border, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: border, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      );

  static ChipThemeData _chipTheme(Color bg, Color selectedBg, Color labelColor) =>
      ChipThemeData(
        backgroundColor: bg,
        selectedColor: selectedBg,
        labelStyle: AppTextStyles.chip.copyWith(color: labelColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      );

  static SnackBarThemeData _snackBarTheme(Color bg) => SnackBarThemeData(
    backgroundColor: bg.withOpacity(0.8),
    contentTextStyle: AppTextStyles.body.copyWith(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: bg.withOpacity(0.3), width: 1),
    ),
  );

  // ── Light Theme ──────────────────────────────────────────────────────────

  static ThemeData get light => ThemeData(
    useMaterial3: false,
    brightness: Brightness.light,
    fontFamily: 'Pangram',
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    cardColor: AppColors.cardLight,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.primaryLight,
      surface: AppColors.surfaceLight,
      error: AppColors.error,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: const IconThemeData(color: AppColors.textPrimaryLight),
      titleTextStyle: AppTextStyles.pageTitle.copyWith(color: AppColors.textPrimaryLight),
    ),
    textTheme: _textTheme(AppColors.textPrimaryLight, AppColors.textSecondaryLight),
    elevatedButtonTheme: _elevatedButtonTheme(AppColors.primary),
    inputDecorationTheme: _inputDecorationTheme(AppColors.surfaceLight, Colors.grey),
    chipTheme: _chipTheme(Colors.grey.shade200, AppColors.primaryLight, AppColors.textPrimaryLight),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected) ? AppColors.primary : Colors.grey,
      ),
      trackColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected) ? AppColors.primaryLight : Colors.grey.shade300,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.cardLight,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.navBarLight,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: AppTextStyles.navLabel,
      unselectedLabelStyle: AppTextStyles.navLabel,
      type: BottomNavigationBarType.fixed,
      elevation: 5,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 5,
      shape: CircleBorder(),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surfaceLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      titleTextStyle: AppTextStyles.heading2.copyWith(color: AppColors.textPrimaryLight),
      contentTextStyle: AppTextStyles.body.copyWith(color: AppColors.textPrimaryLight),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: AppColors.surfaceLight,
      textStyle: AppTextStyles.body.copyWith(color: AppColors.textPrimaryLight),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    listTileTheme: ListTileThemeData(
      iconColor: AppColors.textSecondaryLight,
      textColor: AppColors.textPrimaryLight,
    ),
    dividerColor: Colors.grey.shade200,
    snackBarTheme: _snackBarTheme(AppColors.primary),
  );

  // ── Dark Theme ───────────────────────────────────────────────────────────

  static ThemeData get dark => ThemeData(
    useMaterial3: false,
    brightness: Brightness.dark,
    fontFamily: 'Pangram',
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    cardColor: AppColors.cardDark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.primaryDark,
      surface: AppColors.surfaceDark,
      error: AppColors.error,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: const IconThemeData(color: AppColors.textPrimaryDark),
      titleTextStyle: AppTextStyles.pageTitle.copyWith(color: AppColors.textPrimaryDark),
    ),
    textTheme: _textTheme(AppColors.textPrimaryDark, AppColors.textSecondaryDark),
    elevatedButtonTheme: _elevatedButtonTheme(AppColors.primary),
    inputDecorationTheme: _inputDecorationTheme(AppColors.surfaceDark, Colors.grey.shade700),
    chipTheme: _chipTheme(AppColors.cardDark, AppColors.primaryDark, AppColors.textPrimaryDark),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected) ? AppColors.primary : Colors.grey,
      ),
      trackColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected) ? AppColors.primaryDark : Colors.grey.shade700,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.cardDark,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.navBarDark,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: AppTextStyles.navLabel,
      unselectedLabelStyle: AppTextStyles.navLabel,
      type: BottomNavigationBarType.fixed,
      elevation: 5,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 5,
      shape: CircleBorder(),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surfaceDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      titleTextStyle: AppTextStyles.heading2.copyWith(color: AppColors.textPrimaryDark),
      contentTextStyle: AppTextStyles.body.copyWith(color: AppColors.textPrimaryDark),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: AppColors.surfaceDark,
      textStyle: AppTextStyles.body.copyWith(color: AppColors.textPrimaryDark),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    listTileTheme: ListTileThemeData(
      iconColor: AppColors.textSecondaryDark,
      textColor: AppColors.textPrimaryDark,
    ),
    dividerColor: Colors.grey.shade800,
    snackBarTheme: _snackBarTheme(AppColors.primary),
  );

  // ── Shared text theme ────────────────────────────────────────────────────

  static TextTheme _textTheme(Color primary, Color secondary) => TextTheme(
    displayLarge:  AppTextStyles.heading1.copyWith(color: primary),
    displayMedium: AppTextStyles.heading2.copyWith(color: primary),
    titleLarge:    AppTextStyles.pageTitle.copyWith(color: primary),
    titleMedium:   AppTextStyles.bodySemiBold.copyWith(color: primary),
    bodyLarge:     AppTextStyles.body.copyWith(color: primary),
    bodyMedium:    AppTextStyles.subtitle.copyWith(color: secondary),
    bodySmall:     AppTextStyles.caption.copyWith(color: secondary),
    labelLarge:    AppTextStyles.button.copyWith(color: primary),
    labelSmall:    AppTextStyles.navLabel.copyWith(color: secondary),
  );
}
