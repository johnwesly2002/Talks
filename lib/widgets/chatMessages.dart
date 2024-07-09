import 'package:Talks/modals/messagesModal.dart';
import 'package:Talks/services/firebase_Service.dart';
import 'package:Talks/widgets/ChatBubble.dart';
import 'package:Talks/widgets/emptyChatWidget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class chatMessages extends StatefulWidget {
  const chatMessages({super.key, required this.userId});
  final String userId;
  @override
  State<chatMessages> createState() => _chatMessagesState();
}

class _chatMessagesState extends State<chatMessages> {
  @override
  Widget build(BuildContext context) {
    return Consumer<FirebaseProvider>(
        builder: (context, value, child) => value.messages.isEmpty
            ? const Expanded(
                child: EmptyWidget(
                    icon: 'assets/EmptyChat.json', text: 'Say Hello!'),
              )
            : Expanded(
                child: ListView.builder(
                    controller:
                        Provider.of<FirebaseProvider>(context, listen: false)
                            .scrollController,
                    itemCount: value.messages.length,
                    itemBuilder: (context, index) {
                      final isTextMessage =
                          value.messages[index].messageType == MessageType.text;
                      return isTextMessage
                          ? ChatBubble(
                              alignment: widget.userId !=
                                      value.messages[index].senderId
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              entity: value.messages[index],
                              CurrentUser: widget.userId !=
                                  value.messages[index].senderId,
                              isImage: false,
                            )
                          : ChatBubble(
                              alignment: widget.userId !=
                                      value.messages[index].senderId
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              entity: value.messages[index],
                              CurrentUser: widget.userId !=
                                  value.messages[index].senderId,
                              isImage: true);
                    }),
              ));
  }
}
