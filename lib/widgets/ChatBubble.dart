import "package:Talks/modals/chatMessageEntity.dart";
import "package:Talks/modals/messagesModal.dart";
import "package:Talks/services/auth_Service.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:provider/provider.dart";
import 'package:timeago/timeago.dart' as timeago;

class ChatBubble extends StatelessWidget {
  final Messages entity;
  final alignment;
  final CurrentUser;
  final isImage;
  const ChatBubble(
      {super.key,
      required this.alignment,
      required this.entity,
      required this.CurrentUser,
      required this.isImage});
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: CurrentUser
                ? Theme.of(context).primaryColor
                : Color.fromARGB(88, 158, 158, 158),
            borderRadius: BorderRadius.only(
              topLeft: CurrentUser ? Radius.circular(30) : Radius.circular(0),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
              topRight: CurrentUser ? Radius.circular(0) : Radius.circular(30),
            )),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${entity.content}',
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      fontSize: 15,
                      color: CurrentUser ? Colors.white : Colors.black)),
            ),
            if (isImage)
              Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                decoration: BoxDecoration(
                    image:
                        DecorationImage(image: NetworkImage(entity.content!)),
                    borderRadius: BorderRadius.circular(30)),
              ),
            Column(
              children: [
                Text(
                  timeago.format(entity.sentTime),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 7,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
