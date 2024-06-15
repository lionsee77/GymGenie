import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/authentication_stuff/informationPage.dart';
import 'package:flutter_application/authentication_stuff/signinPage.dart';
// import 'package:flutter_application/lobby.dart';
import 'package:flutter_application/main.dart';
import 'package:flutter_application/widgets/widget.dart';
import 'package:flutter_application/format_stuff/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool passwordVisibility = true;

  bool _isValidEmail(String email) {
    return email.isNotEmpty && email.contains('@'); 
  }

  bool _isValidPassword(String password) {
    return password.length >= 6; 
  }

  Future<String> getFirstName(String userId) async {
    final response = await supabase
      .from('profilesinformation')
          .select('name')
          .eq('id', userId)
          .single();
        return response['name'].toString();
    //   .from('profiles')
    //   .select('first_name')
    //   .eq('id', userId)
    //   .single();
    // return response['first_name'].toString();
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
          final userId = authResponse.user!.id;

          // await supabase.from('profiles').insert({
          //   'id': userId,
          //   'first_name': name,
          // });

          await supabase.from('profilesinformation').insert({
            'id': userId,
            'name': name,
          });

          return authResponse.user;
        }
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset(
            'assets/images/back_arrow.svg',
            color: Colors.white,
            width: 22,
          ),
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Register",
                            style: kHeadline,
                          ),
                          const Text(
                            "Create new account to get started.",
                            style: kBodyText2,
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          MyTextField(
                            hintText: 'Name',
                            inputType: TextInputType.name,
                            controllerType: _nameController,
                          ),
                          MyTextField(
                            hintText: 'Email',
                            inputType: TextInputType.emailAddress,
                            controllerType: _emailController,
                          ),
                          MyPasswordField(
                            isPasswordVisible: passwordVisibility,
                            onTap: () {
                              setState(() {
                                passwordVisibility = !passwordVisibility;
                              });
                            },
                            controllerType: _passwordController,
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: kBodyText,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => SignInPage(),
                              ),
                            );
                          },
                          child: Text(
                            'Sign In',
                            style: kBodyText.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MyTextButton(
                      buttonName: 'Register',
                      onTap: () async {
                        if (!_isValidEmail(_emailController.text)) return;
                        if (!_isValidPassword(_passwordController.text)) return;

                        try {
                          final user = await _signUpWithRetry(_emailController.text, _passwordController.text, _nameController.text);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Registered ${user!.email!}"),
                            ),
                          );
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => InfoPage(userId: user.id),
                          ));

                          _nameController.clear();
                          _emailController.clear();
                          _passwordController.clear();
                          
                        } on Exception catch (error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Sign up failed: $error'),
                            ),
                          );
                        }
                      },
                      bgColor: Colors.white,
                      textColor: Colors.black87,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_application/authentication_stuff/signinPage.dart';
// import 'package:flutter_application/lobby.dart';
// import 'package:flutter_application/main.dart';
// import 'package:flutter_application/widgets/widget.dart';
// import 'package:flutter_application/format_stuff/constants.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class RegisterPage extends StatefulWidget {
//   const RegisterPage({super.key});

//   @override
//   State<RegisterPage> createState() => _RegisterPageState();
// }

// class _RegisterPageState extends State<RegisterPage> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _nameController = TextEditingController();
//   bool passwordVisibility = true;

//   bool _isValidEmail(String email) {
//     return email.isNotEmpty && email.contains('@'); 
//   }

//   bool _isValidPassword(String password) {
//     return password.length >= 6; 
//   }

//   Future<String> getFirstName(String userId) async {
//     final response = await supabase
//       .from('profiles')
//       .select('first_name')
//       .eq('id', userId)
//       .single();
//     return response['first_name'].toString();
//   }

//   Future<User?> _signUpWithRetry(String email, String password, String name) async {
//     int retryCount = 0;
//     const maxRetries = 4;

//     while (retryCount < maxRetries) {
//       try {
//         final authResponse = await supabase.auth.signUp(
//           password: password,
//           email: email,
//         );

//         if (authResponse.user != null) {
//           await supabase.from('profiles').insert({
//             'id' : authResponse.user!.id,
//             'first_name' : name,
//           });
//         };
//         return authResponse.user;
//       } on AuthRetryableFetchException {
//         retryCount++;
//         await Future.delayed(const Duration(seconds: 3)); 
//       }
//     }

//     throw Exception('Sign up failed after $maxRetries retries');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: kBackgroundColor,
//         elevation: 0,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: SvgPicture.asset(
//             'assets/images/back_arrow.svg',
//             color: Colors.white,
//             width: 22,
//           ),
//         ),
//       ),
//       body: SafeArea(
//         child: CustomScrollView(
//           slivers: [
//             SliverFillRemaining(
//               hasScrollBody: false,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 20,
//                 ),
//                 child: Column(
//                   children: [
//                     Flexible(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text(
//                             "Register",
//                             style: kHeadline,
//                           ),
//                           const Text(
//                             "Create new account to get started.",
//                             style: kBodyText2,
//                           ),
//                           const SizedBox(
//                             height: 50,
//                           ),
//                           MyTextField(
//                             hintText: 'Name',
//                             inputType: TextInputType.name,
//                             controllerType: _nameController,
//                           ),
//                           MyTextField(
//                             hintText: 'Email',
//                             inputType: TextInputType.emailAddress,
//                             controllerType: _emailController,
//                           ),
//                           MyPasswordField(
//                             isPasswordVisible: passwordVisibility,
//                             onTap: () {
//                               setState(() {
//                                 passwordVisibility = !passwordVisibility;
//                               });
//                             },
//                             controllerType: _passwordController,
//                           )
//                         ],
//                       ),
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           "Already have an account? ",
//                           style: kBodyText,
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               CupertinoPageRoute(
//                                 builder: (context) => SignInPage(),
//                               ),
//                             );
//                           },
//                           child: Text(
//                             'Sign In',
//                             style: kBodyText.copyWith(
//                               color: Colors.white,
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     MyTextButton(
//                       buttonName: 'Registers',
//                       onTap: () async {
//                         if (!_isValidEmail(_emailController.text)) return;
//                         if (!_isValidPassword(_passwordController.text)) return;

//                         try {
//                           final user = await _signUpWithRetry(_emailController.text, _passwordController.text, _nameController.text);
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Text("Registered ${user!.email!}"),
//                             ),
//                           );
//                           final firstName = await getFirstName(user.id); 
//                           Navigator.push(context, MaterialPageRoute(
//                             builder: (context) => MyLobbyPage(personName: firstName),),); //original

//                           _nameController.clear();
//                           _emailController.clear();
//                           _passwordController.clear();
                          
//                         } on Exception catch (error) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Text('Sign up failed: $error'),
//                             ),
//                           );
//                         }
//                       },
//                       bgColor: Colors.white,
//                       textColor: Colors.black87,
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
