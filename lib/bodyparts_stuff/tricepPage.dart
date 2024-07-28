import 'package:flutter/material.dart';
import 'package:flutter_application/format_stuff/miniPageAnat.dart';

class TricepPage extends StatelessWidget {
  final List<String> titles = [
    'Tricep Extension',
    'Overhead Curls',
  ];

  final List<String> imagePaths = [
    'assets/images/arms/tricepExtension.webp',
    'assets/images/arms/overHead.webp',
  ];

  final List<String> miniPageTexts = [
    '1) Stand with your feet shoulder-width apart \n2) Hold a dumbbell or barbell with both hands and lift it overhead \n3) Keep your upper arms close to your head and elbows in \n4) Lower the weight behind your head by bending your elbows \n5) Extend your arms to return to the starting position \n6) Perform 4 sets of 12 reps, with a 2min break between each set.',
    '1) Sit on a bench and hold a dumbbell in each hand \n2) Extend your arms overhead with your palms facing forward \n3) Lower the weights behind your head by bending your elbows \n4) Extend your arms to return to the starting position \n5) Perform 4 sets of 12 reps, with a 2min break between each set.',
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
