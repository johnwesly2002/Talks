import 'package:Talks/services/firebase_Service.dart';
import 'package:Talks/utils/themeColor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/textFeilds_styles.dart';

class UserSearchWidget extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Widget iconName;
  const UserSearchWidget(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obscureText,
      required this.iconName});

  @override
  State<UserSearchWidget> createState() => _UserSearchWidgetState();
}

class _UserSearchWidgetState extends State<UserSearchWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(21),
          color: themeColor.TextFieldColor,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: TextFormField(
            controller: widget.controller,
            obscureText: false,
            onChanged: (val) =>
                Provider.of<FirebaseProvider>(context, listen: false)
                    .SearchUser(val),
            decoration: InputDecoration(
              icon: widget.iconName,
              hintText: widget.hintText,
              hintStyle: ThemTextStyles.LoginTextStyles,
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
