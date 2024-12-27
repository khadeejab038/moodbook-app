import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Widgets/bottom_nav_bar.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Prevent back button
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
        child: ListView.builder(
          padding: EdgeInsets.all(16.0),
          itemCount: 10,
          itemBuilder: (context, index) {
            return _buildHistoryTile(context, index);
          },
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 3),
    );
  }

  Widget _buildHistoryTile(BuildContext context, int index) {
    final mood = index % 2 == 0 ? 'Terrible' : 'Bad';
    final emoji = index % 2 == 0 ? '😡' : '😔';
    final timestamp = DateTime.now().subtract(Duration(hours: index + 1));
    final formattedTime =
    DateFormat('hh:mm a').format(timestamp); // 12-hour format
    final feelings = index % 2 == 0 ? 'Disappointed, Confused' : 'Guilty, Sad';
    final reason = index % 2 == 0 ? 'Work' : 'Relationships';
    final note = index % 2 == 0
        ? 'The day didn’t go well in the morning...'
        : 'Feeling so sad now because...';

    return HistoryTile(
      mood: mood,
      emoji: emoji,
      timestamp: formattedTime,
      feelings: feelings,
      reason: reason,
      note: note,
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

  HistoryTile({
    required this.mood,
    required this.emoji,
    required this.timestamp,
    required this.feelings,
    required this.reason,
    required this.note,
  });

  @override
  _HistoryTileState createState() => _HistoryTileState();
}

class _HistoryTileState extends State<HistoryTile> {
  bool _isNoteExpanded = false;

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
                        onPressed: () {
                          // Implement delete action
                        },
                        child: Text(
                          'Delete',
                          style:
                          TextStyle(color: Colors.red, fontFamily: 'Pangram'),
                        ),
                      ),
                      Container(
                        width: 1.0,
                        height: 24.0,
                        color: Colors.grey.withOpacity(0.5),
                      ),
                      TextButton(
                        onPressed: () {
                          // Implement edit action
                        },
                        child: Text('Edit',
                            style: TextStyle(fontFamily: 'Pangram')),
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
