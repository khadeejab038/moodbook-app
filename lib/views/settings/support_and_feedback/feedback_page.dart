import 'package:flutter/material.dart';
import '../../widgets/responsive_extension.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

class FeedbackPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final subtitleColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final fieldBg = isDark ? AppColors.surfaceDark : Colors.white;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Feedback',
          style: AppTextStyles.pageTitle.copyWith(
            fontSize: context.w(6),
            color: textColor,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: isDark ? AppColors.homeGradientDark : AppColors.homeGradientLight,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(context.w(4)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                // Title
                Text(
                  'We value your feedback!',
                  style: AppTextStyles.heading2.copyWith(
                    fontSize: context.w(5),
                    color: textColor,
                  ),
                ),
                SizedBox(height: context.h(2.5)),

                // Feedback text area
                Text(
                  'Please provide your feedback below:',
                  style: AppTextStyles.bodyBold.copyWith(
                    fontSize: context.w(4),
                    color: textColor,
                  ),
                ),
                SizedBox(height: context.h(1.2)),
                TextField(
                  maxLines: 5,
                  style: AppTextStyles.body.copyWith(color: textColor),
                  decoration: InputDecoration(
                    hintText: 'Enter your feedback...',
                    hintStyle: AppTextStyles.inputHint.copyWith(color: subtitleColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(context.w(3)),
                      borderSide: isDark ? BorderSide(color: Colors.grey.shade800) : const BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(context.w(3)),
                      borderSide: isDark ? BorderSide(color: Colors.grey.shade800) : const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(context.w(3)),
                      borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                    ),
                    filled: true,
                    fillColor: fieldBg,
                    contentPadding: EdgeInsets.all(context.w(4)),
                  ),
                ),
                SizedBox(height: context.h(2.5)),

                // Submit Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Submit feedback
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(context.w(6.25)),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: context.w(10), vertical: context.h(1.5)),
                      elevation: 0,
                    ),
                    child: Text(
                      'Submit Feedback',
                      style: AppTextStyles.button.copyWith(
                        fontSize: context.w(4),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
       ),
      ),
    );
  }
}
