import 'package:flutter/material.dart';
import 'package:flutter_application/main.dart';
import 'package:flutter_application/widgets/my_text_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  int _weight = 0;
  int _height = 0;
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId != null) {
      final weightResponse = await supabase
          .from('profilesinformation')
          .select('weight')
          .eq('id', userId)
          .single();
      final heightResponse = await supabase
          .from('profilesinformation')
          .select('height')
          .eq('id', userId)
          .single();
      setState(() {
        _weight = weightResponse['weight'];
        _height = heightResponse['height'];
        _weightController.text = _weight.toString();
        _heightController.text = _height.toString();
      });
    }
  }

  Future<void> updateWeightInDatabase(int weight) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId != null) {
      await supabase
          .from('profilesinformation')
          .update({'weight': weight})
          .eq('id', userId);
    }
  }

  Future<void> updateHeightInDatabase(int height) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId != null) {
      await supabase
          .from('profilesinformation')
          .update({'height': height})
          .eq('id', userId);
    }
  }

  void _updateWeight() async {
    setState(() {
      _weight = int.parse(_weightController.text);
      _weightController.clear(); // Clear the text field
    });
    await updateWeightInDatabase(_weight); // Update the database
  }

  void _updateHeight() async {
    setState(() {
      _height = int.parse(_heightController.text);
      _heightController.clear(); // Clear the text field
    });
    await updateHeightInDatabase(_height); // Update the database
  }

 /* bool isValidHeight(int height) {
    if (90 < height && height < 270) {
      return true;
    }
    return false;
  }

  bool isValidWeight(int weight){
    if (10 < weight && weight < 300) {
      return true;
    }
    return false;
  }

*/
  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(225, 217, 209, 250),
      appBar: AppBar(
        backgroundColor:const Color.fromARGB(225, 217, 209, 250),
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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Current Height: $_height cm',
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
              TextField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Update Height',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (_) =>  _updateHeight(),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Current Weight: $_weight kg',
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
              TextField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Update Height',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (_) => _updateWeight(),
              ),
              const SizedBox(height: 40),
              MyTextButton(
                buttonName: "Sign Out",
                onTap: () {
                  supabase.auth.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MyApp()),
                  );
                },
                bgColor: Colors.red.withOpacity(0.5), // Transparent background
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}