import 'package:flutter/material.dart';
import 'package:flutter_application/format_stuff/miniPageAnat.dart';

class LegsPage extends StatelessWidget {
  final List<String> titles = [
    'Squats',
    'Leg Press',
  ];

  final List<String> imagePaths = [
    'assets/images/legs/squat.jpg',
    'assets/images/legs/legPress.png',
  ];

  final List<String> miniPageTexts = [
    '1) Stand with your feet shoulder-width apart and your toes pointed slightly outward \n2) Bend your knees and hips to lower your body into a squat position \n3) Keep your chest up and your back straight as you lower down \n4) Push through your heels to return to the starting position \n5) Perform 4 sets of 12 reps, with a 2min break between each set.',
    '1) Sit down on the leg press machine and place your feet shoulder-width apart on the platform \n2) Lower the safety bars and press the platform up until your legs are fully extended but not locked \n3) Slowly lower the platform by bending your knees until your legs form a 90-degree angle \n4) Push the platform back up to the starting position \n5) Perform 4 sets of 10 reps, with a 2min break between each set.',
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