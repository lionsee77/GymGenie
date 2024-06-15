import 'package:flutter/material.dart';
import 'package:flutter_application/main.dart';
import 'package:flutter_application/widgets/my_text_button.dart';
import 'package:uuid/uuid.dart';

class AddTaskPage extends StatefulWidget {
  final String selectedDate;
  const AddTaskPage({Key? key, required this.selectedDate}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController _bodyController = TextEditingController();
  final TextEditingController _exerciseTypeController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _repsController = TextEditingController();

  bool _isValidNumber(String number) {
    final num? parsedNumber = num.tryParse(number);
    return parsedNumber != null && parsedNumber > 0;
  }

  String _selectedBodyPart = "Chest";

  @override
  void initState() {
    super.initState();
    _bodyController.text = _selectedBodyPart;
  }

  @override
  void dispose() {
    _bodyController.dispose();
    _exerciseTypeController.dispose();
    _weightController.dispose();
    _repsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                "Add Workout",
                style: TextStyle(fontFamily: "Lato", fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedBodyPart,
                decoration: const InputDecoration(
                  labelText: "Body Part",
                  border: OutlineInputBorder(),
                ),
                items: <String>["Chest", "Back", "Legs"].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedBodyPart = newValue!;
                    _bodyController.text = _selectedBodyPart;
                  });
                },
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _exerciseTypeController,
                decoration: const InputDecoration(
                  labelText: 'Exercise',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _weightController,
                decoration: const InputDecoration(
                  labelText: 'Weight',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _repsController,
                decoration: const InputDecoration(
                  labelText: 'Reps',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height:20),
              MyTextButton(
                buttonName: "Submit",
                bgColor: Colors.black,
                textColor: Colors.white,
                onTap: () async {
                  try {
                    final bodyPart = _bodyController.text;
                    final exerciseType = _exerciseTypeController.text;
                    final weight = _weightController.text;
                    final reps = _repsController.text;
                    final userId = supabase.auth.currentUser?.id;

                    if (!_isValidNumber(weight)) {
                      throw Exception('Invalid weight');
                    }
                    if (!_isValidNumber(reps)) {
                      throw Exception('Invalid reps');
                    }

                    final workoutId = Uuid().v4(); //generates a unique id for workout

                    await supabase.from('reps').insert({
                      'workout_id': workoutId,
                      'body_part': bodyPart,
                      'exercise_type': exerciseType,
                      'weight': int.parse(weight),
                      'reps': int.parse(reps),
                      'date': widget.selectedDate.toString(),
                      'id': userId!,
                    });

                    // Navigate back to the previous RepsPage
                    Navigator.pop(context);
                  } catch (error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to update info: $error'),
                      ),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
