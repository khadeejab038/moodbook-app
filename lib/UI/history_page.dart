import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Models/emoji_item.dart';
import '../Utils/emoji_data.dart';
import '../Widgets/bottom_nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HistoryPage extends StatelessWidget {
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'History',
              style: TextStyle(
                fontFamily: 'Pangram',
                fontWeight: FontWeight.bold,
                color: Color(0xFF100F11),
                fontSize: 20.0,
              ),
            ),
          ),
        ),
        iconTheme: IconThemeData(color: Color(0xFF100F11)),
      ),
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

            final moodEntries = snapshot.data!.docs;

            return ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: moodEntries.length,
              itemBuilder: (context, index) {
                final entry = moodEntries[index];

                // Find the matching mood or default to Neutral
                final emojiItem = moods.firstWhere(
                      (moodItem) => moodItem.title.toLowerCase() == (entry['mood']?.toLowerCase() ?? 'neutral'),
                  orElse: () => EmojiItem(imagePath: 'lib/assets/neutral-face.png', title: 'Neutral'),
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error deleting entry: $e')));
    }
  }

  // Method to edit the entry (placeholder, implement functionality later)
  void _editEntry() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Edit feature is under development')));
  }

  @override
  Widget build(BuildContext context) {
    String displayedNote = widget.note.length > 20
        ? widget.note.substring(0, 20) // Display first 20 characters
        : widget.note; // If note is less than or equal to 20 characters, display full note

    bool showReadMore = widget.note.length > 20; // Only show Read more if note > 20 characters

    if (_isNoteExpanded && widget.note.length > 20) {
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
          if (showReadMore) // Only show Read more if note length > 20
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

