import 'package:flutter/material.dart';
import 'package:flutter_application/main.dart';
import 'package:flutter_application/widgets/my_text_button.dart';

class EditTaskPage extends StatefulWidget {
  final Map<String, dynamic> workout;
  final DateTime selectedDate;

  const EditTaskPage({Key? key, required this.workout, required this.selectedDate}) : super(key: key);

  @override
  _EditTaskPageState createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  late TextEditingController _exerciseTypeController; //late is for deferred initialisation
  late TextEditingController _weightController;
  late TextEditingController _repsController;
  late String _selectedBodyPart;

  @override
  void initState() {
    super.initState();
    _exerciseTypeController = TextEditingController(text: widget.workout['exercise_type']);
    _weightController = TextEditingController(text: widget.workout['weight'].toString());
    _repsController = TextEditingController(text: widget.workout['reps'].toString());
    _selectedBodyPart = widget.workout['body_part'];
  }

  Future<void> _updateWorkout() async {
    final userId = supabase.auth.currentUser?.id;

    final updatedWorkout = {
      'body_part': _selectedBodyPart,
      'exercise_type': _exerciseTypeController.text,
      'weight': int.parse(_weightController.text),
      'reps': int.parse(_repsController.text),
    };

    await supabase
        .from('reps')
        .update(updatedWorkout)
        .eq('workout_id', widget.workout['workout_id']) //checks that only unique workout is editted instead of all on that day
        .eq('id', userId.toString());

    Navigator.pop(context);
  }

  Future<void> _deleteWorkout() async { //checks if user is sure of deleting log
    final userId = supabase.auth.currentUser?.id;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this workout?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () async {
                await supabase
                    .from('reps')
                    .delete()
                    .eq('workout_id', widget.workout['workout_id'])
                    .eq('id', userId.toString());

                Navigator.pop(context); //one is for initial box
                Navigator.pop(context);  //last one for confirm delete
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Workout')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedBodyPart,
              decoration: InputDecoration(labelText: 'Body Part'),
              items: <String>['Chest', 'Back', 'Legs'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedBodyPart = newValue!;
                });
              },
            ),
            SizedBox(height: 20,),
            TextField(
              controller: _exerciseTypeController,
              decoration: const InputDecoration(
                  labelText: 'Exercise',
                  border: OutlineInputBorder(),
                ),
            ),
            SizedBox(height: 20,),
            TextField(
              controller: _weightController,
              decoration: const InputDecoration(
                  labelText: 'Weight',
                  border: OutlineInputBorder(),
                ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20,),
            TextField(
              controller: _repsController,
              decoration: const InputDecoration(
                  labelText: 'Reps',
                  border: OutlineInputBorder(),
                ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            MyTextButton(
              buttonName: 'Save',
              onTap: _updateWorkout,
              bgColor: Colors.black,
              textColor: Colors.white,
            ),
            SizedBox(height: 20),
            MyTextButton(
              buttonName: 'Delete',
              onTap: _deleteWorkout,
              bgColor: Colors.red,
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
