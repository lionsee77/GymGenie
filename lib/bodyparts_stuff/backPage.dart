import 'package:flutter/material.dart';
import 'package:flutter_application/format_stuff/miniPageAnat.dart';

class BackPage extends StatelessWidget {
  final List<String> titles = [
    'Lat Pulldown',
    'Seated Rows',
  ];

  final List<String> imagePaths = [
    'assets/images/back/pullDown.jpeg',
    'assets/images/back/seatedRow.png',
  ];

  final List<String> miniPageTexts = [
    '1) Sit down at a lat pulldown machine and grasp the bar with a wide overhand grip \n2) Lean back slightly and pull the bar down towards your chest \n3) Squeeze your shoulder blades together at the bottom of the movement \n4) Slowly return the bar to the starting position \n5) Perform 4 sets of 12 reps, with a 2min break between each set.',
    '1) Sit on the seat of a seated row machine and grasp the handles \n2) Keep your back straight and pull the handles towards your torso \n3) Squeeze your shoulder blades together at the end of the movement \n4) Slowly return the handles to the starting position \n5) Perform 4 sets of 12 reps, with a 2min break between each set.',
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