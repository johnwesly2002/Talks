import "package:Talks/modals/chatMessageEntity.dart";
import "package:Talks/services/auth_Service.dart";
import "package:Talks/widgets/imagePicker.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:Talks/utils/themeColor.dart";
import "package:provider/provider.dart";

class ChatInput extends StatefulWidget {
  final Function(ChatMessageEntity) onSubmit;
  ChatInput({super.key, required this.onSubmit});

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  String _selectedImage = '';
  final chatMessageController = TextEditingController();

  ChatFunction() async {
    String? loginUserName = await context.read<AuthService>().getUsername();
    print(chatMessageController.text);
    final newChatMessage = ChatMessageEntity(
        text: chatMessageController.text,
        id: '123',
        createdAt: DateTime.now().millisecondsSinceEpoch,
        author: Author(userName: loginUserName!));

    if (_selectedImage.isNotEmpty) {
      newChatMessage.imageUrl = _selectedImage;
    }
    widget.onSubmit(newChatMessage);

    chatMessageController.clear();
    _selectedImage = '';
    setState(() {});
  }

  void ImagePicked(String Image) {
    setState(() {
      _selectedImage = Image;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: NetworkImagePicker(
                        ImageSelected: ImagePicked,
                      ),
                    );
                  });
            },
            icon: Icon(Icons.add),
            color: themeColor.chatInputIconsColor,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                minLines: 1,
                controller: chatMessageController,
                textCapitalization: TextCapitalization.sentences,
                style: TextStyle(color: themeColor.chatInputColor),
                decoration: InputDecoration(
                  hintText: 'Type your message',
                  hintStyle: TextStyle(color: themeColor.chatInputColor),
                  border: InputBorder.none,
                ),
              ),
              if (_selectedImage.isNotEmpty)
                Image.network(
                  _selectedImage,
                  height: 50,
                ),
            ],
          )),
          IconButton(
            onPressed: ChatFunction,
            icon: Icon(Icons.send),
            color: themeColor.chatInputIconsColor,
          ),
        ],
      ),
      decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
    );
  }
}
