import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/mood_entry_controller.dart';
import '../../models/reasons_data.dart';
import '../home/home_screen.dart';
import 'add_mood_screen4_notes.dart';
import '../widgets/responsive_extension.dart';

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

    final filteredReasons = allReasons
        .where((reason) => reason.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.4,
            colors: [
              Color(0xFFCCEFFF),
              Color(0xFFEFF9F2),
              Color(0xFFCFCFCF),
            ],
            stops: [0.3, 0.8, 1],
          ),
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
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        "3/4",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Pangram',
                          fontSize: context.w(4.5),
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.black),
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
                      // Centered & Harmonious texts
                      Text(
                        "What's the reason making you feel this way?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: context.w(6),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Pangram',
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: context.h(1.5)),
                      Text(
                        "Select reasons that reflected your emotions",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: context.w(3.75),
                          fontFamily: 'Pangram',
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: context.h(3)),

                      // Search Bar
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Search reasons",
                          hintStyle: const TextStyle(fontFamily: 'Pangram'),
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(context.w(6)),
                            borderSide: const BorderSide(color: Colors.grey, width: 1.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(context.w(6)),
                            borderSide: const BorderSide(color: Colors.grey, width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(context.w(6)),
                            borderSide: const BorderSide(color: Colors.blue, width: 1.5),
                          ),
                        ),
                      ),
                      SizedBox(height: context.h(3)),

                      // Selected reasons section
                      if (moodProvider.selectedReasons.isNotEmpty) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Selected (${moodProvider.selectedReasons.length})",
                              style: TextStyle(fontSize: context.w(4.5), fontWeight: FontWeight.bold, fontFamily: 'Pangram'),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  moodProvider.clearSelectedReasons();
                                });
                              },
                              child: Text(
                                "Clear all",
                                style: TextStyle(color: Colors.red, fontSize: context.w(3.75), fontFamily: 'Pangram', fontWeight: FontWeight.bold),
                              ),
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
                                label: Text(
                                  reason,
                                  style: const TextStyle(fontFamily: 'Pangram'),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(context.w(5)),
                                ),
                                onDeleted: () {
                                  setState(() {
                                    moodProvider.toggleReason(reason);
                                  });
                                },
                                backgroundColor: Colors.grey[200],
                                labelStyle: const TextStyle(color: Colors.black),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(height: context.h(2.5)),
                      ],

                      // Recently used section
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Recently used",
                          style: TextStyle(fontSize: context.w(4.5), fontWeight: FontWeight.bold, fontFamily: 'Pangram'),
                        ),
                      ),
                      SizedBox(height: context.h(1.5)),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          spacing: context.w(2.5),
                          runSpacing: context.h(0.5),
                          children: moodProvider.recentlyUsedReasons.map((reason) {
                            return _reasonChip(reason, moodProvider);
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: context.h(2.5)),

                      // All reasons section
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "All reasons",
                          style: TextStyle(fontSize: context.w(4.5), fontWeight: FontWeight.bold, fontFamily: 'Pangram'),
                        ),
                      ),
                      SizedBox(height: context.h(1.5)),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          spacing: context.w(2.5),
                          runSpacing: context.h(1.2),
                          children: filteredReasons.map((reason) {
                            return _reasonChip(reason, moodProvider);
                          }).toList(),
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
                    backgroundColor: const Color(0xFF8B4CFC),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(context.w(10)),
                    ),
                    minimumSize: Size(context.w(85), context.h(7.5)),
                  ),
                  onPressed: () {
                    if (moodProvider.selectedReasons.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select at least one reason before continuing.'),
                          backgroundColor: Color(0xFF8B4CFC),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddNotes(),
                        ),
                      );
                    }
                  },
                  child: Text(
                    "Continue",
                    style: TextStyle(fontSize: context.w(4), color: Colors.white, fontFamily: 'Pangram', fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _reasonChip(String reason, MoodEntryController moodProvider) {
    final isSelected = moodProvider.selectedReasons.contains(reason);
    return GestureDetector(
      onTap: () {
        setState(() {
          moodProvider.toggleReason(reason);
        });
      },
      child: Chip(
        label: Text(
          reason,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
            fontFamily: 'Pangram',
          ),
        ),
        backgroundColor: isSelected ? Colors.purple[200] : Colors.grey[300],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.w(5)),
          side: BorderSide.none,
        ),
      ),
    );
  }
}
