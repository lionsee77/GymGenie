import 'package:flutter/material.dart';
import 'package:flutter_application/main.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:pie_chart/pie_chart.dart';


class NutritionPage extends StatefulWidget {
  @override
  _NutritionPageState createState() => _NutritionPageState();
}

class _NutritionPageState extends State<NutritionPage> {
  DateTime _selectedDate = DateTime.now();
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
    _fetchLoggedMeals(_selectedDate);
    _quantityController = TextEditingController(text: _quantity.toString());
  }

  DateTime stripTime(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  Future<void> _fetchFoodItems() async { //generate list of nutritional data present
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

  Future<void> _fetchLoggedMeals(DateTime date) async { //fetch any meals logged for the day
    final userId = supabase.auth.currentUser?.id;
    final formattedDate = stripTime(date).toString();

    try {
      final response = await supabase
          .from('nutri_logging')
          .select('entry_id, food_id, quantity')
          .eq('id', userId.toString())
          .eq('date', formattedDate);

      setState(() {
        _loggedMeals = (response as List).cast<Map<String, dynamic>>();
        _calculateTotalNutrition();
      });
    } catch (e) {
      print("Error fetching logged meals");
    }
  }

  void _calculateTotalNutrition() { //total nutri
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
    final date = stripTime(_selectedDate).toString();

    try {
      final response = await supabase
          .from('nutri_logging')
          .select('entry_id, quantity')
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
            .eq('entry_id', currentLog['entry_id'] as String);

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

      await _fetchLoggedMeals(_selectedDate);

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

  Future<void> _editFoodLog(String entryId, int newQuantity) async {
    try {
      await supabase
          .from('nutri_logging')
          .update({'quantity': newQuantity})
          .eq('entry_id', entryId);

      await _fetchLoggedMeals(_selectedDate);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Food log updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update food log: $e')),
      );
    }
  }

  Future<void> _deleteFoodLog(String entryId) async {
    try {
      await supabase
          .from('nutri_logging')
          .delete()
          .eq('entry_id', entryId);

      await _fetchLoggedMeals(_selectedDate);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Food log deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete food log: $e')),
      );
    }
  }

  void _showEditFoodLogDialog(String entryId, int currentQuantity) {
    final TextEditingController quantityController = TextEditingController(text: currentQuantity.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Food Log'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: quantityController,
                decoration: InputDecoration(labelText: 'Quantity'),
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
                final newQuantity = int.tryParse(quantityController.text) ?? currentQuantity;
                _editFoodLog(entryId, newQuantity);
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteFoodLogDialog(String entryId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this food log?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                _deleteFoodLog(entryId);
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = _selectedDate.toLocal().toString().split(' ')[0];

    return Scaffold(
      body: 
          Column(
            children: [
              SizedBox(height:60),
              Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: 
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton( //add food items to database
                    icon: Icon(Icons.add),
                    onPressed: _showAddFoodItemDialog,
                  ),
                  IconButton( //select date to view
                    icon: Icon(Icons.calendar_today),
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null && picked != _selectedDate) {
                        setState(() {
                          _selectedDate = picked;
                        });
                        _fetchLoggedMeals(_selectedDate);
                      }
                    },
                  ),
                ],
              )), 
            
            
          
      SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Total Nutrition for ${DateFormat('EEEE, d MMMM').format(_selectedDate)}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  PieChart(
                    dataMap: {
                      'Protein': _totalProtein,
                      'Carbs': _totalCarbs,
                      'Fats': _totalFats,
                    },
                    chartRadius: MediaQuery.of(context).size.width / 3.2,
                    chartType: ChartType.ring,
                    chartValuesOptions: ChartValuesOptions(
                      showChartValues: true,
                      showChartValuesInPercentage: true
                    ),
                    legendOptions: LegendOptions(
                      legendPosition: LegendPosition.right,
                      showLegends: true,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Total Calories: $_totalCalories kcal',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
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
            
                  Divider(height: 20, thickness: 2),
                  Text(
                    'Logged Meals',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _loggedMeals.length,
                    itemBuilder: (context, index) {
                      final meal = _loggedMeals[index];
                      final foodItem = _foodItems.firstWhere((item) => item['id'] == meal['food_id']);

                      return ListTile(
                        title: Text(foodItem['name']),
                        subtitle: Text('${meal['quantity']} servings'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                _showEditFoodLogDialog(meal['entry_id'], meal['quantity']);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _showDeleteFoodLogDialog(meal['entry_id']);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ])); 
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }
}
