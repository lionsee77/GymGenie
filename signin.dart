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
      appBar: AppBar(
        title: const Text("Sign In"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Email",
              ),
            ),
            const SizedBox(height: 16), // Use SizedBox for spacing
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: "Password",
              ),
              obscureText: true, // Password field should be obscured
            ),
            const SizedBox(height: 16),
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
            ),
          ],
        ),
      ),
    );
  }
}
