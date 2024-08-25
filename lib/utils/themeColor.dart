import 'package:flutter/material.dart';

class themeColor {
  static Color chatInputColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.grey.shade800
          : Colors.grey;

  static Color chatInputIconsColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.white70
          : Colors.white;

  static Color primaryColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.deepPurpleAccent
          : Colors.deepPurple;

  static Color TextFieldColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.grey.shade700.withOpacity(.5)
          : Colors.grey.withOpacity(.2);

  static Color statusColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.lightGreen
          : Colors.green;

  static Color attachIconColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.white
          : Colors.black;

  static Color grey(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.grey.shade600
          : Colors.grey;

  static Color chatInputText(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.white70
          : Colors.grey;
  static Color chatInputContainer(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? themeColor.TextFieldColor(context).withOpacity(0.1)
          : Colors.grey.shade200;
}
