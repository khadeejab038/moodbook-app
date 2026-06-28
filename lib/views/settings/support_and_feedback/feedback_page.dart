import 'package:flutter/material.dart';
import '../../widgets/responsive_extension.dart';

class FeedbackPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Feedback',
          style: TextStyle(
            fontFamily: 'Pangram',
            fontSize: context.w(6),
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF8E3D9).withOpacity(0.7), // Light Pink
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(context.w(4)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              // Title
              Text(
                'We value your feedback!',
                style: TextStyle(
                  fontFamily: 'Pangram',
                  fontSize: context.w(5),
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: context.h(2.5)),

              // Feedback text area
              Text(
                'Please provide your feedback below:',
                style: TextStyle(
                  fontFamily: 'Pangram',
                  fontSize: context.w(4),
                  color: Colors.black,
                ),
              ),
              SizedBox(height: context.h(1.2)),
              TextField(
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Enter your feedback...',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontFamily: 'Pangram',
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(context.w(3)),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.all(context.w(4)),
                ),
              ),
              SizedBox(height: context.h(2.5)),

              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle the feedback submission
                    // Implement your submit logic here
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Color(0xFF8B4CFC), // Your chosen gradient color
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(context.w(6.25)),
                      ),
                    ),
                    padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(horizontal: context.w(10), vertical: context.h(1.5)),
                    ),
                  ),
                  child: Text(
                    'Submit Feedback',
                    style: TextStyle(
                      fontFamily: 'Pangram',
                      fontSize: context.w(4),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}
