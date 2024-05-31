import 'package:flutter/material.dart';
import 'package:flutter_application_2/signin.dart';
import 'package:flutter_application_2/signup.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GymGenie Orbital 2024", style: TextStyle(
          fontWeight: FontWeight.bold
        ),),
      ),
      backgroundColor: Colors.white,
      body: Material(
        child: Padding(
          padding: const EdgeInsets.all(40.0), // Adjust padding as needed
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/lamp-5890531_640.png'),
              const Text("Welcome!",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUp()),
                    ),
                    child: const Text("SignUp Page"),
                  ),
                  const SizedBox(width: 30),
                  ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignIn()),
                    ),
                    child: const Text("Login Page"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}