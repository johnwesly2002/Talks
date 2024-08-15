import "package:Talks/modals/messagesModal.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
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
      child: IntrinsicWidth(
        child: Container(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: CurrentUser
                  ? Colors.deepPurple
                  : Color.fromARGB(88, 158, 158, 158),
              borderRadius: BorderRadius.only(
                topLeft: CurrentUser ? Radius.circular(30) : Radius.circular(0),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
                topRight:
                    CurrentUser ? Radius.circular(0) : Radius.circular(30),
              )),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CurrentUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
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
                        image: DecorationImage(
                            image: NetworkImage(entity.content)),
                        borderRadius: BorderRadius.circular(30)),
                  ),
                Row(
                  mainAxisAlignment: CurrentUser
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    Text(
                      timeago.format(entity.sentTime),
                      style: TextStyle(
                        color: CurrentUser ? Colors.white : Colors.black,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
