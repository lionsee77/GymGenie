import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/button.dart';
import 'package:flutter_application/main.dart';
import 'package:flutter_application/reps_add/addtask.dart';
import 'package:flutter_application/reps_add/editTaskPage.dart';
import 'package:intl/intl.dart';

class RepsPage extends StatefulWidget {
  final NotchBottomBarController? controller;
  final PageController? pageController;

  const RepsPage({Key? key, this.controller, this.pageController}) : super(key: key);

  @override
  State<RepsPage> createState() => _RepsPageState();
}

class _RepsPageState extends State<RepsPage> {
  DateTime _selectedDate = DateTime.now();
  List<Map<String, dynamic>> _workouts = [];

  DateTime stripTime(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  @override
  void initState() {
    super.initState();
    _selectedDate = stripTime(DateTime.now());
    _fetchWorkouts();
  }

  Future<void> _fetchWorkouts() async {
    final userId = supabase.auth.currentUser?.id;

    try {
      final response = await supabase
          .from('reps')
          .select('workout_id, body_part, exercise_type, weight, reps')
          .eq('id', userId!)
          .eq('date', stripTime(_selectedDate));

      setState(() {
        _workouts = (response as List).cast<Map<String, dynamic>>();
      });
    } catch (e) {
      print("Error fetching workouts: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = stripTime(DateTime.now());
    DateTime past = DateTime(now.year, now.month, now.day - 14);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 100),
          _addTaskBar(context),
          _addDateBar(past, now),
          Expanded(child: _workoutsList()), 
        ],
      ),
    );
  }

  Container _addDateBar(DateTime past, DateTime now) { //date picker bar`
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: DatePicker(
        past,
        height: 100,
        width: 80,
        initialSelectedDate: _selectedDate,
        daysCount: 15,
        selectionColor: Colors.black,
        selectedTextColor: Colors.white,
        dateTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
        onDateChange: (date) {
          setState(() {
            _selectedDate = stripTime(date);
          });
          _fetchWorkouts();
        },
      ),
    );
  }

  Container _addTaskBar(BuildContext context) { //add task button
    return Container(
      margin: const EdgeInsets.only(left: 5, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMMd().format(DateTime.now()),
                  style: TextStyle(fontFamily: 'Lato', fontSize: 24, fontWeight: FontWeight.w300),
                ),
                Text(
                  "Today",
                  style: TextStyle(fontFamily: 'Lato', fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          MyButton(
            label: "+ Add Task",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddTaskPage(selectedDate: _selectedDate.toString()),
                ),
              ).then((_) => _fetchWorkouts());
            },
          ),
        ],
      ),
    );
  }

  Widget _workoutsList() {
    if (_workouts.isEmpty) {
      return Center(child: Text("No workouts logged for this date"));
    } else {
      return ListView.builder(
        itemCount: _workouts.length,
        itemBuilder: (context, index) { //buids the card based on the length of the workouts gathered
          final workout = _workouts[index];

          return Card(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: Colors.black,
            child: ListTile(
              contentPadding: EdgeInsets.all(15),
              title: Text(
                workout['exercise_type'],
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text('Body Part: ${workout['body_part']}',style: TextStyle(color: Colors.white, fontSize: 15),),
                  Text('Weight: ${workout['weight']} kg',style: TextStyle(color: Colors.white, fontSize: 15)),
                  Text('Reps: ${workout['reps']}',style: TextStyle(color: Colors.white, fontSize: 15)),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditTaskPage(
                      workout: workout, //pass through workout so that the bottom notch stays there
                      selectedDate: _selectedDate,
                    ),
                  ),
                ).then((_) => _fetchWorkouts());
              },
            ),
          );
        },
      );
    }
  }
}
