import 'package:flutter/material.dart';

import 'modal4.dart';

class ReasonSelection extends StatefulWidget {
  const ReasonSelection({super.key});

  @override
  State<ReasonSelection> createState() => _ReasonSelectionState();
}

class _ReasonSelectionState extends State<ReasonSelection> {
  final List<String> allReasons = [
    "Work", "Hobbies", "Family", "Breakup", "Weather", "Wife",
    "Party", "Love", "Self esteem", "Sleep", "Social", "Food",
    "Distant", "Content", "Exams"
  ];

  final List<String> recentlyUsed = ["Family", "Self esteem", "Sleep", "Social"];

  Set<String> selectedReasons = {};
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredReasons = allReasons
        .where((reason) => reason.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      body: Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20,),

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
                    onPressed: () => Navigator.pop(context),
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

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Search & add reasons",
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

            // Selected Reasons and Clear All Button
            if (selectedReasons.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Selected (${selectedReasons.length})",
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedReasons.clear();
                        });
                      },
                      child: const Text(
                        "Clear all",
                        style: TextStyle(color: Colors.blue, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),

            if (selectedReasons.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Wrap(
                  spacing: 10,
                  children: selectedReasons.map((reason) {
                    return Chip(
                      label: Text(reason),
                      onDeleted: () {
                        setState(() {
                          selectedReasons.remove(reason);
                        });
                      },
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
                children: recentlyUsed.map((reason) {
                  return _reasonChip(reason);
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
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: filteredReasons.map((reason) {
                      return _reasonChip(reason);
                    }).toList(),
                  ),
                ),
              ),
            ),

            // Bottom "Continue" Button
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF8B4CFC),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const modal4(),
                      ),
                    );
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
  Widget _reasonChip(String reason) {
    final isSelected = selectedReasons.contains(reason);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedReasons.remove(reason);
          } else {
            selectedReasons.add(reason);
          }
        });
      },
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color:  Colors.grey,
            width: 1.5,
          ),

          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        onPressed: () {
          setState(() {
            if (isSelected) {
              selectedReasons.remove(reason);
            } else {
              selectedReasons.add(reason);
            }
          });
        },
        child: Text(
          reason,
          style: TextStyle(
            color: isSelected ? Colors.purple : Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

}
