import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/mood_entry_controller.dart';
import '../../models/reasons_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../home/home_screen.dart';
import 'add_mood_screen4_notes.dart';
import '../widgets/responsive_extension.dart';
import '../widgets/snack_bar_helper.dart';

class AddReasons extends StatefulWidget {
  const AddReasons({super.key});

  @override
  State<AddReasons> createState() => _AddReasonsState();
}

class _AddReasonsState extends State<AddReasons> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final moodProvider = Provider.of<MoodEntryController>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final subtitleColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    final filteredReasons = allReasons
        .where((reason) => reason.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark ? AppColors.addMoodGradientDark : AppColors.addMoodGradient,
        ),
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
          child: Column(
            children: [
              // Standardized Top Bar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.w(3), vertical: context.h(1)),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: textColor),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text("3/4", textAlign: TextAlign.center,
                          style: AppTextStyles.stepIndicator.copyWith(color: textColor)),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: textColor),
                      onPressed: () {
                        moodProvider.clear();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                          (route) => false,
                        );
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: context.w(5)),
                  child: Column(
                    children: [
                      SizedBox(height: context.h(2)),
                      Text(
                        "What's the reason making you feel this way?",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.heading1.copyWith(color: textColor, fontSize: context.w(6)),
                      ),
                      SizedBox(height: context.h(1.5)),
                      Text(
                        "Select the reasons that reflected your emotions",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.subtitle.copyWith(color: subtitleColor, fontSize: context.w(3.75)),
                      ),
                      SizedBox(height: context.h(3)),

                      // Search Bar
                      TextField(
                        onChanged: (value) => setState(() => searchQuery = value),
                        style: AppTextStyles.body.copyWith(color: textColor),
                        decoration: InputDecoration(
                          hintText: 'Search reasons',
                          hintStyle: AppTextStyles.inputHint.copyWith(color: subtitleColor),
                          filled: true,
                          fillColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(context.w(7.5))),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(context.w(7.5)),
                            borderSide: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(context.w(7.5)),
                            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                          ),
                          suffixIcon: Icon(Icons.search, color: subtitleColor),
                        ),
                      ),
                      SizedBox(height: context.h(3)),

                      // Selected reasons
                      if (moodProvider.selectedReasons.isNotEmpty) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Selected:",
                                style: AppTextStyles.heading2.copyWith(color: textColor, fontSize: context.w(4.5))),
                            TextButton(
                              onPressed: () => setState(() => moodProvider.clearSelectedReasons()),
                              child: Text("Clear all",
                                  style: AppTextStyles.link.copyWith(color: AppColors.error, fontSize: context.w(3.75))),
                            ),
                          ],
                        ),
                        SizedBox(height: context.h(1.5)),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Wrap(
                            spacing: context.w(2.5),
                            runSpacing: context.h(0.5),
                            children: moodProvider.selectedReasons.map((reason) {
                              return Chip(
                                label: Text(reason, style: AppTextStyles.chip.copyWith(
                                  color: isDark ? Colors.white : AppColors.primaryDark,
                                )),
                                backgroundColor: isDark ? AppColors.primaryDark : AppColors.primaryLight,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(context.w(5)),
                                ),
                                side: BorderSide(color: AppColors.primary.withOpacity(0.4), width: 0.8),
                                deleteIcon: Icon(Icons.close, size: context.w(4), color: isDark ? Colors.white : AppColors.primaryDark),
                                onDeleted: () => setState(() => moodProvider.toggleReason(reason)),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(height: context.h(2.5)),
                      ],

                      // Recently used
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Recently used",
                            style: AppTextStyles.heading2.copyWith(color: textColor, fontSize: context.w(4.5))),
                      ),
                      SizedBox(height: context.h(1.5)),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          spacing: context.w(2.5),
                          runSpacing: context.h(0.5),
                          children: moodProvider.recentlyUsedReasons
                              .map((reason) => _reasonChip(reason, moodProvider, isDark, textColor))
                              .toList(),
                        ),
                      ),
                      SizedBox(height: context.h(2.5)),

                      // All reasons
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("All reasons",
                            style: AppTextStyles.heading2.copyWith(color: textColor, fontSize: context.w(4.5))),
                      ),
                      SizedBox(height: context.h(1.5)),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          spacing: context.w(2.5),
                          runSpacing: context.h(1.2),
                          children: filteredReasons
                              .map((reason) => _reasonChip(reason, moodProvider, isDark, textColor))
                              .toList(),
                        ),
                      ),
                      SizedBox(height: context.h(4)),
                    ],
                  ),
                ),
              ),
              // Standardized Bottom Button
              Padding(
                padding: EdgeInsets.fromLTRB(context.w(5), 0, context.w(5), context.h(3)),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.w(10))),
                    minimumSize: Size(context.w(85), context.h(7.5)),
                  ),
                  onPressed: () {
                    if (moodProvider.selectedReasons.isEmpty) {
                      showSnackBar(context, 'Please select at least one reason before continuing.');
                    } else {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const AddNotes()));
                    }
                  },
                  child: Text("Continue", style: AppTextStyles.button.copyWith(color: Colors.white, fontSize: context.w(4))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _reasonChip(String reason, MoodEntryController moodProvider, bool isDark, Color textColor) {
    final isSelected = moodProvider.selectedReasons.contains(reason);
    return GestureDetector(
      onTap: () => setState(() => moodProvider.toggleReason(reason)),
      child: Chip(
        label: Text(
          reason,
          style: AppTextStyles.chip.copyWith(
            color: isSelected
                ? (isDark ? Colors.white : AppColors.primaryDark)
                : textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: isSelected
            ? (isDark ? AppColors.primaryDark : AppColors.primaryLight)
            : (isDark ? AppColors.cardDark : Colors.grey.shade300),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.w(5)),
        ),
        side: isSelected
            ? BorderSide(color: AppColors.primary.withOpacity(0.4), width: 0.8)
            : (isDark ? BorderSide(color: Colors.grey.shade800) : BorderSide.none),
      ),
    );
  }
}
