import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class StepsRadialChart extends StatelessWidget {
  final int steps;
  final int totalSteps;

  StepsRadialChart({required this.steps, required this.totalSteps});

  @override
  Widget build(BuildContext context) {
    double percent = (steps / totalSteps).clamp(0.0, 1.0);
    return CircularPercentIndicator(
      radius: 73.0,
      lineWidth: 10.0,
      percent: percent,
      center: Text(
        "$steps / $totalSteps",
        style: TextStyle(fontSize: 15.0),
      ),
      progressColor: Colors.blue,
      circularStrokeCap: CircularStrokeCap.round, //This rounds the ends of the progress indicator
    );
  }
}

