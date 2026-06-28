import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/mood_entry.dart';
import '../../models/database/mood_entry_database.dart';
import '../../models/emoji_data.dart';
import '../../models/reasons_data.dart';
import '../widgets/date_time_picker.dart';
import '../widgets/responsive_extension.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class EditMoodScreen extends StatefulWidget {
  final DocumentSnapshot moodEntryDoc;

  EditMoodScreen({required this.moodEntryDoc});

  @override
  _EditMoodScreenState createState() => _EditMoodScreenState();
}

class _EditMoodScreenState extends State<EditMoodScreen> {
  late DateTime selectedDateTime;
  late String selectedMood;
  late int selectedEmojiIndex;
  late TextEditingController notesController;
  late List<String> selectedEmotions;
  late TextEditingController reasonsController;

  @override
  void initState() {
    super.initState();
    final moodEntry = widget.moodEntryDoc.data() as Map<String, dynamic>;

    // Initialize values
    selectedDateTime = (moodEntry['timestamp'] as Timestamp).toDate();
    selectedMood = moodEntry['mood'];
    selectedEmojiIndex = getMoodIndex(selectedMood);

    notesController = TextEditingController(text: moodEntry['notes'] ?? '');
    selectedEmotions = List<String>.from(moodEntry['emotions'] ?? []);
    reasonsController = TextEditingController(
        text: (moodEntry['reasons'] as List<dynamic>).join(', '));
  }

