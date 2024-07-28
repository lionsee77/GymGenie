import 'package:flutter/material.dart';
import 'package:flutter_application/format_stuff/miniPageAnat.dart';

class ShoulderPage extends StatelessWidget {
  final List<String> titles = [
    'Shoulder Press',
    'Lateral Raises',
    'Rear Delt Flies',
  ];

  final List<String> imagePaths = [
    'assets/images/shoulders/shoulderPress.jpg',
    'assets/images/shoulders/latRaises.jpg',
    'assets/images/shoulders/rearFly.jpg',
  ];

  final List<String> miniPageTexts = [
    '1) Sit on a bench with back support \n2) Hold a dumbbell in each hand at shoulder height with palms facing forward \n3) Push the dumbbells up until your arms are fully extended \n4) Slowly lower the weights back to the starting position \n5) Perform 4 sets of 10 reps, with a 2min break between each set.',
    '1) Stand with feet shoulder-width apart, holding a dumbbell in each hand \n2) With a slight bend in your elbows, lift the dumbbells out to the sides until they reach shoulder height \n3) Slowly lower the dumbbells back to the starting position \n4) Perform 4 sets of 12 reps, with a 2min break between each set.',
    '1) Hold a dumbbell in each hand with a slight bend in your knees \n2) Bend at the waist so your upper body is parallel to the floor \n3) With a slight bend in your elbows, lift the dumbbells out to the sides until your arms are in line with your body \n4) Slowly lower the weights back to the starting position \n5) Perform 4 sets of 12 reps, with a 2min break between each set.',
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
