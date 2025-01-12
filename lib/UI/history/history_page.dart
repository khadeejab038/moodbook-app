import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Models/emoji_item.dart';
import '../../Utils/emoji_data.dart';
import '../../Widgets/bottom_nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'edit_mood_screen.dart';

// class HistoryPage extends StatefulWidget {
//   @override
//   _HistoryPageState createState() => _HistoryPageState();
// }
//
// class _HistoryPageState extends State<HistoryPage> {
//   String _sortingOption = 'newest'; // Default sorting option
//
//   int moodToValue(String mood) {
//     switch (mood.toLowerCase()) {
//       case 'terrible':
//         return 1;
//       case 'bad':
//         return 2;
//       case 'neutral':
//         return 3;
//       case 'good':
//         return 4;
//       case 'excellent':
//         return 5;
//       default:
//         return 3; // Default to neutral if mood is unrecognized
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Get the current user's ID
//     final currentUser = FirebaseAuth.instance.currentUser;
//
//     // Check if the user is logged in
//     if (currentUser == null) {
//       return Center(
//         child: Text(
//           'You are not logged in. Please sign in to view your mood history.',
//           style: TextStyle(fontFamily: 'Pangram', fontSize: 16),
//         ),
//       );
//     }
//
//     final userId = currentUser.uid;
//
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         title: PreferredSize(
//           preferredSize: Size.fromHeight(kToolbarHeight),
//           child: Align(
//             alignment: Alignment.centerLeft,
//             child: Text(
//               'History',
//               style: TextStyle(
//                 fontFamily: 'Pangram',
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF100F11),
//                 fontSize: 20.0,
//               ),
//             ),
//           ),
//         ),
//         iconTheme: IconThemeData(color: Color(0xFF100F11)),
//         actions: [
//           PopupMenuButton<String>(
//             icon: Icon(Icons.sort, color: Color(0xFF100F11)),
//             onSelected: (value) {
//               setState(() {
//                 _sortingOption = value;
//               });
//             },
//             itemBuilder: (context) => [
//               PopupMenuItem(
//                 value: 'newest',
//                 child: Text('Newest First', style: TextStyle(fontFamily: 'Pangram')),
//               ),
//               PopupMenuItem(
//                 value: 'oldest',
//                 child: Text('Oldest First', style: TextStyle(fontFamily: 'Pangram')),
//               ),
//               PopupMenuItem(
//                 value: 'best',
//                 child: Text('Best First', style: TextStyle(fontFamily: 'Pangram')),
//               ),
//               PopupMenuItem(
//                 value: 'worst',
//                 child: Text('Worst First', style: TextStyle(fontFamily: 'Pangram')),
//               ),
//             ],
//           ),
//         ],
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Color(0xBACFFF).withOpacity(0.67),
//               Color(0xFFFFCEB7),
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance
//               .collection('mood_entries')
//               .where('userId', isEqualTo: userId)
//               .snapshots(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(child: CircularProgressIndicator());
//             }
//             if (snapshot.hasError) {
//               return Center(
//                 child: Text(
//                   'An error occurred: ${snapshot.error}',
//                   style: TextStyle(
//                     fontFamily: 'Pangram',
//                     fontSize: 16,
//                     color: Colors.red,
//                   ),
//                 ),
//               );
//             }
//             if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//               return Center(
//                 child: Text(
//                   'No mood entries found.',
//                   style: TextStyle(
//                     fontFamily: 'Pangram',
//                     fontSize: 16,
//                     color: Colors.grey,
//                   ),
//                 ),
//               );
//             }
//
//             var moodEntries = snapshot.data!.docs;
//
//             // Sort the entries based on the selected sorting option
//             if (_sortingOption == 'newest') {
//               moodEntries.sort((a, b) => (b['timestamp'] as Timestamp)
//                   .compareTo(a['timestamp'] as Timestamp));
//             } else if (_sortingOption == 'oldest') {
//               moodEntries.sort((a, b) => (a['timestamp'] as Timestamp)
//                   .compareTo(b['timestamp'] as Timestamp));
//             } else if (_sortingOption == 'best') {
//               moodEntries.sort((a, b) => moodToValue(b['mood']).compareTo(moodToValue(a['mood'])));
//             } else if (_sortingOption == 'worst') {
//               moodEntries.sort((a, b) => moodToValue(a['mood']).compareTo(moodToValue(b['mood'])));
//             }
//
//             return ListView.builder(
//               padding: EdgeInsets.all(16.0),
//               itemCount: moodEntries.length,
//               itemBuilder: (context, index) {
//                 final entry = moodEntries[index];
//
//                 // Find the matching mood or default to Neutral
//                 final emojiItem = moods.firstWhere(
//                       (moodItem) => moodItem.title.toLowerCase() == (entry['mood']?.toLowerCase() ?? 'neutral'),
//                   orElse: () => EmojiItem(imagePath: 'lib/assets/neutral-face.png', title: 'Neutral'),
//                 );
//
//                 return HistoryTile(
//                   mood: entry['mood'] ?? 'No mood',
//                   emoji: Image.asset(
//                     emojiItem.imagePath, // Use the image path for the Image.asset widget
//                     width: 32.0, // Set the desired emoji size
//                     height: 32.0,
//                     fit: BoxFit.contain,
//                   ),
//                   timestamp: DateFormat('dd/MM/yyyy hh:mm a').format((entry['timestamp'] as Timestamp).toDate()),
//                   feelings: entry['emotions']?.join(', ') ?? 'No emotions',
//                   reason: entry['reasons']?.join(', ') ?? 'No reason',
//                   note: entry['notes'] ?? 'No note',
//                   entryId: entry.id, // Pass the document ID for deletion/edit
//                 );
//               },
//             );
//           },
//         ),
//       ),
//       bottomNavigationBar: BottomNavBar(currentIndex: 3),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Models/emoji_item.dart';
import '../../Utils/emoji_data.dart';
import '../../Widgets/bottom_nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'edit_mood_screen.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String _sortingOption = 'newest'; // Default sorting option

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
        return 3; // Default to neutral if mood is unrecognized
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the current user's ID
    final currentUser = FirebaseAuth.instance.currentUser;

    // Check if the user is logged in
    if (currentUser == null) {
      return Center(
        child: Text(
          'You are not logged in. Please sign in to view your mood history.',
          style: TextStyle(fontFamily: 'Pangram', fontSize: 16),
        ),
      );
    }

    final userId = currentUser.uid;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xBACFFF).withOpacity(0.67),
              Color(0xFFFFCEB7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            // History text and filter button
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 60.0, 16.0, 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'History',
                    style: TextStyle(
                      fontFamily: 'Pangram',
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF100F11),
                      fontSize: 20.0,
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(Icons.sort, color: Color(0xFF100F11)),
                    onSelected: (value) {
                      setState(() {
                        _sortingOption = value;
                      });
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'newest',
                        child: Text('Newest First', style: TextStyle(fontFamily: 'Pangram')),
                      ),
                      PopupMenuItem(
                        value: 'oldest',
                        child: Text('Oldest First', style: TextStyle(fontFamily: 'Pangram')),
                      ),
                      PopupMenuItem(
                        value: 'best',
                        child: Text('Best First', style: TextStyle(fontFamily: 'Pangram')),
                      ),
                      PopupMenuItem(
                        value: 'worst',
                        child: Text('Worst First', style: TextStyle(fontFamily: 'Pangram')),
                      ),
                    ],
                  ),
                ],
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
                        style: TextStyle(
                          fontFamily: 'Pangram',
                          fontSize: 16,
                          color: Colors.red,
                        ),
                      ),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        'No mood entries found.',
                        style: TextStyle(
                          fontFamily: 'Pangram',
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }

                  var moodEntries = snapshot.data!.docs;

                  // Sort the entries based on the selected sorting option
                  if (_sortingOption == 'newest') {
                    moodEntries.sort((a, b) => (b['timestamp'] as Timestamp)
                        .compareTo(a['timestamp'] as Timestamp));
                  } else if (_sortingOption == 'oldest') {
                    moodEntries.sort((a, b) => (a['timestamp'] as Timestamp)
                        .compareTo(b['timestamp'] as Timestamp));
                  } else if (_sortingOption == 'best') {
                    moodEntries.sort((a, b) => moodToValue(b['mood']).compareTo(moodToValue(a['mood'])));
                  } else if (_sortingOption == 'worst') {
                    moodEntries.sort((a, b) => moodToValue(a['mood']).compareTo(moodToValue(b['mood'])));
                  }

                  return ListView.builder(
                    padding: EdgeInsets.all(16.0),
                    itemCount: moodEntries.length,
                    itemBuilder: (context, index) {
                      final entry = moodEntries[index];

                      // Find the matching mood or default to Neutral
                      final emojiItem = moods.firstWhere(
                            (moodItem) => moodItem.title.toLowerCase() == (entry['mood']?.toLowerCase() ?? 'neutral'),
                        orElse: () => EmojiItem(imagePath: 'assets/neutral-face.png', title: 'Neutral'),
                      );

                      return HistoryTile(
                        mood: entry['mood'] ?? 'No mood',
                        emoji: Image.asset(
                          emojiItem.imagePath, // Use the image path for the Image.asset widget
                          width: 32.0, // Set the desired emoji size
                          height: 32.0,
                          fit: BoxFit.contain,
                        ),
                        timestamp: DateFormat('dd/MM/yyyy hh:mm a').format((entry['timestamp'] as Timestamp).toDate()),
                        feelings: entry['emotions']?.join(', ') ?? 'No emotions',
                        reason: entry['reasons']?.join(', ') ?? 'No reason',
                        note: entry['notes'] ?? 'No note',
                        entryId: entry.id, // Pass the document ID for deletion/edit
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
  final Widget emoji; // Accept emoji as a Widget instead of String

  HistoryTile({
    required this.mood,
    required this.emoji, // Updated type
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

  // Method to delete the entry from Firestore
  void _deleteEntry() async {
    try {
      await FirebaseFirestore.instance.collection('mood_entries').doc(widget.entryId).delete();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error deleting entry: $e'), backgroundColor: Color(0xFF8B4CFC),));
    }
  }

  // Method to edit the entry (placeholder, implement functionality later)
  void _editEntry() async {
    try {
      // Fetch the mood entry from Firestore
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection('mood_entries')
          .doc(widget.entryId)
          .get();

      // Check if the document exists
      if (document.exists) {
        // Navigate to the EditMoodScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditMoodScreen(moodEntryDoc: document),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Mood entry not found'), backgroundColor: Color(0xFF8B4CFC),),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching entry: $e'), backgroundColor: Color(0xFF8B4CFC),),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String displayedNote = widget.note.length > 40
        ? widget.note.substring(0, 40) // Display first 40 characters
        : widget.note; // If note is less than or equal to 40 characters, display full note

    bool showReadMore = widget.note.length > 40; // Only show Read more if note > 40 characters

    if (_isNoteExpanded && widget.note.length > 40) {
      displayedNote = widget.note; // Show the full note if expanded
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              widget.emoji, // Display the emoji image
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.mood,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Pangram'),
                  ),
                  SizedBox(height: 4),
                  Text(
                    widget.timestamp,
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontFamily: 'Pangram'),
                  ),
                ],
              ),
              Spacer(),
              Column(
                children: [
                  Row(
                    children: [
                      TextButton(
                        onPressed: _deleteEntry,
                        child: Text(
                          'Delete',
                          style: TextStyle(color: Colors.red, fontFamily: 'Pangram'),
                        ),
                      ),
                      Container(
                        width: 1.0,
                        height: 24.0,
                        color: Colors.grey.withOpacity(0.5),
                      ),
                      TextButton(
                        onPressed: _editEntry,
                        child: Text('Edit', style: TextStyle(fontFamily: 'Pangram')),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'You felt ${widget.feelings}\nBecause of ${widget.reason}',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500, fontFamily: 'Pangram'),
          ),
          SizedBox(height: 8),
          Text(
            'Note: $displayedNote',
            style: TextStyle(
                fontSize: 14, color: Colors.grey, fontFamily: 'Pangram'),
          ),
          if (showReadMore) // Only show Read more if note length > 40
            TextButton(
              onPressed: () {
                setState(() {
                  _isNoteExpanded = !_isNoteExpanded;
                });
              },
              child: Text(_isNoteExpanded ? '- Read less' : '+ Read more',
                  style: TextStyle(fontFamily: 'Pangram')),
            ),
        ],
      ),
    );
  }
}
