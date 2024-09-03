import 'package:flutter/material.dart';
import 'package:ui/main.dart';

class StaxUi extends StatefulWidget {
  const StaxUi({super.key});

  @override
  State<StatefulWidget> createState() {
    return StaxUiState();
  }
}

class StaxUiState extends State<StaxUi> {
  String logText = '';
  String consoleText = '';
  late TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  const Spacer(),
                  SingleChildScrollView(
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: SelectableText(
                        consoleText,
                        style: const TextStyle(
                          fontSize: fontSize,
                        ),
                      ),
                    ),
                  ),
                  TextField(
                    controller: controller,
                    style: const TextStyle(
                      fontSize: fontSize,
                    ),
                  ),
                ],
              ),
            ),
            SelectableText(
              logText,
              style: const TextStyle(
                fontSize: fontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
