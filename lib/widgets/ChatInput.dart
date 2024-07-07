import "dart:io";
import "dart:typed_data";

import "package:Talks/modals/chatMessageEntity.dart";
import "package:Talks/modals/chatUserModal.dart";
import "package:Talks/modals/messagesModal.dart";
import "package:Talks/services/MediaService.dart";
import "package:Talks/services/auth_Service.dart";
import "package:Talks/services/firebase_Firestore_service.dart";
import "package:Talks/widgets/imagePicker.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:Talks/utils/themeColor.dart";
import "package:provider/provider.dart";

class ChatInput extends StatefulWidget {
  final Function(ChatMessageEntity) onSubmit;
  final String receiverId;
  ChatInput({super.key, required this.onSubmit, required this.receiverId});
  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  String _selectedImage = '';
  final chatMessageController = TextEditingController();
  Uint8List? file;
  void ImagePicked(String Image) {
    setState(() {
      _selectedImage = Image;
    });
    Navigator.of(context).pop();
  }

  Future<void> _sendText(BuildContext context) async {
    if (chatMessageController.text.isNotEmpty) {
      print("before firebase");
      await FirebaseFirestoreService.addTextMessage(
          receiverId: widget.receiverId, content: chatMessageController.text);
      print("after firebase");

      chatMessageController.clear();
      FocusScope.of(context).unfocus();
    }
    FocusScope.of(context).unfocus();
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 229, 227, 227),
          borderRadius: BorderRadius.circular(30.0),
        ),
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: _sendImage,
              icon: Icon(Icons.attach_file_rounded),
              color: themeColor.attachiconcolor,
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
                  style: TextStyle(color: themeColor.chatInputColor),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10), // Adjust padding inside TextField
                    hintText: 'Type your message',
                    hintStyle: TextStyle(
                        fontSize: 15, color: themeColor.chatInputColor),
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
                color: themeColor.chatInputIconsColor,
                style: IconButton.styleFrom(
                  backgroundColor: Colors.purple,
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
