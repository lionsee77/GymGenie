import 'package:flutter/material.dart';
import 'package:flutter_application/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:pie_chart/pie_chart.dart';

class NutritionPage extends StatefulWidget {
  @override
  _NutritionPageState createState() => _NutritionPageState();
}

class _NutritionPageState extends State<NutritionPage> {
  DateTime stripTime(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  List<Map<String, dynamic>> _foodItems = [];
  Map<String, dynamic>? _selectedFoodItem;
  int _quantity = 1;
  late TextEditingController _quantityController;
  List<Map<String, dynamic>> _loggedMeals = [];
  double _totalCalories = 0.0;
  double _totalProtein = 0.0;
  double _totalCarbs = 0.0;
  double _totalFats = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchFoodItems();
    _fetchLoggedMeals();
    _quantityController = TextEditingController(text: _quantity.toString());
  }

  Future<void> _fetchFoodItems() async {
    try {
      final response = await supabase
          .from('nutri_data')
          .select('id, name, calories, protein, carbs, fat');

      setState(() {
        _foodItems = (response as List).cast<Map<String, dynamic>>();
      });
    } catch (e) {
      print("Error fetching Nutritional Data");
    }
  }

  Future<void> _fetchLoggedMeals() async {
    final userId = supabase.auth.currentUser?.id;
    final date = stripTime(DateTime.now()).toString();

    try {
      final response = await supabase
          .from('nutri_logging')
          .select('id, food_id, quantity')
          .eq('id', userId.toString())
          .eq('date', date);

      setState(() {
        _loggedMeals = (response as List).cast<Map<String, dynamic>>();
        _calculateTotalNutrition();
      });
    } catch (e) {
      print("Error fetching logged meals");
    }
  }

  void _calculateTotalNutrition() {
    double totalCalories = 0.0;
    double totalProtein = 0.0;
    double totalCarbs = 0.0;
    double totalFats = 0.0;

    for (var meal in _loggedMeals) {
      var foodItem = _foodItems.firstWhere((item) => item['id'] == meal['food_id']);
      totalCalories += foodItem['calories'] * meal['quantity'];
      totalProtein += foodItem['protein'] * meal['quantity'];
      totalCarbs += foodItem['carbs'] * meal['quantity'];
      totalFats += foodItem['fat'] * meal['quantity'];
    }

    setState(() {
      _totalCalories = totalCalories;
      _totalProtein = totalProtein;
      _totalCarbs = totalCarbs;
      _totalFats = totalFats;
    });
  }

  void _logFood(int foodItemId, int quantity) async {
    final userId = supabase.auth.currentUser?.id;
    final uuid = Uuid().v4();
    final date = stripTime(DateTime.now()).toString();

    try {
      final response = await supabase
          .from('nutri_logging')
          .select('id, quantity')
          .eq('id', userId.toString())
          .eq('food_id', foodItemId)
          .eq('date', date);

      if (response.isNotEmpty) {
        final currentLog = response[0];
        final oldQuantity = currentLog['quantity'] as int;
        final updatedQuantity = quantity + oldQuantity;

        await supabase
            .from('nutri_logging')
            .update({'quantity': updatedQuantity})
            .eq('id', currentLog['id'])
            .eq('food_id', foodItemId)
            .eq('date', date);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Food quantity updated successfully')),
        );
      } else {
        await supabase.from('nutri_logging').insert({
          'entry_id': uuid,
          'id': userId,
          'food_id': foodItemId,
          'quantity': quantity,
          'date': date,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Food logged successfully')),
        );
      }

      await _fetchLoggedMeals();

      setState(() {
        _selectedFoodItem = null;
        _quantity = 1;
        _quantityController.text = _quantity.toString(); 
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update info: $error')),
      );
    }
  }

  Future<void> _addFoodItem(Map<String, dynamic> newFoodItem) async {
  try {
    final newId = _foodItems.length + 1; // Calculate new ID based on list size
    await supabase.from('nutri_data').insert({
      'id': newId.toString(),
      'name': newFoodItem['name'],
      'calories': newFoodItem['calories'],
      'protein': newFoodItem['protein'],
      'carbs': newFoodItem['carbs'],
      'fat': newFoodItem['fat'],
    });
    await _fetchFoodItems();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Food item added successfully')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to add food item: $e')),
    );
  }
}


  void _showAddFoodItemDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController caloriesController = TextEditingController();
    final TextEditingController proteinController = TextEditingController();
    final TextEditingController carbsController = TextEditingController();
    final TextEditingController fatController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Food Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: caloriesController,
                decoration: InputDecoration(labelText: 'Calories'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: proteinController,
                decoration: InputDecoration(labelText: 'Protein (g)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: carbsController,
                decoration: InputDecoration(labelText: 'Carbs (g)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: fatController,
                decoration: InputDecoration(labelText: 'Fat (g)'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final newFoodItem = {
                  'name': nameController.text,
                  'calories': double.tryParse(caloriesController.text) ?? 0.0,
                  'protein': double.tryParse(proteinController.text) ?? 0.0,
                  'carbs': double.tryParse(carbsController.text) ?? 0.0,
                  'fat': double.tryParse(fatController.text) ?? 0.0,
                };
                _addFoodItem(newFoodItem);
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nutrition Tracker'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showAddFoodItemDialog,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            DropdownButton<Map<String, dynamic>>(
              hint: Text('Select Food Item'),
              value: _selectedFoodItem,
              onChanged: (Map<String, dynamic>? newValue) {
                setState(() {
                  _selectedFoodItem = newValue;
                });
              },
              items: _foodItems.map((Map<String, dynamic> item) {
                return DropdownMenuItem<Map<String, dynamic>>(
                  value: item,
                  child: Text(item['name']),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _quantityController,
              decoration: InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                try {
                  setState(() {
                    _quantity = int.parse(value);
                  });
                } catch (e) {
                  setState(() {
                    _quantity = 1; 
                  });
                }
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectedFoodItem == null
                  ? null
                  : () {
                      _logFood(_selectedFoodItem!['id'], _quantity);
                    },
              child: Text('Submit'),
            ),
            SizedBox(height: 20),
            Container(
              height: 200,
              child: PieChart(
                dataMap: {
                  "Protein": _totalProtein,
                  "Carbs": _totalCarbs,
                  "Fats": _totalFats,
                },
                colorList: [Colors.blue, Colors.green, Colors.red],
                chartType: ChartType.ring,
                ringStrokeWidth: 32,
                centerText: "${_totalCalories.toStringAsFixed(0)} cal",
                legendOptions: LegendOptions(showLegends: true),
                chartValuesOptions: ChartValuesOptions(
                  showChartValuesInPercentage: true,
                  showChartValuesOutside: true,
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _loggedMeals.length,
                itemBuilder: (context, index) {
                  final meal = _loggedMeals[index];
                  final foodItem = _foodItems.firstWhere((item) => item['id'] == meal['food_id']);

                  return ListTile(
                    title: Text('${foodItem['name']} (${meal['quantity']}x)'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
