import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';

class NutritionPage extends StatelessWidget {
  final NotchBottomBarController? controller;

  const NutritionPage({Key? key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.green, child: const Center(child: Text('NUTRITUTION')));
  }
}