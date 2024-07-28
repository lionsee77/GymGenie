import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/screens/settingsPage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  final NotchBottomBarController? controller;
  final String personName;

  const HomePage({Key? key, this.controller, required this.personName}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _height;
  String? _weight;
  final List<Map<String, dynamic>> _journalEntries = [];
  final TextEditingController _journalController = TextEditingController();
  final SupabaseClient supabase = Supabase.instance.client; // Initialize Supabase client
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
    _fetchJournal();
  }

  Future<void> _fetchUserProfile() async {
    try {
      final response = await supabase
          .from('profilesinformation')
          .select('height, weight')
          .eq('name', widget.personName)
          .single();

      setState(() {
        _height = response['height'].toString();
        _weight = response['weight'].toString();
      });
    } catch (error) {
      print('Error fetching profile information: $error');
    }
  }

  Future<void> _fetchJournal({DateTime? date}) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      final response = await supabase
          .from('journal')
          .select('*')
          .eq('id', userId)
          .order('created_at', ascending: false);

      final data = response as List<Map<String, dynamic>>;

      setState(() {
        _journalEntries.clear();
        if (date != null) {
          _journalEntries.addAll(data.where((entry) {
            final entryDate = DateTime.parse(entry['created_at']);
            return entryDate.year == date.year &&
                entryDate.month == date.month &&
                entryDate.day == date.day;
          }));
        } else {
          _journalEntries.addAll(data);
        }
      });
    } catch (error) {
      print("Error fetching journal entries: $error");
    }
  }

  Future<void> _addJournalEntry() async {
    final userId = supabase.auth.currentUser?.id;
    final uuid = Uuid().v4();
    final entryDate = _selectedDate ?? DateTime.now();

    try {
      final response = await supabase.from('journal').insert({
        'id': userId,
        'entry_id': uuid,
        'entry': _journalController.text,
        'created_at': entryDate.toIso8601String(),
      }).select().single();

      setState(() {
        _journalEntries.insert(0, response as Map<String, dynamic>);
        _journalController.clear();
      });
    } catch (error) {
      print('Error adding journal entry: $error');
    }
  }

  Future<void> _editJournalEntry(String entryId, String newEntry) async {
    try {
      final response = await supabase
          .from('journal')
          .update({'entry': newEntry})
          .eq('entry_id', entryId)
          .select()
          .single();

      setState(() {
        final index = _journalEntries.indexWhere((entry) => entry['entry_id'] == entryId);
        _journalEntries[index] = response as Map<String, dynamic>;
      });
    } catch (error) {
      print('Error editing journal entry: $error');
    }
  }

  Future<void> _deleteJournalEntry(String entryId) async {
    try {
      await supabase
          .from('journal')
          .delete()
          .eq('entry_id', entryId);

      setState(() {
        _journalEntries.removeWhere((entry) => entry['entry_id'] == entryId);
      });
    } catch (error) {
      print('Error deleting journal entry: $error');
    }
  }

  String _formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    return DateFormat('yyyy-MM-dd').format(parsedDate);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _fetchJournal(date: picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayedDate = _selectedDate ?? DateTime.now();
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 25.0,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10.0,
                        spreadRadius: 5.0,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hi, " + widget.personName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 30,
                            ),
                          ),
                          const SizedBox(height: 7),
                          const Text(
                            "Welcome back",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: const Icon(Icons.person),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const SettingPage()),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_height != null && _weight != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10.0,
                          spreadRadius: 5.0,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Height: $_height cm",
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Weight: $_weight kg",
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10.0,
                        spreadRadius: 5.0,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Journal",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                          TextButton(
                            onPressed: () => _selectDate(context),
                            child: const Text('Select Date'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Selected Date: ${DateFormat('E, d MMM').format(displayedDate)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _journalController,
                        decoration: const InputDecoration(
                          labelText: 'New Journal Entry',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _addJournalEntry,
                        child: const Text('Add Entry'),
                      ),
                      const SizedBox(height: 20),
                      if (_journalEntries.isNotEmpty) ...[
                        const Text(
                          'Entries',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _journalEntries.length,
                          itemBuilder: (context, index) {
                            final entry = _journalEntries[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              child: ListTile(
                                title: Text(entry['entry']),
                                subtitle: Text(_formatDate(entry['created_at'])),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        _journalController.text = entry['entry'];
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text('Edit Entry'),
                                              content: TextField(
                                                controller: _journalController,
                                                decoration: const InputDecoration(
                                                  labelText: 'Edit Journal Entry',
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    _editJournalEntry(entry['entry_id'], _journalController.text);
                                                    _journalController.clear(); // Clear the controller here
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Save'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        _deleteJournalEntry(entry['entry_id']);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