  // Helper function to get the mood index based on the current mood string
  int getMoodIndex(String mood) {
    switch (mood) {
      case 'Terrible':
        return 0;
      case 'Bad':
        return 1;
      case 'Neutral':
        return 2;
      case 'Good':
        return 3;
      case 'Excellent':
        return 4;
      default:
        return 2; // Default to Neutral if no match
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final subtitleColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final containerBg = isDark ? AppColors.cardDark : Colors.white;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Edit Mood Entry", style: AppTextStyles.pageTitle.copyWith(color: textColor, fontSize: context.w(5.5))),
        iconTheme: IconThemeData(color: textColor),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: isDark ? AppColors.pageGradientDark : AppColors.pageGradientLight,
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(context.w(4)),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                // Editable Timestamp
                Text("Timestamp", style: AppTextStyles.bodyBold.copyWith(color: textColor, fontSize: context.w(4))),
                Row(
                  children: [
                    Text(
                      "${selectedDateTime.toLocal()}".split('.')[0],
                      style: AppTextStyles.body.copyWith(color: textColor, fontSize: context.w(4)),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, size: context.w(5), color: AppColors.primary),
                      onPressed: () async {
                        await selectDateAndTime(
                            context,
                            selectedDateTime,
                                (newDateTime) {
                              setState(() {
                                selectedDateTime = newDateTime;
                              });
                            }
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: context.h(1.5)),

                // Editable Mood
                Text("Mood", style: AppTextStyles.bodyBold.copyWith(color: textColor, fontSize: context.w(4))),
                SizedBox(height: context.h(1)),
                Container(
                  height: context.h(15),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: moods.length,
                    itemBuilder: (context, index) {
                      final isSelected = selectedEmojiIndex == index;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedMood = moods[index].title;
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
                            color: containerBg,
                            shape: BoxShape.circle,
                            border: isSelected ? Border.all(color: AppColors.primary, width: 2) : (isDark ? Border.all(color: Colors.grey.shade800) : null),
                            boxShadow: isSelected
                                ? [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              )
                            ]
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
                SizedBox(height: context.h(1.5)),

                // Editable Emotions
                Text("Emotions", style: AppTextStyles.bodyBold.copyWith(color: textColor, fontSize: context.w(4))),
                SizedBox(height: context.h(1)),
                Wrap(
                  spacing: context.w(2),
                  runSpacing: context.h(0.5),
                  children: allEmotions.map((emotion) {
                    final isSelected = selectedEmotions.contains(emotion.title);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedEmotions.remove(emotion.title);
                          } else {
                            selectedEmotions.add(emotion.title);
                          }
                        });
                      },
                      child: Chip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              emotion.imagePath,
                              width: context.w(5),
                              height: context.w(5),
                            ),
                            SizedBox(width: context.w(2)),
                            Text(
                              emotion.title,
                              style: AppTextStyles.chip.copyWith(
                                color: isSelected ? (isDark ? Colors.white : AppColors.primaryDark) : textColor,
                              ),
                            ),
                          ],
                        ),
                        backgroundColor: isSelected
                            ? (isDark ? AppColors.primaryDark : AppColors.primaryLight)
                            : (isDark ? AppColors.cardDark : Colors.grey[200]),
                        deleteIcon: isSelected ? Icon(Icons.close, size: 16, color: isDark ? Colors.white : AppColors.primaryDark) : null,
                        onDeleted: isSelected
                            ? () {
                          setState(() {
                            selectedEmotions.remove(emotion.title);
                          });
                        }
                            : null,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.w(5))),
                        side: isSelected
                            ? BorderSide(color: AppColors.primary.withOpacity(0.4), width: 0.8)
                            : (isDark ? BorderSide(color: Colors.grey.shade800) : BorderSide.none),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: context.h(1.5)),

                // Editable Reasons
                Text("Reasons", style: AppTextStyles.bodyBold.copyWith(color: textColor, fontSize: context.w(4))),
                SizedBox(height: context.h(1)),
                Wrap(
                  spacing: context.w(2),
                  runSpacing: context.h(0.5),
                  children: allReasons.map((reason) {
                    final isSelected = reasonsController.text.contains(reason);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            reasonsController.text = reasonsController.text
                                .replaceAll(RegExp(',?\\b$reason\\b,?'), '')
                                .trim();
                          } else {
                            reasonsController.text += (reasonsController.text.isEmpty
                                ? ''
                                : ', ') + reason;
                          }
                        });
                      },
                      child: Chip(
                        label: Text(
                          reason,
                          style: AppTextStyles.chip.copyWith(
                            color: isSelected ? (isDark ? Colors.white : AppColors.primaryDark) : textColor,
                          ),
                        ),
                        backgroundColor: isSelected
                            ? (isDark ? AppColors.primaryDark : AppColors.primaryLight)
                            : (isDark ? AppColors.cardDark : Colors.grey[200]),
                        deleteIcon: isSelected ? Icon(Icons.close, size: 16, color: isDark ? Colors.white : AppColors.primaryDark) : null,
                        onDeleted: isSelected
                            ? () {
                          setState(() {
                            reasonsController.text = reasonsController.text
                                .replaceAll(RegExp(',?\\b$reason\\b,?'), '')
                                .trim();
                          });
                        }
                            : null,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.w(5))),
                        side: isSelected
                            ? BorderSide(color: AppColors.primary.withOpacity(0.4), width: 0.8)
                            : (isDark ? BorderSide(color: Colors.grey.shade800) : BorderSide.none),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: context.h(1.5)),

                // Editable Notes
                Text("Notes", style: AppTextStyles.bodyBold.copyWith(color: textColor, fontSize: context.w(4))),
                SizedBox(height: context.h(1)),
                TextFormField(
                  controller: notesController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "Additional details...",
                    hintStyle: AppTextStyles.inputHint.copyWith(color: subtitleColor),
                    filled: true,
                    fillColor: containerBg,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(context.w(2.5)),
                      borderSide: isDark ? BorderSide(color: Colors.grey.shade800) : const BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(context.w(2.5)),
                      borderSide: isDark ? BorderSide(color: Colors.grey.shade800) : const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(context.w(2.5)),
                      borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                    ),
                  ),
                  style: AppTextStyles.body.copyWith(color: textColor, fontWeight: FontWeight.normal),
                ),
                SizedBox(height: context.h(2.5)),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? AppColors.cardDark : Colors.grey[400],
                        minimumSize: Size(context.w(35), context.h(6)),
                      ),
                      onPressed: () => Navigator.of(context).pop(), // Discard
                      child: Text("Discard", style: AppTextStyles.button.copyWith(color: isDark ? textColor : Colors.black)),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        minimumSize: Size(context.w(35), context.h(6)),
                      ),
                      onPressed: () {
                        if (selectedEmotions.isEmpty || reasonsController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: const Text('Please select at least one emotion and one reason'), backgroundColor: AppColors.primary),
                          );
                        } else {
                          // Prepare updated data
                          final updatedMoodEntry = MoodEntry(
                            timestamp: selectedDateTime,
                            mood: selectedMood,
                            emotions: selectedEmotions,
                            reasons: reasonsController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
                            notes: notesController.text,
                          );

                          try {
                            MoodEntryDatabase.updateMoodEntry(
                                widget.moodEntryDoc.id, updatedMoodEntry);
                            Navigator.of(context).pop();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error updating entry: $e'), backgroundColor: AppColors.primary),
                            );
                          }
                        }
                      },
                      child: Text("Save", style: AppTextStyles.button.copyWith(color: Colors.white)),
                    ),
                  ],
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
