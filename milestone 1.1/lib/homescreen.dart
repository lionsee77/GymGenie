import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
//import 'package:flutter_application_2/main.dart';

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
                    //"${widget.personName}",
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
            const SizedBox(height:20),
            Container(
              width: 400.0,
              height: 100,
              padding: const EdgeInsets.all(20.0), // Padding for rounded container
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Color.fromARGB(255, 255, 204, 128), // White container background
                ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                Text("Welcome Back!"),
                Text("progress bar!"),
              ],),
            ),
            const SizedBox(height: 30, width: 400),
            

          ],
        ),
      ),
    );
  }
}

