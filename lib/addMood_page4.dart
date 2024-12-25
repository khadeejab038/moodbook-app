import 'package:firebasebackend/home_screen.dart';
import 'package:flutter/material.dart';


class AddNotes extends StatefulWidget {
  const AddNotes({super.key});

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  TextEditingController notesController = TextEditingController();

  void showPopupDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left:20.0),
                  child: Image.asset('lib/assets/goodtogo.png'),
                ),

                const Text(
                  "You're on a good way!\nYour day is going \n amazing",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Keep tracking your mood to know how to improve your mental health.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF8B4CFC),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    minimumSize: const Size(200, 50),
                  ),
                  onPressed: () {
                    //Navigator.pop(context); // Close the popup
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                  child: const Text(
                    'Got it',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
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
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Text("4/4", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                            (route) => false,
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "Any thing you want to add",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 20),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.0),
                child: Text(
                  "Add your notes on any thought that relates to your mood",
                  style: TextStyle(fontSize: 14, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 20),


              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 40,
                      )
                    ],
                  ),
                  child: TextField(
                    controller: notesController,
                    maxLines: 15,
                    decoration: InputDecoration(
                      hintText: "Write your notes here",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),


              const Spacer(),

              Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF8B4CFC),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      minimumSize: const Size(350, 50),
                    ),
                    onPressed: showPopupDialog,
                    child: const Text(
                      'Save',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 5),

                  TextButton(
                    onPressed: showPopupDialog,
                    child: const Text(
                      'Skip and Save',
                      style: TextStyle(fontSize: 16, color: Color(0xFF8B4CFC)),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
