import "package:Talks/modals/chatMessageEntity.dart";
import "package:Talks/services/auth_Service.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class ChatBubble extends StatelessWidget {
  final ChatMessageEntity entity;
  final alignment;
  const ChatBubble({super.key, required this.alignment, required this.entity});
  @override
  Widget build(BuildContext context) {
    bool isAuthor =
        entity.author.userName == context.read<AuthService>().getUsername();

    return Align(
      alignment: alignment,
      child: Container(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${entity.text}',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            if (entity.imageUrl != null)
              Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                decoration: BoxDecoration(
                    image:
                        DecorationImage(image: NetworkImage(entity.imageUrl!)),
                    borderRadius: BorderRadius.circular(30)),
              ),
          ],
        ),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: isAuthor ? Theme.of(context).primaryColor : Colors.black,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomLeft: Radius.circular(15),
            )),
      ),
    );
  }
}
