import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:helloworld/widgets/ChatBubble.dart";
import "package:helloworld/widgets/ChatInput.dart";

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(appBar: AppBar(
      title: Center(child: Text('John'),),
      actions: [
        IconButton(onPressed: () {
          print("Logout button Pressed");
        }, icon: Icon(Icons.logout))
      ],
    ), body:
     Column(
       children: [
         Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: ListView.builder( itemCount: 10,itemBuilder: (context, index){
            return ChatBubble( alignment: index % 2 == 0 ? Alignment.centerLeft: Alignment.centerRight , message: 'Hi! hello i am John');
          }),
         ),
          ChatInput(),
       ],
     )
    
    );
  }
}