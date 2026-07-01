import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/emoji_item.dart';
import '../../models/emoji_data.dart';
import '../widgets/bottom_nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'edit_mood_screen.dart';
import '../widgets/responsive_extension.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../widgets/snack_bar_helper.dart';
import '../../utils/error_parser.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String _sortingOption = 'newest'; // Default sorting option
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  int moodToValue(String mood) {
    switch (mood.toLowerCase()) {
      case 'terrible':
        return 1;
      case 'bad':
        return 2;
      case 'neutral':
        return 3;
      case 'good':
        return 4;
      case 'excellent':
        return 5;
      default:
        return 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the current user's ID
    final currentUser = FirebaseAuth.instance.currentUser;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    // Check if the user is logged in
    if (currentUser == null) {
      return Scaffold(
        body: Center(
          child: Text(
            'You are not logged in. Please sign in to view your mood history.',
            style: AppTextStyles.body.copyWith(fontSize: context.w(4), color: textColor),
          ),
        ),
        bottomNavigationBar: BottomNavBar(currentIndex: 3),
      );
    }

    final userId = currentUser.uid;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark ? AppColors.pageGradientDark : AppColors.pageGradientLight,
        ),
        child: Column(
          children: [
            // History text and filter button
            Padding(
              padding: EdgeInsets.fromLTRB(context.w(4), context.h(9.5), context.w(4), context.h(1)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'History',
                    style: AppTextStyles.pageTitle.copyWith(
                      color: textColor,
                      fontSize: context.w(5),
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(Icons.sort, color: textColor),
                    onSelected: (value) {
                      setState(() {
                        _sortingOption = value;
                      });
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'newest',
                        child: Text('Newest First', style: AppTextStyles.body),
                      ),
                      PopupMenuItem(
                        value: 'oldest',
                        child: Text('Oldest First', style: AppTextStyles.body),
                      ),
                      PopupMenuItem(
                        value: 'best',
                        child: Text('Best First', style: AppTextStyles.body),
                      ),
                      PopupMenuItem(
                        value: 'worst',
                        child: Text('Worst First', style: AppTextStyles.body),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Search Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.w(4), vertical: context.h(1)),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                style: AppTextStyles.body.copyWith(color: textColor),
                decoration: InputDecoration(
                  hintText: 'Search emotions, reasons, or notes...',
                  hintStyle: AppTextStyles.inputHint.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                  filled: true,
                  fillColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                  contentPadding: EdgeInsets.symmetric(horizontal: context.w(4), vertical: context.h(1.2)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(context.w(7.5))),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(context.w(7.5)),
                    borderSide: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(context.w(7.5)),
                    borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('mood_entries')
                    .where('userId', isEqualTo: userId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'An error occurred: ${snapshot.error}',
                        style: AppTextStyles.body.copyWith(
                          fontSize: context.w(4),
                          color: AppColors.error,
                        ),
                      ),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        'No mood entries found.',
                        style: AppTextStyles.body.copyWith(
                          fontSize: context.w(4),
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                    );
                  }

                  var moodEntries = snapshot.data!.docs;

                  final filteredEntries = moodEntries.where((entry) {
                    final data = entry.data() as Map<String, dynamic>?;
                    if (data == null) return false;
                    if (_searchQuery.isEmpty) return true;
                    
                    final query = _searchQuery.toLowerCase();
                    final emotions = List<String>.from(data['emotions'] ?? []);
                    final reasons = List<String>.from(data['reasons'] ?? []);
                    final note = (data['notes'] as String? ?? '').toLowerCase();

                    final matchesEmotions = emotions.any((e) => e.toLowerCase().contains(query));
                    final matchesReasons = reasons.any((r) => r.toLowerCase().contains(query));
                    final matchesNote = note.contains(query);

                    return matchesEmotions || matchesReasons || matchesNote;
                  }).toList();

                  if (filteredEntries.isEmpty) {
                    return Center(
                      child: Text(
                        'No matching entries found.',
                        style: AppTextStyles.body.copyWith(
                          fontSize: context.w(4),
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                    );
                  }

                  // Sort the filtered entries
                  if (_sortingOption == 'newest') {
                    filteredEntries.sort((a, b) {
                      final aData = a.data() as Map<String, dynamic>?;
                      final bData = b.data() as Map<String, dynamic>?;
                      final aTime = aData?['timestamp'] as Timestamp?;
                      final bTime = bData?['timestamp'] as Timestamp?;
                      if (aTime == null || bTime == null) return 0;
                      return bTime.compareTo(aTime);
                    });
                  } else if (_sortingOption == 'oldest') {
                    filteredEntries.sort((a, b) {
                      final aData = a.data() as Map<String, dynamic>?;
                      final bData = b.data() as Map<String, dynamic>?;
                      final aTime = aData?['timestamp'] as Timestamp?;
                      final bTime = bData?['timestamp'] as Timestamp?;
                      if (aTime == null || bTime == null) return 0;
                      return aTime.compareTo(bTime);
                    });
                  } else if (_sortingOption == 'best') {
                    filteredEntries.sort((a, b) {
                      final aData = a.data() as Map<String, dynamic>?;
                      final bData = b.data() as Map<String, dynamic>?;
                      final aMood = aData?['mood'] as String? ?? 'Neutral';
                      final bMood = bData?['mood'] as String? ?? 'Neutral';
                      return moodToValue(bMood).compareTo(moodToValue(aMood));
                    });
                  } else if (_sortingOption == 'worst') {
                    filteredEntries.sort((a, b) {
                      final aData = a.data() as Map<String, dynamic>?;
                      final bData = b.data() as Map<String, dynamic>?;
                      final aMood = aData?['mood'] as String? ?? 'Neutral';
                      final bMood = bData?['mood'] as String? ?? 'Neutral';
                      return moodToValue(aMood).compareTo(moodToValue(bMood));
                    });
                  }

                  return ListView.builder(
                    padding: EdgeInsets.all(context.w(4)),
                    itemCount: filteredEntries.length,
                    itemBuilder: (context, index) {
                      final entry = filteredEntries[index];
                      final data = entry.data() as Map<String, dynamic>?;
                      final moodStr = data?['mood'] as String? ?? 'Neutral';
                      final rawTimestamp = data?['timestamp'];
                      DateTime parsedTime = DateTime.now();
                      if (rawTimestamp is Timestamp) {
                        parsedTime = rawTimestamp.toDate();
                      }

                      // Find the matching mood or default to Neutral
                      final emojiItem = moods.firstWhere(
                            (moodItem) => moodItem.title.toLowerCase() == moodStr.toLowerCase(),
                        orElse: () => EmojiItem(imagePath: 'assets/neutral-face.png', title: 'Neutral'),
                      );

                      final emotionsList = data?['emotions'] as List<dynamic>?;
                      final reasonsList = data?['reasons'] as List<dynamic>?;

                      return HistoryTile(
                        mood: moodStr,
                        emoji: Image.asset(
                          emojiItem.imagePath,
                          width: context.w(8),
                          height: context.w(8),
                          fit: BoxFit.contain,
                        ),
                        timestamp: DateFormat('dd/MM/yyyy hh:mm a').format(parsedTime),
                        feelings: emotionsList?.join(', ') ?? 'No emotions',
                        reason: reasonsList?.join(', ') ?? 'No reason',
                        note: data?['notes'] as String? ?? 'No note',
                        entryId: entry.id,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 3),
    );
  }
}

class HistoryTile extends StatefulWidget {
  final String mood;
  final String timestamp;
  final String feelings;
  final String reason;
  final String note;
  final String entryId;
  final Widget emoji;

  HistoryTile({
    required this.mood,
    required this.emoji,
    required this.timestamp,
    required this.feelings,
    required this.reason,
    required this.note,
    required this.entryId,
  });

  @override
  _HistoryTileState createState() => _HistoryTileState();
}

class _HistoryTileState extends State<HistoryTile> {
  bool _isNoteExpanded = false;

  void _deleteEntry() async {
    try {
      await FirebaseFirestore.instance.collection('mood_entries').doc(widget.entryId).delete();
    } catch (e) {
      if (mounted) {
        showSnackBar(context, ErrorParser.getFriendlyMessage(e));
      }
    }
  }

  void _editEntry() async {
    try {
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection('mood_entries')
          .doc(widget.entryId)
          .get();

      if (mounted) {
        if (document.exists) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditMoodScreen(moodEntryDoc: document),
            ),
          );
        } else {
          showSnackBar(context, 'Mood entry not found');
        }
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(context, ErrorParser.getFriendlyMessage(e));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final subtitleColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final cardBg = isDark ? AppColors.cardDark : Colors.white;

    String displayedNote = widget.note.length > 40
        ? widget.note.substring(0, 40)
        : widget.note;

    bool showReadMore = widget.note.length > 40;

    if (_isNoteExpanded && widget.note.length > 40) {
      displayedNote = widget.note;
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: context.h(1)),
      padding: EdgeInsets.all(context.w(4)),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(context.w(3)),
        border: isDark ? Border.all(color: Colors.grey.shade800) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              widget.emoji,
              SizedBox(width: context.w(2)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.mood,
                    style: AppTextStyles.bodyBold.copyWith(
                      fontSize: context.w(4.5),
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: context.h(0.5)),
                  Text(
                    widget.timestamp,
                    style: AppTextStyles.caption.copyWith(
                      fontSize: context.w(3),
                      color: subtitleColor,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Row(
                children: [
                  IconButton(
                      icon: Icon(Icons.delete, color: AppColors.error, size: context.w(5)),
                      onPressed: _deleteEntry,
                    ),
                  Container(
                    width: context.w(0.25),
                    height: context.h(3),
                    color: isDark ? Colors.grey.shade800 : Colors.grey.withOpacity(0.5),
                  ),
                  IconButton(
                      icon: Icon(Icons.edit, color: AppColors.primary, size: context.w(5)),
                      onPressed: _editEntry,
                    ),
                ],
              ),
            ],
          ),
          SizedBox(height: context.h(1)),
          RichText(
            text: TextSpan(
              style: AppTextStyles.body.copyWith(
                fontSize: context.w(4),
                color: textColor,
              ),
              children: [
                const TextSpan(
                  text: 'You felt ',
                  style: TextStyle(fontWeight: FontWeight.normal),
                ),
                TextSpan(
                  text: widget.feelings,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(
                  text: '\nBecause of ',
                  style: TextStyle(fontWeight: FontWeight.normal),
                ),
                TextSpan(
                  text: widget.reason,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(height: context.h(1)),
          Text(
            'Note: $displayedNote',
            style: AppTextStyles.body.copyWith(
              fontSize: context.w(3.5),
              color: subtitleColor,
            ),
          ),
          if (showReadMore)
            TextButton(
              onPressed: () {
                setState(() {
                  _isNoteExpanded = !_isNoteExpanded;
                });
              },
              child: Text(
                _isNoteExpanded ? '- Read less' : '+ Read more',
                style: AppTextStyles.link.copyWith(color: AppColors.primary),
              ),
            ),
        ],
      ),
    );
  }
}
