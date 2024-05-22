import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  const InputField({
    super.key,
    required this.input,
    this.prefixText,

    required this.inputLabel,
    required this.icon,
    this.keyBoardType,
    required this.obscureText,
    required this.validator,
    // required this.onSaved
  });

  final TextEditingController input;
  final String inputLabel;
  final String? prefixText;
  final IconData icon;
  final TextInputType? keyBoardType;
  final bool obscureText;
  final String? Function(String?) validator;
  // final String? Function(String?) onSaved;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        
        validator: validator,
        // onSaved: onSaved,
        autocorrect: false,
        textCapitalization: TextCapitalization.none,
        obscureText: obscureText,
        controller: input,
        keyboardType: keyBoardType,
        decoration: InputDecoration(
          prefixText: prefixText,
          prefixIcon: Icon(icon),
          label: Text(inputLabel),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
