import 'package:flutter/material.dart';
import 'package:flutter_application_2/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      appBar: AppBar(
        title: const Text("Sign In"),
        centerTitle: true, 
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), 
          onPressed: () => Navigator.pop(context), 
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0), // Padding around form
          child: Column(
            mainAxisSize: MainAxisSize.min, // Wrap content vertically
            children: [
              Container(
                padding: const EdgeInsets.all(20.0), // Padding for rounded container
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0), // Rounded corners
                  color: Colors.white, // White container background
                ),
                child: Column(
                  children: [
                    const Text(
                      "Welcome Back!",
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold, // Bold title
                      ),
                    ),
                    const SizedBox(height: 20.0), // Spacing between title and form fields
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0), 
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                      ),
                      obscureText: true, 
                    ),
                    const SizedBox(height: 20.0), //spacing
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          await supabase.auth.signInWithPassword(
                            email: _emailController.text,
                            password: _passwordController.text,
                          );

                          if (mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const MyApp()),
                            );
                          }
                        } on AuthException catch (error) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Sign in failed: ${error.message}'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      child: const Text("Sign In"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 255, 217, 159), 
                        minimumSize: const Size(double.infinity, 50.0), 
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
