import 'package:flutter/material.dart';
import 'package:flutter_application/format_stuff/miniPageAnat.dart';

class ChestPage extends StatelessWidget {
  final List<String> titles = [
    'Inclined Bench Press',
    'Bench Press',
    'Decline Bench Press',
    'Pec Fly Machine',
  ];

  final List<String> imagePaths = [
    'assets/images/chest/inclinedBp.jpeg',
    'assets/images/chest/declineBp.png',
    'assets/images/chest/declineBp.png',
    'assets/images/chest/pecFly.jpeg',
  ];

  final List<String> miniPageTexts = [
    '1) Lie down on a bench inclined at a 30°-45° \n2) Lift the bar off the rack using a medium overhand grip \n3) Tighten your lats and gradually lower the weight until it touches your chest \n4) Push the bar back up \n5) Perform 4 sets of 8 reps, with a 2min break between each set.',
    '1) Lie down on a flat bench \n2) Lift the bar off the rack using a medium overhand grip \n3) Tighten your lats and gradually lower the weight until it touches your chest \n4) Push the bar back up \n5) Perform 4 sets of 8 reps, with a 2min break between each set.',
    '1) Lie down on a bench declined at a 15°-30°. Secure your feet at the end of the bench \n2) Lift the bar off the rack using a medium overhand grip \n3) Tighten your lats and gradually lower the weight until it touches your chest \n4) Push the bar back up \n5) Perform 4 sets of 8 reps, with a 2min break between each set.',
    '1) Adjust the seat height so that the handles are at chest level \n2) Sit down and grasp the handles \n3) Squeeze your chest and bring the handles together \n4) Slowly return to the starting position \n5) Perform 4 sets of 10 reps, with a 2min break between each set.', 
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

