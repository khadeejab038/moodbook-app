import '../../models/database/mood_entry_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/mood_entry_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import 'add_mood_screen5_popup.dart';
import '../widgets/responsive_extension.dart';
import '../widgets/snack_bar_helper.dart';
import '../../utils/error_parser.dart';
import '../../utils/network_helper.dart';

class AddNotes extends StatefulWidget {
  const AddNotes({super.key});

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  TextEditingController notesController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    final moodProvider = Provider.of<MoodEntryController>(context, listen: false);

    // Pre-fill the TextField with the saved note if it exists
    notesController.text = moodProvider.moodEntry.getNotes ?? '';
  }

  // Show popup dialog with mood-specific message
  void showPopupDialog(String mood) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AddMoodPopup(mood: mood),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: textColor),
                      onPressed: () {
                        final moodProvider = Provider.of<MoodEntryController>(context, listen: false);
                        moodProvider.moodEntry.setNotes = notesController.text;
                        Navigator.pop(context);
                      },
                    ),
                    Expanded(
                      child: Text(
                        "4/4",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.stepIndicator.copyWith(color: textColor),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: textColor),
                      onPressed: () {
                        final moodProvider = Provider.of<MoodEntryController>(context, listen: false);
                        moodProvider.clear();
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
                      // Harmonious Centered Headings
                      Text(
                        "Anything you want to add",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.heading1.copyWith(color: textColor, fontSize: context.w(6)),
                      ),
                      SizedBox(height: context.h(1.5)),
                      Text(
                        "Add your notes on any thought that relates to your mood",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.subtitle.copyWith(color: subtitleColor, fontSize: context.w(3.75)),
                      ),
                      SizedBox(height: context.h(3)),
                      // Notes Input Area
                      Container(
                        height: context.h(37.5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(context.w(5)),
                          boxShadow: isDark ? [] : const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 40,
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: notesController,
                          maxLines: 15,
                          style: AppTextStyles.body.copyWith(color: textColor),
                          decoration: InputDecoration(
                            hintText: "Write your notes here",
                            hintStyle: AppTextStyles.inputHint.copyWith(color: subtitleColor),
                            filled: true,
                            fillColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(context.w(2.5)),
                              borderSide: isDark ? BorderSide(color: Colors.grey.shade800) : BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(context.w(2.5)),
                              borderSide: isDark ? BorderSide(color: Colors.grey.shade800) : BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(context.w(2.5)),
                              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: context.h(4)),
                    ],
                  ),
                ),
              ),
              // Standardized Bottom Button (Save)
              Padding(
                padding: EdgeInsets.fromLTRB(context.w(5), 0, context.w(5), context.h(3)),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(context.w(10)),
                    ),
                    minimumSize: Size(context.w(85), context.h(7.5)),
                  ),
                  onPressed: _isSaving
                      ? null
                      : () async {
                          setState(() {
                            _isSaving = true;
                          });
                          final moodProvider = Provider.of<MoodEntryController>(context, listen: false);
                          final moodEntry = moodProvider.moodEntry;
                          moodEntry.setNotes = notesController.text;

                          try {
                            final hasNetwork = await NetworkHelper.isConnected();
                            if (hasNetwork) {
                              await MoodEntryDatabase.saveMoodEntryToFirebase(moodEntry);
                              if (context.mounted) {
                                moodProvider.clear();
                                showPopupDialog(moodEntry.getMood);
                              }
                            } else {
                              // Fire-and-forget save to local cache
                              MoodEntryDatabase.saveMoodEntryToFirebase(moodEntry).catchError((e) {
                                print('Offline save error: $e');
                              });
                              if (context.mounted) {
                                showSnackBar(context, 'Saved locally. Your entry will sync when connection is restored.');
                                moodProvider.clear();
                                showPopupDialog(moodEntry.getMood);
                              }
                            }
                          } catch (e) {
                            print('Error: $e');
                            if (context.mounted) {
                              showSnackBar(context, ErrorParser.getFriendlyMessage(e));
                            }
                          } finally {
                            if (mounted) {
                              setState(() {
                                _isSaving = false;
                              });
                            }
                          }
                        },
                  child: Text(
                    'Save',
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
    );
  }
}
