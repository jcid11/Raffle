
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const kProfileTextColor = TextStyle(color: Colors.white);
final kProfileTextMiniature = TextStyle(color: Colors.grey[700]);

const kBackgroundColorDesign = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF81d1dd),
        Color(0xFF73cbde),
        // Color(0xFFaeb6c8),
        Color(0xFF5fc2e0),
        Color(0xFF4abae4),
        Color(0xFF3ab4e4),
        Color(0xFF2B9ED2),
      ],
    ));

final kTextFormStyle = InputDecoration(
  labelText: 'Email',
  labelStyle: TextStyle(
      color: Colors.white.withOpacity(0.7),
      fontWeight: FontWeight.bold,letterSpacing: 0.5),
  contentPadding:
  EdgeInsets.symmetric(vertical: 6.0, horizontal: 0.0),
  enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
          color: Colors.white.withOpacity(0.5),
          width: 0.5)),
  focusedBorder: UnderlineInputBorder(
      borderSide:
      BorderSide(color: Colors.white, width: 1.0)),
);
const kStartingPagePadding = EdgeInsets.all(40);
const kTextFieldStyle = TextStyle(
    color: Colors.white, fontWeight: FontWeight.bold);
const kButtonPadding =  EdgeInsets.all(14.0);
const kButtonPaddingRegister =  EdgeInsets.all(10.0);
const kButtonRadius =  BorderRadius.all(Radius.circular(12.0));
const kButtonRadiusRegister =  BorderRadius.all(Radius.circular(12.0));
const kButtonStyle = TextStyle(
    color: Color(0xff2fa1c9),
    fontWeight: FontWeight.bold,
    fontSize: 14,
    letterSpacing: 1);
const kBottomNavigationBarColor = Color(0xFF2B9ED2);