import 'package:flutter/material.dart';
import 'package:flutter_application_2/signin.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'signup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://ducthwysynmjsodmnzeh.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR1Y3Rod3lzeW5tanNvZG1uemVoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTcwNDkxMzYsImV4cCI6MjAzMjYyNTEzNn0.O4QeWbIEy6i1q5bQQx6mqcq1SuvMv0gQ_G1icfYa2AY",
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GymGenie',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GymGenie"),
      ),
      body: Material(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Welcome! GymGenie Orbital 2024"),
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
    );
  }
}
