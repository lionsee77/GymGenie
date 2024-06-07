import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_application_2/homescreen.dart';

final supabase = Supabase.instance.client;

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  bool _isValidEmail(String email) {
    return email.isNotEmpty && email.contains('@'); 
  }

  bool _isValidPassword(String password) {
    return password.length >= 6; 
  }

  Future<String> getFirstName(String userId) async {
    final response = await supabase
      .from('profiles')
      .select('first_name')
      .eq('id', userId)
      .single();
    return response['first_name'].toString();
  }

  Future<User?> _signUpWithRetry(String email, String password, String name) async {
    int retryCount = 0;
    const maxRetries = 4;

    while (retryCount < maxRetries) {
      try {
        final authResponse = await supabase.auth.signUp(
          password: password,
          email: email,
        );

        if (authResponse.user != null) {
          await supabase.from('profiles').insert({
            'id' : authResponse.user!.id,
            'first_name' : name,
          });
        };
        return authResponse.user;
      } on AuthRetryableFetchException {
        retryCount++;
        await Future.delayed(const Duration(seconds: 3)); 
      }
    }

    throw Exception('Sign up failed after $maxRetries retries');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      appBar: AppBar(
        title: const Text("Sign Up"),
        centerTitle: true, 
        leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min, // Wrap content vertically
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: SizedBox(
                width: 250.0,
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0), // Rounded corners
                      borderSide: const BorderSide(color: Colors.grey), // Border color
                    ),
                    filled: true,
                    fillColor: Colors.white,

                  ),
                ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0), // Add spacing
              child: SizedBox(
                width: 250.0, // Adjust width as needed
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: !_isValidEmail(emailController.text)
                        ? 'Email address'
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0), // Rounded corners
                      borderSide: const BorderSide(color: Colors.grey), // Border color
                    ),
                    filled: true, // Fill the background
                    fillColor: Colors.white, // Background color
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0), 
              child: SizedBox(
                width: 250.0, 
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: !_isValidPassword(passwordController.text)
                        ? 'Password'
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0), // Rounded corners
                      borderSide: const BorderSide(color: Colors.grey), // Border color
                    ),
                    filled: true, 
                    fillColor: Colors.white, 
                  ),
                ),
              ),
            ),
            MaterialButton(
              onPressed: () async {
                if (!_isValidEmail(emailController.text)) return;
                if (!_isValidPassword(passwordController.text)) return;

                try {
                  final user = await _signUpWithRetry(emailController.text, passwordController.text, nameController.text);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Registered ${user!.email!}"),
                    ),
                  );
                  final firstName = await getFirstName(user.id); 
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => HomeScreen(personName: firstName),),);

                  nameController.clear();
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