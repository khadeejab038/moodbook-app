import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/mood_entry_controller.dart';
import '../../models/emoji_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../widgets/date_time_picker.dart';
import 'add_mood_screen2_emotions.dart';
import '../widgets/responsive_extension.dart';

class AddMood extends StatefulWidget {
  @override
  _AddMoodState createState() => _AddMoodState();
}

class _AddMoodState extends State<AddMood> {
  DateTime? selectedDateTime;
  int selectedEmojiIndex = 2; // Default to the middle emoji (Neutral)

  @override
  void initState() {
    super.initState();
    selectedDateTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final moodEntryProvider = Provider.of<MoodEntryController>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final subtitleColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

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
                    Visibility(
                      visible: false,
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {},
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "1/4",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.stepIndicator.copyWith(color: textColor),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: textColor),
                      onPressed: () {
                        moodEntryProvider.clear();
                        Navigator.popUntil(context, (route) => route.isFirst);
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
                      // Date & Time picker button
                      ElevatedButton(
                        onPressed: () => selectDateAndTime(
                          context,
                          selectedDateTime ?? DateTime.now(),
                          (DateTime newDateTime) {
                            setState(() {
                              selectedDateTime = newDateTime;
                            });
                          },
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                          foregroundColor: textColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(context.w(7)),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: context.w(5), vertical: context.h(1.8)),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              selectedDateTime != null
                                  ? "${selectedDateTime!.day}/${selectedDateTime!.month}/${selectedDateTime!.year}, ${selectedDateTime!.hour}:${selectedDateTime!.minute.toString().padLeft(2, '0')}"
                                  : "Select Date & Time",
                              style: AppTextStyles.body.copyWith(color: textColor, fontSize: context.w(3.75)),
                            ),
                            SizedBox(width: context.w(2.5)),
                            Icon(Icons.calendar_month_outlined, color: textColor),
                          ],
                        ),
                      ),
                      SizedBox(height: context.h(3)),
                      Text(
                        "What's your mood right now?",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.heading1.copyWith(color: textColor, fontSize: context.w(6)),
                      ),
                      SizedBox(height: context.h(1.5)),
                      Text(
                        "Select mood that reflects the most how you are feeling at this moment.",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.subtitle.copyWith(color: subtitleColor, fontSize: context.w(3.75)),
                      ),
                      SizedBox(height: context.h(4)),
                      // Horizontal Mood List
                      SizedBox(
                        height: context.h(15),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: moods.length,
                          itemBuilder: (context, index) {
                            final isSelected = selectedEmojiIndex == index;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedEmojiIndex = index;
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: EdgeInsets.symmetric(horizontal: context.w(2)),
                                width: isSelected ? context.w(20) : context.w(15),
                                height: isSelected ? context.w(20) : context.w(15),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.cardDark : Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: isSelected
                                      ? [BoxShadow(color: Colors.black26, blurRadius: 10, offset: const Offset(0, 4))]
                                      : [],
                                ),
                                child: Image.asset(
                                  moods[index].imagePath,
                                  width: isSelected ? context.w(10) : context.w(7.5),
                                  height: isSelected ? context.w(10) : context.w(7.5),
                                ),
                              ),
                            );
                          },
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
                    moodEntryProvider.setMood(moods[selectedEmojiIndex].title);
                    moodEntryProvider.setTimestamp(selectedDateTime!);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AddEmotions()));
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
}
