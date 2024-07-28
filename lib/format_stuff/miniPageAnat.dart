import 'package:flutter/material.dart';

class MiniPageDialog extends StatelessWidget {
  final String boxText;
  final String miniPageText;
  final String imagePath;

  const MiniPageDialog({
    Key? key,
    required this.boxText,
    required this.miniPageText,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 600, 
        ),
        child: Container(
          padding: EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).pop(); 
                    },
                  ),
                  Expanded(
                    child: Text(
                      boxText,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Text(
                miniPageText,
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


