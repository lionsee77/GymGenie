import 'package:flutter/material.dart';

const kBackgroundColor = Colors.black;
const kTextFieldFill = Color(0xff1E1C24);

const kHeadline = TextStyle(
  color: Colors.white,
  fontSize: 34,
  fontWeight: FontWeight.bold,
);

const kBodyText = TextStyle(
  color: Colors.grey,
  fontSize: 15,
);

const kButtonText = TextStyle(
  color: Colors.black87,
  fontSize: 16,
  fontWeight: FontWeight.bold,
);

const kBodyText2 =
    TextStyle(fontSize: 28, fontWeight: FontWeight.w500, color: Colors.white);

var bodyButtonStyle = ElevatedButton.styleFrom(
  shape: ContinuousRectangleBorder(),
  backgroundColor: Colors.transparent,
  shadowColor: Colors.transparent,
  //uncomment to see the buttons on anat page
  // backgroundColor: Colors.white,
  // shadowColor: Colors.white, 
);