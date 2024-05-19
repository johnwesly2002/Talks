import 'package:flutter/material.dart';

import '../utils/textFeilds_styles.dart';

class LoginTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final FormFieldValidator<String>? validator;
  final  bool  obscureText;
  const LoginTextField({super.key, required this.controller, required this.hintText, required this.validator, required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: '$hintText',
        hintStyle: ThemTextStyles.LoginTextStyles,
        border: OutlineInputBorder(),
      ),
    );
  }
}