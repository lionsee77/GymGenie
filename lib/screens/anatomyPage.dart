import 'package:flutter/material.dart';
import 'package:flutter_application/bodyparts_stuff/forearmPage.dart';
import 'package:flutter_application/format_stuff/constants.dart';
import 'package:flutter_application/bodyparts_stuff/allParts.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AnatomyPage extends StatefulWidget {
  @override
  _AnatomyPageState createState() => _AnatomyPageState();
}

class _AnatomyPageState extends State<AnatomyPage> {
  bool isFrontView = true;

  void _navigateTo(BuildContext context, String page) {
    final routes = {
      "bicep": BicepPage(),
      "shoulder": ShoulderPage(),
      "chest": ChestPage(),
      "core": CorePage(),
      "tricep": TricepPage(),
      "back": BackPage(),
      "legs": LegsPage(),
      "forearm" : ForearmPage(),
    };
    if (routes.containsKey(page)) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => routes[page]!),
      );
    }
  }

  void _toggleView() {
    setState(() {
      isFrontView = !isFrontView;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Center(
          child: Container(
            width: 180,
            height: 45,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: isFrontView ? Colors.white : Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: isFrontView ? null : _toggleView,
                    child: Text('Front', style: TextStyle(color: Colors.black)),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: isFrontView ? Colors.transparent : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: isFrontView ? _toggleView : null,
                    child: Text('Back', style: TextStyle(color: Colors.black)),
                  ),
                ),
              ],
            ),
          ),
        ),
        centerTitle: false,
      ),
      body: Center(
        child: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: SvgPicture.asset(
                isFrontView ? 'assets/images/anatPage/body-front.svg' : 'assets/images/anatPage/body-back.svg',
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height / 2 - 290,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 37,
                            height: 50,
                            margin: EdgeInsets.only(top: 0, left: 25, right: 3, bottom: 5),
                            child: ElevatedButton(
                              onPressed: () => _navigateTo(context, "shoulder"),
                              style: bodyButtonStyle,
                              child: Text('LS', style: TextStyle(color: Colors.transparent)),
                            ),
                          ),
                          Container(
                            width: 37,
                            height: 60,
                            margin: EdgeInsets.only(top: 10, left: 25, right: 3, bottom: 5),
                            child: ElevatedButton(
                              onPressed: () => _navigateTo(context, isFrontView ? "bicep" : "tricep"),
                              style: bodyButtonStyle,
                              child: Text('LBicep', style: TextStyle(color: Colors.transparent)),
                            ),
                          ),
                          Container(
                            width: 40,
                            height: 90,
                            margin: EdgeInsets.only(top: 10, left: 25, right: 3, bottom: 270),
                            child: ElevatedButton(
                              onPressed: () => _navigateTo(context, "forearm"),
                              style: bodyButtonStyle,
                              child: Text('Lforearm', style: TextStyle(color: Colors.transparent)),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            width: 110,
                            height: 60,
                            margin: EdgeInsets.only(top: 0, left: 5, right: 5, bottom: 10),
                            child: ElevatedButton(
                              onPressed: () => _navigateTo(context, isFrontView ? "chest" : "back"),
                              style: bodyButtonStyle,
                              child: Text('Chest', style: TextStyle(color: Colors.transparent)),
                            ),
                          ),
                          Container(
                            width: 110,
                            height: 120,
                            margin: EdgeInsets.only(top: 0, left: 5, right: 5, bottom: 5),
                            child: ElevatedButton(
                              onPressed: () => _navigateTo(context, isFrontView ? "core" : "back"),
                              style: bodyButtonStyle,
                              child: Text('Core', style: TextStyle(color: Colors.transparent)),
                            ),
                          ),
                          Container(
                            width: 120,
                            height: 200,
                            margin: EdgeInsets.only(top: 0, left: 1, right: 5, bottom: 5),
                            child: ElevatedButton(
                              onPressed: () => _navigateTo(context, "legs"),
                              style: bodyButtonStyle,
                              child: Text('Legs', style: TextStyle(color: Colors.transparent)),
                            ),
                          ),
                          Container(
                            width: 120,
                            height: 100,
                            margin: EdgeInsets.only(top: 5, left: 1, right: 5, bottom: 0),
                            child: ElevatedButton(
                              onPressed: () => _navigateTo(context, "legs"), // New navigation
                              style: bodyButtonStyle,
                              child: Text('Legs', style: TextStyle(color: Colors.transparent)),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            width: 40,
                            height: 50,
                            margin: EdgeInsets.only(top: 0, left: 2, right: 15, bottom: 5),
                            child: ElevatedButton(
                              onPressed: () => _navigateTo(context, "shoulder"),
                              style: bodyButtonStyle,
                              child: Text('RS', style: TextStyle(color: Colors.transparent)),
                            ),
                          ),
                          Container(
                            width: 40,
                            height: 60,
                            margin: EdgeInsets.only(top: 10, left: 2, right: 15, bottom: 5),
                            child: ElevatedButton(
                              onPressed: () => _navigateTo(context, isFrontView ? "bicep" : "tricep"),
                              style: bodyButtonStyle,
                              child: Text('RBicep', style: TextStyle(color: Colors.transparent)),
                            ),
                          ),
                          Container(
                            width: 40,
                            height: 100,
                            margin: EdgeInsets.only(top: 10, left: 2, right: 15, bottom: 270),
                            child: ElevatedButton(
                              onPressed: () => _navigateTo(context, "forearm"), // New navigation
                              style: bodyButtonStyle,
                              child: Text('Rforearm', style: TextStyle(color: Colors.transparent)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}






