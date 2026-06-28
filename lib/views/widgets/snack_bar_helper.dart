import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

void showSnackBar(BuildContext context, String message, [Color? color]) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final baseColor = color ?? AppColors.primary;
  
  // Make background translucent (0.8 opacity) so it's much softer
  final backgroundColor = baseColor.withOpacity(0.8);

  final snackBar = SnackBar(
    content: Text(
      message,
      style: AppTextStyles.body.copyWith(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),
    backgroundColor: backgroundColor,
    behavior: SnackBarBehavior.floating,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: baseColor.withOpacity(0.3), width: 1),
    ),
    action: SnackBarAction(
      label: '✕',
      textColor: Colors.white.withOpacity(0.9),
      onPressed: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      },
    ),
  );

  // Clear previous snackbar and show the new one
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
