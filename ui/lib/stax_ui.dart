import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ui/main.dart';

class StaxUi extends StatefulWidget {
  const StaxUi({super.key});

  @override
  State<StatefulWidget> createState() {
    return StaxUiState();
  }
}

class StaxUiState extends State<StaxUi> {
  String logText =
      'cd to any folder under git version control to see \'stax log\'';
  String consoleText = '';
  late TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CallbackShortcuts(
        bindings: {
          LogicalKeySet(LogicalKeyboardKey.enter): () {
            setState(() {
              consoleText += '\n${controller.text}';
              controller.clear();
            });
          },
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                flex: 2,
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
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: SelectableText(
                  logText,
                  style: const TextStyle(
                    fontSize: fontSize,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
