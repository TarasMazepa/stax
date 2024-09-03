import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        fontFamily: 'ProtoNerd',
      ),
      home: const Scaffold(
        backgroundColor: Colors.black,
        body: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Flexible(
                    child: SelectableText('Text12'),
                  ),
                  TextField(),
                ],
              ),
            ),
            SelectableText('Text2'),
          ],
        ),
      ),
    ),
  );
}
