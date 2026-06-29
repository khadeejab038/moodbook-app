import 'package:provider/provider.dart';
import 'package:firebasebackend/views/home/home_screen.dart';
import 'package:flutter/material.dart';
import '../../controllers/mood_entry_controller.dart';
import '../../models/emoji_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import 'add_mood_screen3_reasons.dart';
import '../widgets/responsive_extension.dart';
import '../widgets/snack_bar_helper.dart';

class AddEmotions extends StatefulWidget {
  const AddEmotions({super.key});

  @override
  State<AddEmotions> createState() => _AddEmotionsState();
}

class _AddEmotionsState extends State<AddEmotions> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final moodProvider = Provider.of<MoodEntryController>(context);
    final currentMood = moodProvider.moodEntry.getMood.toLowerCase();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final subtitleColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final unselectedCircleBg = isDark ? AppColors.cardDark : Colors.grey.shade300;

    final filteredEmotions = allEmotions
        .where((emotion) => emotion.title.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    final showRecentlyUsed = searchQuery.isEmpty;

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
                      child: Text("2/4", textAlign: TextAlign.center,
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
                        "Choose the emotions that make you feel $currentMood",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.heading1.copyWith(color: textColor, fontSize: context.w(6)),
                      ),
                      SizedBox(height: context.h(1.5)),
                      Text(
                        "Select at least 1 emotion",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.subtitle.copyWith(color: subtitleColor, fontSize: context.w(3.75)),
                      ),
                      SizedBox(height: context.h(3)),

                      // Search Bar
                      TextField(
                        onChanged: (value) => setState(() => searchQuery = value),
                        style: AppTextStyles.body.copyWith(color: textColor),
                        decoration: InputDecoration(
                          hintText: 'Search emotions',
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

                      // Selected Emotions
                      if (moodProvider.selectedEmotions.isNotEmpty) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Selected:",
                                style: AppTextStyles.heading2.copyWith(color: textColor, fontSize: context.w(4.5))),
                            TextButton(
                              onPressed: moodProvider.clearSelectedEmotions,
                              child: Text("Clear all",
                                  style: AppTextStyles.link.copyWith(color: AppColors.error, fontSize: context.w(3.75))),
                            ),
                          ],
                        ),
                        SizedBox(height: context.h(1.5)),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Wrap(
                            spacing: context.w(3),
                            runSpacing: context.h(0.5),
                            children: moodProvider.selectedEmotions.map((emotionTitle) {
                              final emojiItem = allEmotions.firstWhere((item) => item.title == emotionTitle);
                              return Chip(
                                label: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(emojiItem.imagePath, width: context.w(5), height: context.w(5)),
                                    SizedBox(width: context.w(1.2)),
                                    Text(emotionTitle,
                                        style: AppTextStyles.chip.copyWith(
                                          color: isDark ? Colors.white : AppColors.primaryDark,
                                          fontSize: context.w(3.5),
                                        )),
                                  ],
                                ),
                                backgroundColor: isDark ? AppColors.primaryDark : AppColors.primaryLight,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(context.w(5)),
                                ),
                                side: BorderSide(color: AppColors.primary.withOpacity(0.4), width: 0.8),
                                deleteIcon: Icon(Icons.close, size: context.w(4), color: isDark ? Colors.white : AppColors.primaryDark),
                                onDeleted: () => moodProvider.toggleEmotion(emotionTitle),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(height: context.h(2.5)),
                      ],

                      // Recently Used
                      if (showRecentlyUsed && moodProvider.recentlyUsedEmotions.isNotEmpty) ...[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Recently Used:",
                              style: AppTextStyles.heading2.copyWith(color: textColor, fontSize: context.w(4.5))),
                        ),
                        SizedBox(height: context.h(1.5)),
                        Wrap(
                          alignment: WrapAlignment.spaceEvenly,
                          spacing: context.w(4),
                          runSpacing: context.h(1),
                          children: moodProvider.recentlyUsedEmotions.map((emotionTitle) {
                            final emojiItem = allEmotions.firstWhere((item) => item.title == emotionTitle);
                            final isSelected = moodProvider.selectedEmotions.contains(emotionTitle);
                            return GestureDetector(
                              onTap: () => moodProvider.toggleEmotion(emotionTitle),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: isSelected
                                        ? (isDark ? AppColors.primaryDark : AppColors.primaryLight)
                                        : unselectedCircleBg,
                                    radius: context.w(8.5),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: isSelected ? Border.all(color: AppColors.primary, width: 2) : null,
                                      ),
                                      child: ClipOval(
                                        child: Padding(
                                          padding: EdgeInsets.all(context.w(1)),
                                          child: Image.asset(emojiItem.imagePath, fit: BoxFit.contain),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(emotionTitle,
                                      style: AppTextStyles.caption.copyWith(color: textColor, fontSize: context.w(3))),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: context.h(2.5)),
                      ],

                      // All Emotions
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("All Emotions:",
                            style: AppTextStyles.heading2.copyWith(color: textColor, fontSize: context.w(4.5))),
                      ),
                      SizedBox(height: context.h(1.5)),
                      Wrap(
                        alignment: WrapAlignment.spaceEvenly,
                        spacing: context.w(4),
                        runSpacing: context.h(1),
                        children: filteredEmotions.map((emotion) {
                          final isSelected = moodProvider.selectedEmotions.contains(emotion.title);
                          return GestureDetector(
                            onTap: () => moodProvider.toggleEmotion(emotion.title),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor: isSelected
                                      ? (isDark ? AppColors.primaryDark : AppColors.primaryLight)
                                      : unselectedCircleBg,
                                  radius: context.w(8.5),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: isSelected ? Border.all(color: AppColors.primary, width: 2) : null,
                                    ),
                                    child: ClipOval(
                                      child: Padding(
                                        padding: EdgeInsets.all(context.w(1)),
                                        child: Image.asset(emotion.imagePath, fit: BoxFit.contain),
                                      ),
                                    ),
                                  ),
                                ),
                                Text(emotion.title,
                                    style: AppTextStyles.caption.copyWith(color: textColor, fontSize: context.w(3))),
                              ],
                            ),
                          );
                        }).toList(),
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
                    if (moodProvider.selectedEmotions.isEmpty) {
                      showSnackBar(context, 'Please select at least one emotion before continuing.');
                    } else {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const AddReasons()));
                    }
                  },
                  child: Text('Continue', style: AppTextStyles.button.copyWith(color: Colors.white, fontSize: context.w(4))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
