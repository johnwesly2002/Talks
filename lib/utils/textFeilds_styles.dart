import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'themeColor.dart';

class ThemTextStyles {
  static TextStyle LoginTextStyles(BuildContext context) => GoogleFonts.poppins(
      textStyle: TextStyle(color: themeColor.grey(context)));

  static TextStyle HeadingStyles(BuildContext context) => GoogleFonts.poppins(
      textStyle: TextStyle(
          color: themeColor.attachIconColor(context),
          fontWeight: FontWeight.w600,
          fontSize: 20));

  static TextStyle SingupAccountHeadingStyles(BuildContext context) =>
      GoogleFonts.poppins(
          textStyle: TextStyle(
              fontWeight: FontWeight.w400,
              color: themeColor.primaryColor(context)));

  static TextStyle signupHeading(BuildContext context) => GoogleFonts.poppins(
      textStyle: TextStyle(
          fontWeight: FontWeight.w800,
          color: themeColor.primaryColor(context)));

  static TextStyle RegistrationText(BuildContext context) =>
      GoogleFonts.poppins(
          textStyle: TextStyle(
              fontWeight: FontWeight.w300,
              color: themeColor.chatInputIconsColor(context)));

  static TextStyle registrationUserText(BuildContext context) =>
      GoogleFonts.poppins(
          textStyle: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 20,
              color: themeColor.chatInputIconsColor(context)));

  static TextStyle emptyChatText(BuildContext context) => GoogleFonts.poppins(
      textStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 20,
          color: themeColor.attachIconColor(context)));

  static TextStyle userSearchText(BuildContext context) => GoogleFonts.poppins(
      textStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20,
          color: themeColor.attachIconColor(context)));

  static TextStyle MenuOptionsText(BuildContext context) => GoogleFonts.poppins(
      textStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12,
          color: themeColor.attachIconColor(context)));

  static TextStyle homePageUsersText(BuildContext context) =>
      GoogleFonts.poppins(
          textStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: themeColor.attachIconColor(context)));

  static TextStyle lastSeenText(BuildContext context) => GoogleFonts.poppins(
      textStyle: TextStyle(
          fontWeight: FontWeight.w300,
          fontSize: 12,
          color: themeColor.grey(context)));

  static TextStyle profileNameText(BuildContext context) => GoogleFonts.poppins(
      textStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 20,
          color: themeColor.attachIconColor(context)));

  static TextStyle ProfileEditText(BuildContext context) => GoogleFonts.poppins(
      textStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 10,
          color: themeColor.chatInputIconsColor(context)));

  static TextStyle ProfileEmailText(BuildContext context) =>
      GoogleFonts.poppins(
          textStyle: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 11,
              color: themeColor.grey(context)));

  static TextStyle ProfileSaveText(BuildContext context) => GoogleFonts.poppins(
      textStyle: TextStyle(
          fontWeight: FontWeight.w500,
          color: themeColor.chatInputIconsColor(context)));

  static TextStyle ButtonsTextStyle(BuildContext context) =>
      GoogleFonts.poppins(
          textStyle: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: themeColor.attachIconColor(context)));

  static TextStyle WebEmptyChat(BuildContext context) => GoogleFonts.poppins(
      textStyle: TextStyle(
          color: themeColor.grey(context),
          fontWeight: FontWeight.w500,
          fontSize: 20));
  static TextStyle ChatUserName(BuildContext context) => GoogleFonts.poppins(
      textStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: themeColor.attachIconColor(context)));
  static TextStyle ProfileHeading(BuildContext context) => GoogleFonts.poppins(
      textStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: themeColor.attachIconColor(context)));
  static TextStyle LogoutButtonsStyle(BuildContext context) =>
      GoogleFonts.poppins(
          textStyle: const TextStyle(
              fontWeight: FontWeight.w500, fontSize: 13, color: Colors.white));
}
