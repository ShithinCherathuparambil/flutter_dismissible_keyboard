import 'package:flutter/material.dart';
import 'package:flutter_dismissible_keyboard/flutter_dismissible_keyboard.dart';
import 'package:future_keyboard_kit/future_keyboard_kit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FocusNode _customKeyboardFocusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _customKeyboardFocusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Dismissible Keyboard Example')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Text Field WITH Custom Keyboard:'),
              const SizedBox(height: 8),
              DismissibleKeyboard(
                focusNode: _customKeyboardFocusNode,
                customKeyboard: Container(
                  padding: const EdgeInsets.only(bottom: 20, top: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.green],
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.1),
                        blurRadius: 10,
                        offset: Offset(0, -5),
                      ),
                    ],
                  ),
                  child: FlutterKeyboard(
                    controller: _controller,
                    layout: VirtualKeyboardLayout.alphanumeric(),
                    onSubmitted: (_) => _customKeyboardFocusNode.unfocus(),
                    style: VirtualKeyboardStyle(
                      backgroundColor: Colors.transparent,
                      keyBackgroundColor: Colors.grey.shade200,
                      keyBorderRadius: 8.0,
                      keyTextStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                child: TextField(
                  controller: _controller,
                  focusNode: _customKeyboardFocusNode,
                  keyboardType: TextInputType.none,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Tap here for custom keyboard...',
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Text Field WITHOUT Custom Keyboard (Default System Keyboard):',
              ),
              const SizedBox(height: 8),
              const TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Tap here for system keyboard...',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
