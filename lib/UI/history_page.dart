import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Widgets/bottom_nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
                return HistoryTile(
                  mood: entry['mood'] ?? 'No mood',
                  emoji: '😊', // Default neutral emoji as placeholder
                  // Check if the timestamp is a Firestore Timestamp and convert it
                  timestamp: DateFormat('hh:mm a').format((entry['timestamp'] as Timestamp).toDate()),
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
  final String emoji;
  final String timestamp;
  final String feelings;
  final String reason;
  final String note;
  final String entryId;

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

  // Method to delete the entry from Firestore
  void _deleteEntry() async {
    try {
      await FirebaseFirestore.instance.collection('mood_entries').doc(widget.entryId).delete();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Entry deleted')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error deleting entry: $e')));
    }
  }

  // Method to edit the entry (placeholder, implement functionality later)
  void _editEntry() {
    // Implement your edit functionality here
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Edit feature is under development')));
  }

  @override
  Widget build(BuildContext context) {
    String displayedNote =
    widget.note.split('\n')[0]; // Show only the first line initially
    if (_isNoteExpanded && widget.note.split('\n').length > 1) {
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
              Text(
                widget.emoji,
                style: TextStyle(fontSize: 32, fontFamily: 'Pangram'),
              ),
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
