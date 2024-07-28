
import 'package:health/health.dart';

class HealthKitService {
  HealthFactory health = HealthFactory();

  Future<bool> requestAuthorization() async {
    final types = [HealthDataType.STEPS];
    bool requested = await health.requestAuthorization(types);
    return requested;
  }

  Future<int> getTodaySteps() async {
    if (await requestAuthorization()) {
      DateTime now = DateTime.now();
      DateTime startOfDay = DateTime(now.year, now.month, now.day);

      List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
          startOfDay, now, [HealthDataType.STEPS]);

      int totalSteps = healthData.fold(0, (sum, dataPoint) {
        return sum + (dataPoint.value as double).toInt();
      });

      return totalSteps;
    }
    return 0;
  }

  Future<List<Map<String, dynamic>>> getStepsForWeek() async {
    if (await requestAuthorization()) {
      DateTime now = DateTime.now();
      DateTime startDate = now.subtract(Duration(days: 7));
      List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
          startDate, now, [HealthDataType.STEPS]);

      Map<DateTime, int> stepsData = {};
      for (var point in healthData) {
        DateTime date = DateTime(point.dateFrom.year, point.dateFrom.month, point.dateFrom.day);
        int steps = (point.value as double).toInt();
        if (stepsData.containsKey(date)) {
          stepsData[date] = stepsData[date]! + steps;
        } else {
          stepsData[date] = steps;
        }
      }

      List<Map<String, dynamic>> stepsWithDays = stepsData.entries.map((entry) {
        return {
          'date': entry.key,
          'steps': entry.value,
          'day': _getDayOfWeek(entry.key.weekday),
        };
      }).toList();

      return stepsWithDays;
    }
    return [];
  }

  String _getDayOfWeek(int day) {
    switch (day) {
      case 1:
        return 'M';
      case 2:
        return 'T';
      case 3:
        return 'W';
      case 4:
        return 'T';
      case 5:
        return 'F';
      case 6:
        return 'S';
      case 7:
        return 'S';
      default:
        return '';
    }
  }
}

