import 'package:flutter/material.dart';
import 'package:flutter_application/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditFoodLogPage extends StatefulWidget {
  final String entryId;
  final int initialQuantity;
  final VoidCallback onUpdate;

  const EditFoodLogPage({
    Key? key,
    required this.entryId,
    required this.initialQuantity,
    required this.onUpdate,
  }) : super(key: key);

  @override
  _EditFoodLogPageState createState() => _EditFoodLogPageState();
}

class _EditFoodLogPageState extends State<EditFoodLogPage> {
  late TextEditingController _quantityController;
  late int _quantity;

  @override
  void initState() {
    super.initState();
    _quantity = widget.initialQuantity;
    _quantityController = TextEditingController(text: _quantity.toString());
  }

  Future<void> _updateQuantity() async {
    final userId = supabase.auth.currentUser?.id;

    try {
      await supabase
          .from('nutri_logging')
          .update({'quantity': _quantity})
          .eq('entry_id', widget.entryId)
          .eq('id', userId.toString());

      widget.onUpdate(); // Notify parent page to update
      Navigator.pop(context); // Return to previous page
    } catch (error) {
      print('Failed to update quantity: $error');
      // Handle error (show snackbar or dialog)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Food Log')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _quantityController,
              decoration: InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _quantity = int.tryParse(value) ?? _quantity;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateQuantity,
              child: Text('Update Quantity'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }
}
