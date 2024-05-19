import 'package:Talks/services/auth_Service.dart';
import 'package:flutter/material.dart';
import 'package:Talks/Chat_Page.dart';
import 'package:Talks/Login_Page.dart';
import 'package:Talks/StatefulEx.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.init();
  runApp(ChangeNotifierProvider(
    create: (BuildContext context) => AuthService(),
    child: ChatApp(),
  ));
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      title: 'Talks',
      home: FutureBuilder<bool>(
          future: context.read<AuthService>().LoggedIn(),
          builder: (context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData && snapshot.data!) {
                return ChatPage();
              } else
                return LoginPage();
            }
            return CircularProgressIndicator();
          }),
      routes: {
        '/chatPage': (context) => ChatPage(),
      },
    );
  }
}
