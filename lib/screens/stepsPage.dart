import 'package:flutter/material.dart';
import 'package:flutter_application/main.dart';
import 'package:flutter_application/widgets/healthKitService.dart';
import 'package:flutter_application/widgets/lineChart.dart';
import 'package:flutter_application/widgets/radialChart.dart';

class StepsPage extends StatefulWidget {
  const StepsPage({Key? key}) : super(key: key);

  @override
  _StepsPageState createState() => _StepsPageState();
}

class _StepsPageState extends State<StepsPage> {
  HealthKitService healthKitService = HealthKitService();
  int _todaySteps = 0;
  List<Map<String, dynamic>> _weeklySteps = [];
  int _dailyStepGoal = 10000;
  double _height = 0.0;
  double _weight = 0.0;
  double _caloriesBurned = 0.0;
  final TextEditingController _goalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchStepsData();
    _fetchUserInfo();
    _goalController.text = _dailyStepGoal.toString();
  }

  void _fetchStepsData() async {
    int todaySteps = await healthKitService.getTodaySteps();
    List<Map<String, dynamic>> weeklySteps = await healthKitService.getStepsForWeek();

    setState(() {
      _todaySteps = todaySteps;
      _weeklySteps = weeklySteps;
      _caloriesBurned = _calculateCaloriesBurned(todaySteps, _height, _weight);
    });
  }

  Future<void> _fetchUserInfo() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId != null) {
      final responses = await supabase
          .from('profilesinformation')
          .select('height, weight')
          .eq('id', userId)
          .single();
      setState(() {
        _weight = double.parse(responses['weight'].toString());
        _height = double.parse(responses['height'].toString());
        _caloriesBurned = _calculateCaloriesBurned(_todaySteps, _height, _weight);
      });
    }
  }

  double _calculateCaloriesBurned(int steps, double heightCm, double weightKg) {
    double strideLength = heightCm * (0.414); // in cm
    double weightLbs = weightKg * 2.20462; // convert kg to lbs
    double caloriesBurned = steps * strideLength * 0.000473 * weightLbs / 100; // formula
    return caloriesBurned;
  }

  void _updateStepGoal() {
    setState(() {
      _dailyStepGoal = int.tryParse(_goalController.text) ?? _dailyStepGoal;
    });
  }

  @override
  void dispose() {
    _goalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Steps Tracker'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10.0,
                            spreadRadius: 5.0,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StepsRadialChart(
                            steps: _todaySteps,
                            totalSteps: _dailyStepGoal,
                          ),
                          SizedBox(height: 10.0), // Gap between radial chart and the text field
                          Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: TextField(
                              controller: _goalController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Set Goal',
                                contentPadding: EdgeInsets.fromLTRB(0.0, 7.0,0.0, 0.0), // Adjust content padding LTRB
                                labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w800),
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.check),
                                  onPressed: _updateStepGoal,
                                  iconSize: 23,
                                ),
                              ),
                              style: TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10.0,
                            spreadRadius: 5.0,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            '🔥',
                            style: TextStyle(
                              fontSize: 127,
                            ),
                          ),
                          SizedBox(height: 0),
                          Text(
                            '${_caloriesBurned.toStringAsFixed(2)} kcal burnt',
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                height: 260,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10.0,
                      spreadRadius: 5.0,
                    ),
                  ],
                ),
                child: StepsLineChart(stepsData: _weeklySteps),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


