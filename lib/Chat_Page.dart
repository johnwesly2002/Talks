import "dart:convert";

import "package:Talks/modals/chatMessageEntity.dart";
import "package:Talks/modals/imagesModal.dart";
import "package:Talks/repo/image_respository.dart";
import "package:Talks/services/auth_Service.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter/widgets.dart";
import "package:Talks/widgets/ChatBubble.dart";
import "package:Talks/widgets/ChatInput.dart";
import 'package:http/http.dart' as http;
import "package:provider/provider.dart";

class ChatPage extends StatefulWidget {
  ChatPage({
    super.key,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatMessageEntity> _messages = [];

  _loadMessages() async {
    final response = await rootBundle.loadString('assets/mockMessage.json');
    final List<dynamic> decodedList = jsonDecode(response) as List;
    final List<ChatMessageEntity> _chatMessages = decodedList.map((listItem) {
      return ChatMessageEntity.fromJson(listItem);
    }).toList();
    setState(() {
      _messages = _chatMessages;
    });
    print(response);
  }

  messageSent(ChatMessageEntity entity) {
    _messages.add(entity);
    setState(() {});
  }

  final ImageRepository _imageRepo = ImageRepository();

  void initState() {
    _loadMessages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final username = context.watch<AuthService>().getUsername();
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text('$username'),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  context.read<AuthService>().UpdateUserName("wesly");
                },
                icon: Icon(Icons.update)),
            IconButton(
                onPressed: () {
                  context.read<AuthService>().logoutUser();
                  Navigator.pushReplacementNamed(context, '/');
                  print("Logout button Pressed");
                },
                icon: Icon(Icons.logout))
          ],
        ),
        body: Column(
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: ListView.builder(
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return ChatBubble(
                        alignment: _messages[index].author.userName ==
                                context.read<AuthService>().getUsername()
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        entity: _messages[index]);
                  }),
            ),
            ChatInput(
              onSubmit: messageSent,
            ),
          ],
        ));
  }
}
