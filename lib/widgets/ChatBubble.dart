import "package:Talks/modals/messagesModal.dart";
import "package:Talks/utils/themeColor.dart";
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
    return Column(
      crossAxisAlignment:
          CurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Align(
          alignment: alignment,
          child: IntrinsicWidth(
            child: Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75),
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(left: 10, right: 10, bottom: 2),
              decoration: BoxDecoration(
                color: CurrentUser
                    ? Colors.deepPurple
                    : const Color.fromARGB(88, 158, 158, 158),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft:
                      CurrentUser ? const Radius.circular(20) : Radius.zero,
                  bottomRight:
                      CurrentUser ? Radius.zero : const Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CurrentUser
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    if (!isImage)
                      Text(
                        entity.content,
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: 15,
                            color: CurrentUser
                                ? Colors.white
                                : themeColor.attachIconColor(context),
                          ),
                        ),
                      ),
                    if (isImage)
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: 200,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(entity.content),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          child: Row(
            mainAxisAlignment:
                CurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Text(
                timeago.format(entity.sentTime),
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 10,
                ),
              ),
              if (CurrentUser) // Show check icon only for receiver
                SizedBox(width: 5),
              CurrentUser
                  ? Icon(
                      entity.isRead ? Icons.done_all : Icons.check,
                      color: entity.isRead ? Colors.blue : Colors.grey,
                      size: 18,
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ],
    );
  }
}
