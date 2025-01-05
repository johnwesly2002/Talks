import "dart:typed_data";

import "package:Talks/modals/chatMessageEntity.dart";
import "package:Talks/services/MediaService.dart";
import "package:Talks/services/firebase_Firestore_service.dart";
import "package:Talks/services/pushNotification_service.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:Talks/utils/themeColor.dart";

class ChatInput extends StatefulWidget {
  final Function(ChatMessageEntity) onSubmit;
  final String receiverId;
  final String? user;
  ChatInput(
      {super.key,
      required this.onSubmit,
      required this.receiverId,
      required this.user});
  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final chatMessageController = TextEditingController();
  static final notificationService = NotificationsService();
  Uint8List? file;
  void ImagePicked(String Image) {
    setState(() {});
    Navigator.of(context).pop();
  }

  void initState() {
    notificationService.getReceiverToken(widget.receiverId);
    super.initState();
  }

  Future<void> _sendText(BuildContext context) async {
    if (chatMessageController.text.isNotEmpty) {
      final messageText = chatMessageController.text;
      chatMessageController.clear();

      await FirebaseFirestoreService.addTextMessage(
          receiverId: widget.receiverId, content: messageText);
      await notificationService.sendNotification(
          body: messageText,
          senderId: FirebaseAuth.instance.currentUser!.uid,
          sender: widget.user);
    }
    // FocusScope.of(context).unfocus();
  }

  Future<void> _sendImage() async {
    final pickImage = await MediaService.pickImage();
    setState(() => file = pickImage);
    if (file != null) {
      print("file: ${file}");
      await FirebaseFirestoreService.addImageMessage(
        receiverId: widget.receiverId,
        file: file!,
      );
      await notificationService.sendNotification(
          body: 'Image',
          senderId: FirebaseAuth.instance.currentUser!.uid,
          sender: widget.user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: themeColor.chatInputContainer(context),
          borderRadius: BorderRadius.circular(30.0),
        ),
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: _sendImage,
              icon: Icon(Icons.attach_file_rounded),
              color: themeColor.chatInputText(context),
            ),
            Expanded(
              child: Container(
                height: 40,
                margin: EdgeInsets.only(right: 8),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 1,
                  controller: chatMessageController,
                  textCapitalization: TextCapitalization.sentences,
                  style: TextStyle(color: themeColor.attachIconColor(context)),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    hintText: 'Type your message',
                    hintStyle: TextStyle(
                        fontSize: 15, color: themeColor.chatInputText(context)),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 7),
              child: IconButton(
                onPressed: () => _sendText(context),
                icon: const Icon(Icons.send),
                color: Colors.white,
                style: IconButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(8.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
