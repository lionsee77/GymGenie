import 'package:flutter/material.dart';
import 'package:flutter_application/authentication_stuff/welcomePage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://ducthwysynmjsodmnzeh.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR1Y3Rod3lzeW5tanNvZG1uemVoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTcwNDkxMzYsImV4cCI6MjAzMjYyNTEzNn0.O4QeWbIEy6i1q5bQQx6mqcq1SuvMv0gQ_G1icfYa2AY",
  );

  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GymGenie',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 255, 255, 255)),
        useMaterial3: true,
      ),
      home: WelcomePage()
    );
  }
}





