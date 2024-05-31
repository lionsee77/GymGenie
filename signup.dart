import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isValidEmail(String email) {
    // Implement your email validation logic here (e.g., using a regular expression)
    return email.isNotEmpty && email.contains('@'); // Basic check
  }

  bool _isValidPassword(String password) {
    // Implement your password validation logic here (e.g., minimum length, complexity)
    return password.length >= 6; // Basic check
  }

  Future<User?> _signUpWithRetry(String email, String password) async {
    int retryCount = 0;
    const maxRetries = 4;

    while (retryCount < maxRetries) {
      try {
        final authResponse = await supabase.auth.signUp(
          password: password,
          email: email,
        );
        return authResponse.user;
      } on AuthRetryableFetchException {
        retryCount++;
        await Future.delayed(const Duration(seconds: 3)); // Adjust delay as needed
      }
    }

    throw Exception('Sign up failed after $maxRetries retries');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
        centerTitle: true, // Center the title
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min, // Wrap content vertically
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: !_isValidEmail(emailController.text)
                    ? 'Valid email address'
                    : null,
              ),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: !_isValidPassword(passwordController.text)
                    ? 'Strong password'
                    : null,
              ),
            ),
            MaterialButton(
              onPressed: () async {
                if (!_isValidEmail(emailController.text)) return;
                if (!_isValidPassword(passwordController.text)) return;

                try {
                  final user = await _signUpWithRetry(emailController.text, passwordController.text);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Registered ${user!.email!}"),
                    ),
                  );
                  // Clear text fields or perform other actions after successful sign-up
                  emailController.clear();
                  passwordController.clear();
                } on Exception catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Sign up failed: $error'),
                    ),
                  );
                }
              },
              child: const Text("Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}
