import 'package:flutter/material.dart';
import 'addMood_page2.dart';

class AddMood extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        children: [
          SizedBox(height: 35),
          Row(
            children: [
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  // Calendar button action
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                ),
                child: Row(
                  children: [
                    Text('Sun, 4 Jun', style: TextStyle(fontFamily: 'Pangram')),
                    SizedBox(width: 10),
                    Icon(Icons.calendar_month_outlined),
                  ],
                ),
              ),
              SizedBox(width: 40),
              Text("1/4", style: TextStyle(fontFamily: 'Pangram')),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the modal sheet
                },
                child: const Icon(Icons.close, color: Colors.black),
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(6.0),
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
          Text(
            "What's your mood right now?",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Pangram'),
          ),
          SizedBox(height: 30),
          SizedBox(
            width: 280,
            child: Text(
              "Select mood that reflects the most how you are feeling at this moment.",
              style: TextStyle(fontSize: 16, fontFamily: 'Pangram'),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 180),
          SizedBox(
            width: double.infinity,
            height: 100,
            child: Stack(
              children: [
                Image.asset('lib/assets/emojibar-def.png'),
              ],
            ),
          ),
          SizedBox(height: 200),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF8B4CFC),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
              minimumSize: const Size(350, 20),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddEmotions(),
                ),
              );
            },
            child: Text("Continue", style: TextStyle(color: Colors.white, fontFamily: 'Pangram')),
          ),
        ],
      ),
    );
  }
}
