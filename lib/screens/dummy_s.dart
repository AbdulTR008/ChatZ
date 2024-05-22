import 'package:flutter/material.dart';

import 'package:pin_code_fields/pin_code_fields.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Container(
            child: PinCodeTextField(
              appContext: context,
              length: 6, // Number of digits to enter
              obscureText: false, // Hide the entered digits
              animationType:
                  AnimationType.fade, // Animation type for entering digits
              pinTheme: PinTheme(
                // Customize the appearance of the text fields
                shape: PinCodeFieldShape
                    .box, // Shape of the text field (box, circle, underline)
                borderRadius:
                    BorderRadius.circular(5), // Border radius for box shape
                fieldHeight: 50, // Height of the text field
                fieldWidth: 40, // Width of the text field
                activeFillColor:
                    Colors.white, // Color of the text field when focused
                selectedFillColor:
                    Colors.blue, // Color of the text field when selected
              ),
              onChanged: (value) {
                print(value); // Print the entered PIN code
              },
              onCompleted: (value) {
                print(
                    "PIN completed: $value"); // Action to perform when all digits are entered
              },
            ),
          ),
        ),
      ),
    );
  }
}
