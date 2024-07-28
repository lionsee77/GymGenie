import 'dart:developer';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/screens/AnatomyPage.dart';
import 'package:flutter_application/screens/homePage.dart';
import 'package:flutter_application/screens/nutritionPage.dart';
import 'package:flutter_application/screens/repsPage.dart';
import 'package:flutter_application/screens/stepsPage.dart';

class MyLobbyPage extends StatefulWidget {
  final String personName;
  const MyLobbyPage({Key? key, required this.personName}) : super(key: key);

  @override
  State<MyLobbyPage> createState() => _MyLobbyPageState();
}

class _MyLobbyPageState extends State<MyLobbyPage> {
  /// Controller to handle PageView and also handles initial page
  /// 0 for home page 
  final _pageController = PageController(initialPage: 0);

  /// Controller to handle bottom nav bar and also handles initial page
  final NotchBottomBarController _controller = NotchBottomBarController(index: 0);

  int maxCount = 5;


  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// widget list
    final List<Widget> bottomBarPages = [
      HomePage(
        controller: (_controller),
        personName: widget.personName,
      ),
      RepsPage(controller: _controller, pageController: _pageController),
      NutritionPage(),
      AnatomyPage(),
      StepsPage(),
    ];
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(bottomBarPages.length, (index) => bottomBarPages[index]),
      ),
      extendBody: true,
      bottomNavigationBar: (bottomBarPages.length <= maxCount)
          ? AnimatedNotchBottomBar(
              notchBottomBarController: _controller,
              color: Colors.white70,
              showLabel: true,
              textOverflow: TextOverflow.visible,
              maxLine: 1,
              shadowElevation: 5,
              kBottomRadius: 28.0,
              notchColor: Colors.black87, //refers to the moving bubble

              removeMargins: false,
              bottomBarWidth: 500,
              showShadow: false,
              durationInMilliSeconds: 300,

              itemLabelStyle: const TextStyle(fontSize: 10),

              elevation: 1,
              bottomBarItems: const [
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.home_filled,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.home_filled,
                    color: Colors.blueAccent,
                  ),
                  itemLabel: 'Home',
                ),
                BottomBarItem(
                  inActiveItem: Icon(Icons.sports_gymnastics_outlined, color: Colors.blueGrey),
                  activeItem: Icon(
                    Icons.sports_gymnastics_outlined,
                    color: Colors.blueAccent,
                  ),
                  itemLabel: 'Workout',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.dinner_dining_rounded,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.dinner_dining_rounded,
                    color: Colors.blueAccent,
                  ),
                  itemLabel: 'Food',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.boy_rounded,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.boy_rounded,
                    color: Colors.blueAccent,
                  ),
                  itemLabel: 'Anatomy',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.nordic_walking,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.nordic_walking,
                    color: Colors.blueAccent,
                  ),
                  itemLabel: 'Steps',
                ),
              ],
              onTap: (index) {
                log('current selected index $index');
                _pageController.jumpToPage(index);
              },
              kIconSize: 24.0,
            )
          : null,
    );
  }
}
