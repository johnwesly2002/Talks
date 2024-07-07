import 'package:Talks/utils/themeColor.dart';
import 'package:flutter/material.dart';

import '../utils/textFeilds_styles.dart';

class LoginTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final Widget iconName;
  const LoginTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.validator,
      required this.obscureText,
      required this.iconName});

  @override
  State<LoginTextField> createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<LoginTextField> {
  bool _showPassword = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: themeColor.TextFieldColor,
      ),
      child: TextFormField(
        validator: widget.validator,
        controller: widget.controller,
        obscureText: _showPassword ? false : widget.obscureText,
        decoration: InputDecoration(
          icon: widget.iconName,
          hintText: widget.hintText,
          hintStyle: ThemTextStyles.LoginTextStyles,
          border: InputBorder.none,
          suffixIcon: widget.obscureText
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                  icon: Icon(
                      _showPassword ? Icons.visibility : Icons.visibility_off),
                )
              : null,
        ),
      ),
    );
  }
}
