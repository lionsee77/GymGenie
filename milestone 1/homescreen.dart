import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_2/nutrition.dart';
import 'package:flutter_application_2/workoutlog.dart';

class HomeScreen extends StatefulWidget {
  final String personName;
  const HomeScreen({super.key, required this.personName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 25.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.personName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const Icon(
                    Icons.person,
                    size: 45,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 400.0,
              height: 100,
              padding: const EdgeInsets.all(20.0), // Padding for rounded container
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: const Color.fromARGB(255, 255, 204, 128), // White container background
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("Welcome Back!"),
                  Text("progress bar"),
                ],
              ),
            ),
            const SizedBox(height: 30, width: 400),
            Expanded(
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                children: [
                  InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const WorkoutLog()),
                    ),      
                    child: Container(
                      color: Colors.red,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.home, size: 50, color: Colors.white),
                          SizedBox(height: 10),
                          Text('Workout Log', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Nutrition()),
                    ),      
                    child: Container(
                      color: Colors.blue,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.search, size: 50, color: Colors.white),
                          SizedBox(height: 10),
                          Text('Nutrition', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {

                    },
                    child: Container(
                      color: Colors.grey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.notifications, size: 50, color: Colors.white),
                          SizedBox(height: 10),
                          Text('Exercises', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      
                    },
                    child: Container(
                      color: Colors.pink,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.person, size: 50, color: Colors.white),
                          SizedBox(height: 10),
                          Text('Journal', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
