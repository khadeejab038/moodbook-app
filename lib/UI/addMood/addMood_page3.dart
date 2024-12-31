import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Providers/moodEntry_provider.dart';
import '../../Utils/reasons_data.dart';
import '../home/home_screen.dart';
import 'addMood_page4.dart';

class AddReasons extends StatefulWidget {
  const AddReasons({super.key});

  @override
  State<AddReasons> createState() => _AddReasonsState();
}

class _AddReasonsState extends State<AddReasons> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final moodProvider = Provider.of<MoodEntryProvider>(context); // Access the provider

    final filteredReasons = allReasons
        .where((reason) => reason.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: double.infinity,
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // Top Bar with Navigation
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Text(
                            "3/4",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
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

                    const SizedBox(height: 10),

                    // Main Title
                    const Center(
                      child: Text(
                        "What's reason making you feel\nthis way?",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Center(
                      child: Text(
                        "Select reasons that reflected your emotions",
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Search reasons",
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(color: Colors.grey, width: 1.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(color: Colors.grey, width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(color: Colors.blue, width: 1.5),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    if (moodProvider.selectedReasons.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Selected (${moodProvider.selectedReasons.length})",
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  moodProvider.clearSelectedReasons(); // Use the provider method
                                });
                              },
                              style: TextButton.styleFrom(
                                // backgroundColor: Colors.[300], // Add background color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20), // Make the button rounded
                                ),
                              ),
                              child: const Text(
                                "Clear all",
                                style: TextStyle(color: Colors.black, fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),

                    if (moodProvider.selectedReasons.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Wrap(
                          spacing: 10,
                          children: moodProvider.selectedReasons.map((reason) {
                            return Chip(
                              label: Text(reason),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20), // Rounded chip edges
                              ),
                              onDeleted: () {
                                setState(() {
                                  moodProvider.toggleReason(reason); // Remove reason using provider method
                                });
                              },
                              backgroundColor: Colors.grey[200], // Optional: Set background color
                              labelStyle: const TextStyle(color: Colors.black), // Text color for better contrast
                            );
                          }).toList(),
                        ),
                      ),


                    // Recently Used Section
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Recently used",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Wrap(
                        spacing: 10,
                        children: moodProvider.recentlyUsedReasons.map((reason) {
                          return _reasonChip(reason, moodProvider);
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // All Reasons Section
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "All reasons",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: filteredReasons.map((reason) {
                          return _reasonChip(reason, moodProvider);
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Floating "Continue" Button
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B4CFC),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
                    minimumSize: const Size(350, 10),
                  ),
                  onPressed: () {
                    if (moodProvider.selectedReasons.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select at least one reason before continuing.'),
                          backgroundColor: Colors.red,
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
                  child: const Text(
                    "Continue",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Custom Chip Widget
  Widget _reasonChip(String reason, MoodEntryProvider moodProvider) {
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
          ),
        ),
        backgroundColor: isSelected ? Colors.purple[200] : Colors.grey[300],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Softens the edges
          side: BorderSide.none, // Removes any outline
        ),
      ),
    );
  }

}
