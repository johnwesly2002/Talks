import 'package:Talks/utils/themeColor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemTextStyles {
  static TextStyle LoginTextStyles =
      GoogleFonts.poppins(textStyle: TextStyle(color: Colors.blueGrey));
  static TextStyle HeadingStyles = GoogleFonts.poppins(
      textStyle:
          const TextStyle(color: Colors.black, fontWeight: FontWeight.w500));
  static TextStyle SingupAccountHeadingStyles = GoogleFonts.poppins(
      textStyle: TextStyle(
          fontWeight: FontWeight.w400, color: themeColor.primaryColor));
  static TextStyle SignupHeading = GoogleFonts.poppins(
      textStyle: TextStyle(
          fontWeight: FontWeight.w800, color: themeColor.primaryColor));
  static TextStyle RegistrationText = GoogleFonts.poppins(
      textStyle: TextStyle(
          fontWeight: FontWeight.w300, color: themeColor.chatInputIconsColor));

  static TextStyle RegistrationUserText = GoogleFonts.poppins(
      textStyle: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 20,
          color: themeColor.chatInputIconsColor));
  static TextStyle EmptyChatText = GoogleFonts.poppins(
      textStyle: TextStyle(
          fontWeight: FontWeight.w400, fontSize: 20, color: Colors.black));
  static TextStyle userSearchText = GoogleFonts.poppins(
      textStyle: TextStyle(
          fontWeight: FontWeight.w500, fontSize: 20, color: Colors.black));
  static TextStyle MenuOptionsText = GoogleFonts.poppins(
      textStyle: TextStyle(
          fontWeight: FontWeight.w500, fontSize: 15, color: Colors.black));
  static TextStyle homePageUsersText = GoogleFonts.poppins(
      textStyle: TextStyle(
          fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black));
  static TextStyle lastSeenText = GoogleFonts.poppins(
      textStyle: TextStyle(
          fontWeight: FontWeight.w300, fontSize: 12, color: themeColor.grey));
}
