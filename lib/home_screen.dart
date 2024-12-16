import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasebackend/snack_bar_helper.dart';
import 'package:flutter/material.dart';

import 'modal2.dart';
import 'signin_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true, // Allows the modal to define its height
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(50)),),
                  builder: (BuildContext context) {
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

                      height: MediaQuery.of(context).size.height * 0.9,
                      width: double.infinity,
                      padding: const EdgeInsets.only( top: 20.0),

                      child: Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(width: 20,),
                              ElevatedButton(
                                onPressed: () {
                                  //calendar top left area!!!
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0), // Adjust radius as needed
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                                ),
                                child: Row(
                                  children: [
                                    Text('Sun, 4 Jun'),
                                    SizedBox(width: 10),
                                    Icon(Icons.calendar_month_outlined),],),
                              ),

                              SizedBox(width: 40,),

                              Text("1/4"),

                              SizedBox(width: 80,),

                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context); // Close the modal sheet
                                },
                                child: const Icon(Icons.close, color: Colors.black,),
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(6.0),
                                ),
                              ),

                            ],
                          ),

                          SizedBox(height: 30),

                          Text("Whats your mood right now?", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                          SizedBox(height: 30),

                          SizedBox(width: 280,
                            child: Text("Select mood that reflects the most how you are feeling at this moment.",
                                style: TextStyle(fontSize: 16, ),
                                textAlign: TextAlign.center),
                          ),

                          SizedBox(height: 180),

                          SizedBox(
                            width: double.infinity,
                            height: 100,
                            child: Stack(
                              children: [
                                Image.asset('lib/assets/emojibar-def.png'),
                                // Positioned(
                                //   left:165,
                                //   child: IconButton(onPressed: (){}, icon: Image.asset('lib/assets/halo.png', height: 60,)),
                                // )
                              ],
                            ),
                          ),

                          SizedBox(height: 200),

                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF8B4CFC),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40),),
                              padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                              minimumSize: const Size(350, 20),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const TwoByFour(),
                                ),
                              );

                              // Navigator.pop(context); // Close the current modal
                              // showModalBottomSheet(
                              //   context: context,
                              //   isScrollControlled: true,
                              //   shape: const RoundedRectangleBorder(
                              //     borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                              //   ),
                              //   builder: (BuildContext context) {
                              //     return TwoByFour();
                              //   },
                              // );
                            },
                            child: const Text(
                              'Continue',
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Text('Show Modal Bottom Sheet'),
            ),
          ],
        ),
      ),
    );
  }
}
