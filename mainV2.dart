import 'package:flutter/material.dart';
import 'package:gymgenie/pages/accountPage.dart';
import 'package:gymgenie/pages/loginPage.dart';
import 'package:gymgenie/pages/splashPage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://qkavtstemwqniveqiafl.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFrYXZ0c3RlbXdxbml2ZXFpYWZsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTY2OTQ3ODEsImV4cCI6MjAzMjI3MDc4MX0.e3DGJVDh8_lqgRsqGFUr1ecSH4bII7ocl_iLOWNY3dE',
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const Splashpage(),
        '/login': (context) => const Loginpage(),
        '/account': (context) => const Accountpage(),
      },
    );  
  }
}







// // Everything below this is V1, journal feature
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(title: 'Flutter Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {

//   //Steam allows us to get real time updates from the database
//   final _notesStream = Supabase.instance.client.from('Notes').stream(primaryKey: ['id']);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('My Journal'),
//       ),
//       //body: Container(),
//       body: StreamBuilder<List<Map<String, dynamic >>> (
//         stream: _notesStream, 
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           final notes = snapshot.data!; 
          
//           return ListView.builder(
//             itemCount: notes.length,
//             itemBuilder: (context, index) {
//               return ListTile(
//                 title: Text(notes[index]['body']),
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           showDialog(
//             context: context, 
//             builder: ((context) {
//               return SimpleDialog(
//                 title: const Text('Add a note'),
//                 contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
//                 children: [
//                   TextFormField(
//                     onFieldSubmitted: (value) async {
//                       await Supabase.instance.client.from('Notes').insert({'body':value});
//                     },
//                   ),
//                 ],
//               );
//             }),
//           );
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }

