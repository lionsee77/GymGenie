import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/authentication_stuff/registerPage.dart';
import 'package:flutter_application/format_stuff/constants.dart';
import 'package:flutter_application/lobby.dart';
import 'package:flutter_application/main.dart';
import 'package:flutter_application/widgets/widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isPasswordVisible = true;

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
        //to make page scrollable
        child: CustomScrollView(
          reverse: true,
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome back.",
                            style: kHeadline,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "You've been missed!",
                            style: kBodyText2,
                          ),
                          SizedBox(
                            height: 60,
                          ),
                          MyTextField(
                            hintText: 'Email',
                            inputType: TextInputType.text,
                            controllerType: _emailController,
                          ),
                          MyPasswordField(
                            isPasswordVisible: isPasswordVisible,
                            onTap: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                            controllerType: _passwordController,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Dont't have an account? ",
                          style: kBodyText,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => RegisterPage(),
                              ),
                            );
                          },
                          child: Text(
                            'Register',
                            style: kBodyText.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    MyTextButton(
                      buttonName: 'Sign In',
                      onTap: () async {
                        try {
                          final authResponse = await supabase.auth.signInWithPassword(
                            email: _emailController.text,
                            password: _passwordController.text,
                          );
                          if (mounted) {
                            final firstName = await getFirstName(authResponse.user!.id); 
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => MyLobbyPage(personName: firstName),),);
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
                      bgColor: Colors.white,
                      textColor: Colors.black87,
                    ),
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


