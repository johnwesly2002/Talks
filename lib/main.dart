import 'package:flutter/material.dart';
import 'package:helloworld/Chat_Page.dart';
import 'package:helloworld/Login_Page.dart';
import 'package:helloworld/StatefulEx.dart';
void main() {
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      title: 'ChatApp',
      home: LoginPage(),
    );
  }
}

