import "package:Talks/modals/chatMessageEntity.dart";
import "package:Talks/services/firebase_Firestore_service.dart";
import "package:Talks/services/firebase_Service.dart";
import "package:Talks/widgets/chatMessages.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:Talks/widgets/ChatInput.dart";
import "package:provider/provider.dart";

class webChatPage extends StatefulWidget {
  webChatPage({
    super.key,
    required this.userId,
  });
  final String userId;

  @override
  State<webChatPage> createState() => _webChatPageState();
}

class _webChatPageState extends State<webChatPage> with WidgetsBindingObserver {
  List<ChatMessageEntity> _messages = [];
  String CurrentUserId = FirebaseAuth.instance.currentUser!.uid;
  messageSent(ChatMessageEntity entity) {
    _messages.add(entity);
  }

  // void initState() {
  //   Provider.of<FirebaseProvider>(context, listen: false)
  //     ..getUserById(widget.userId)
  //     ..getUserMessages(widget.userId);
  //   WidgetsBinding.instance.addObserver(this);
  //   super.initState();
  // }

  @override
  void initState() {
    super.initState();
    _loadMessagesAndUser();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addObserver(this);
    super.dispose();
  }

  @override
  void didUpdateWidget(webChatPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userId != widget.userId) {
      _loadMessagesAndUser();
    }
  }

  void _loadMessagesAndUser() {
    Provider.of<FirebaseProvider>(context, listen: false)
      ..getUserById(widget.userId)
      ..getUserMessages(widget.userId);
    Provider.of<FirebaseProvider>(context)
        .markMessagesAsRead(CurrentUserId, widget.userId);
    setState(() {});
  }

  void didChangeAppLifeCycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        FirebaseFirestoreService.updateUserInformation(
          {'lastActive': DateTime.now(), 'isOnline': true},
        );
        break;
      case AppLifecycleState.detached:
        FirebaseFirestoreService.updateUserInformation(
          {'isOnline': true},
        );
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildChatAppBar(),
        body: Column(
          children: [
            chatMessages(
              userId: widget.userId,
            ),
            ChatInput(
              onSubmit: messageSent,
              receiverId: widget.userId,
            ),
          ],
        ));
  }

  AppBar _buildChatAppBar() => AppBar(
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      title: Consumer<FirebaseProvider>(
        builder: (context, value, child) => value.user != null
            ? Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(value.user!.image),
                    radius: 20,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    children: [
                      Text(
                        value.user!.name,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(value.user!.isOnline ? 'online' : 'offline',
                          style: TextStyle(
                            color: value.user!.isOnline
                                ? Colors.green
                                : Colors.red,
                            fontSize: 14,
                          ))
                    ],
                  )
                ],
              )
            : const SizedBox(),
      ));
}
