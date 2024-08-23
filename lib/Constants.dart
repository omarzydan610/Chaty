import 'package:flutter/material.dart';

const Color KPrimaryColor = Color(0xff2C6778);
const Color KSecColor = Color(0xff006D77);
final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');

final ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blue,
  scaffoldBackgroundColor: Colors.white,
  cardColor: Colors.white,
);

final ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.blue,
  scaffoldBackgroundColor: const Color(0xff141218),
  cardColor: Colors.black,
);
