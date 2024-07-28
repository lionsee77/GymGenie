import 'package:flutter_application/main.dart';
import 'package:flutter_application/widgets/healthKitService.dart';

class CaloriesService {
  final HealthKitService healthKitService = HealthKitService();

  Future<double> calculateCaloriesBurned(String personName) async {
    // Fetch user profile information
    final response = await supabase
        .from('profilesinformation')
        .select('height, weight')
        .eq('name', personName)
        .single();

    double height = double.parse(response['height'].toString());
    double weight = double.parse(response['weight'].toString());

    // Fetch today's steps
    int todaySteps = await healthKitService.getTodaySteps();

    // Calculate calories burned
    return _calculateCaloriesBurned(todaySteps, height, weight);
  }

  double _calculateCaloriesBurned(int steps, double heightCm, double weightKg) {
    double strideLength = heightCm * (0.414); // in cm
    double weightLbs = weightKg * 2.20462; // convert kg to lbs
    double caloriesBurned = steps * strideLength * 0.000473 * weightLbs / 100; // formula
    return caloriesBurned;
  }
}
