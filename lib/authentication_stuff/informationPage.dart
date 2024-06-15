import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/lobby.dart';
import 'package:flutter_application/main.dart';
import 'package:flutter_application/widgets/widget.dart';
import 'package:flutter_application/format_stuff/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';


class InfoPage extends StatefulWidget {
  final String userId;

  const InfoPage({super.key, required this.userId});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _goalsController = TextEditingController();
  bool passwordVisibility = true;

  bool _isValidNumber(String number) { 
    final num? parsedNumber = num.tryParse(number);
    return parsedNumber != null && parsedNumber > 0;
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
                            "Information Page",
                            style: kHeadline,
                          ),
                          const Text(
                            "Let us get to know you better",
                            style: kBodyText2,
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          MyTextField(
                            hintText: 'Height',
                            inputType: TextInputType.number,
                            controllerType: _heightController,
                          ),
                          MyTextField(
                            hintText: 'Weight',
                            inputType: TextInputType.number,
                            controllerType: _weightController,
                          ),
                          MyTextField(
                            hintText: 'Goals',
                            inputType: TextInputType.text,
                            controllerType: _goalsController,
                          ),
                        ],
                      ),
                    ),
                    MyTextButton(
                      buttonName: 'Next',
                      onTap: () async {
                        try {
                          final height = _heightController.text;
                          final weight = _weightController.text;

                          if (!_isValidNumber(height)) {
                            throw Exception('Invalid height');
                          }
                          if (!_isValidNumber(weight)) {
                            throw Exception('Invalid weight');
                          }

                          await supabase.from('profilesinformation').update({
                            'height': int.parse(height),
                            'weight': int.parse(weight),
                            'goals': _goalsController.text,
                          }).eq('id', widget.userId);

                          final firstName = await getFirstName(widget.userId);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyLobbyPage(personName: firstName),
                            ),
                          );
                        } catch (error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to update info: $error'),
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
