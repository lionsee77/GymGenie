import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StepsLineChart extends StatefulWidget {
  final List<Map<String, dynamic>> stepsData;
  final double verticalInterval;

  const StepsLineChart({
    Key? key,
    required this.stepsData,
    this.verticalInterval = 1.0, 
  }) : super(key: key);

  @override
  _LineChartSample2State createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<StepsLineChart> {
  List<Color> gradientColors = [
    Colors.blue,
    Colors.purple,
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0), // Ensure equal padding on both sides
      child: LineChart(
        mainData(),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 15,
    );
    int index = value.toInt();
    if (index < 0 || index >= widget.stepsData.length) {
      return const Text('');
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(widget.stepsData[index]['day'], style: style),
    );
  }

  double getMaxSteps() {
    if (widget.stepsData.isEmpty) {
      return 10000; // Default value if no data is available
    }
    int maxSteps = widget.stepsData.map((data) => data['steps'] as int).reduce((a, b) => a > b ? a : b);
    return ((maxSteps / 1000).ceilToDouble()) * 1000; // Round up to the nearest thousand
  }

  LineChartData mainData() {
    List<FlSpot> spots = widget.stepsData.asMap().entries.map((entry) {
      int index = entry.key;
      int steps = entry.value['steps'];
      return FlSpot(index.toDouble(), steps.toDouble() / 1000);
    }).toList();

    double maxY = getMaxSteps() / 1000;

    return LineChartData(
      gridData: FlGridData(
        show: true,
        verticalInterval: widget.verticalInterval,
        drawVerticalLine: true,
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.grey,
            strokeWidth: 1,
            
          );
        },
        drawHorizontalLine: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
            interval: 1,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      minX: 0,
      maxX: widget.stepsData.length - 1,
      minY: 0,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
