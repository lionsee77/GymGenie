import 'package:flutter/material.dart';
import 'package:flutter_application/format_stuff/miniPageAnat.dart';

class ForearmPage extends StatelessWidget {
  final List<String> titles = [
    'Wrist Curls',
    'Reverse Curls',
  ];

  final List<String> imagePaths = [
    'assets/images/arms/wristCurl.jpeg',
    'assets/images/arms/reverseCurl.jpg',
  ];

  final List<String> miniPageTexts = [
    '1) Sit on a bench and hold a dumbbell in each hand \n2) Rest your forearms on your thighs with your wrists hanging over the edge \n3) Let the dumbbells roll down to your fingers, then curl them back up \n4) Perform 4 sets of 12 reps, with a 2min break between each set.',
    '1) Stand with your feet shoulder-width apart \n2) Hold a barbell with an overhand grip, palms facing down \n3) Curl the barbell towards your shoulders, keeping your elbows close to your body \n4) Lower the barbell back to the starting position \n5) Perform 4 sets of 12 reps, with a 2min break between each set.',
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
