import 'package:flutter/material.dart';
import 'package:flutter_application/format_stuff/miniPageAnat.dart';

class CorePage extends StatelessWidget {
  final List<String> titles = [
    'Sit Ups',
    'Leg Raises',
    'Flutter Kicks',
  ];

  final List<String> imagePaths = [
    'assets/images/abs/situp.png',
    'assets/images/abs/legRaise.png',
    'assets/images/abs/flutterKick.png',
  ];

  final List<String> miniPageTexts = [
    '1) Lie down on your back with your knees bent and feet flat on the floor \n2) Place your hands behind your head or cross them over your chest \n3) Tighten your core and lift your upper body towards your knees \n4) Slowly lower back to the starting position \n5) Perform 3 sets of 15 reps, with a 1min break between each set.',
    '1) Lie down on your back with your legs straight and your hands placed under your glutes for support \n2) Keeping your legs straight, lift them until they are perpendicular to the floor \n3) Slowly lower them back to the starting position without touching the floor \n4) Perform 3 sets of 15 reps, with a 1min break between each set.',
    '1) Lie down on your back with your legs straight and your hands placed under your glutes for support \n2) Lift your legs slightly off the ground and keep them straight \n3) Quickly alternate kicking your legs up and down in a fluttering motion \n4) Perform 3 sets of 30 seconds, with a 1min break between each set.',
  ];

  Widget _buildBox(BuildContext context, int index) {
    String boxText = titles[index];
    String imagePath = imagePaths[index];

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return MiniPageDialog(
              boxText: boxText,
              miniPageText: miniPageTexts[index],
              imagePath: imagePath,
            ); 
          },
        );
      },
      child: Container(
        height: 100,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white, 
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: Row(
          children: [
            SizedBox(width: 10),
            Image.asset(
              imagePath,
              width: 30, 
              height: 30, 
            ),
            SizedBox(width: 10),
            Expanded(
              child: Center(
                child: Text(
                  boxText,
                  style: TextStyle(fontSize: 20, color: Colors.black), 
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      body: ListView.builder(
        itemCount: titles.length, 
        itemBuilder: (context, index) {
          return _buildBox(context, index);
        },
      ),
    );
  }
}
