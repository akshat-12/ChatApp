import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

PreferredSizeWidget appBarMain(BuildContext context) {
  return AppBar(
    title: Text(
      'Chat App',
      style: TextStyle(),
    ),
    backgroundColor: Color(0xFF2E33AE),
    centerTitle: true,
  );
}

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(
      color: Colors.white54,
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.white,
      ),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.white,
      ),
    ),
  );
}

TextStyle simpleTextStyle() {
  return TextStyle(
    color: Colors.white,
  );
}
