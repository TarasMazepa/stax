import 'package:flutter/material.dart';
import 'package:ui/stax_ui.dart';

const double fontSize = 16;

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        fontFamily: 'ProtoNerd',
      ),
      home: StaxUi(),
    ),
  );
}
