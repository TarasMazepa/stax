import 'package:flutter/material.dart';
import 'package:ui/stax_ui.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        fontFamily: 'ProtoNerd',
      ),
      home: const StaxUi(),
    ),
  );
}
