import "package:Talks/modals/chatMessageEntity.dart";
import "package:Talks/modals/chatUserModal.dart";
import "package:Talks/services/firebase_Firestore_service.dart";
import "package:Talks/services/firebase_Service.dart";
import "package:Talks/services/pushNotification_service.dart";
import "package:Talks/utils/textFeilds_styles.dart";
import "package:Talks/widgets/chatMessages.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:Talks/widgets/ChatInput.dart";
import "package:provider/provider.dart";

class ChatPage extends StatefulWidget {
  ChatPage({
    super.key,
    required this.userId,
    required this.userName,
  });
  final String userId;
  final String? userName;
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  List<ChatMessageEntity> _messages = [];
  late FirebaseProvider _firebaseProvider;
  String CurrentUserId = FirebaseAuth.instance.currentUser!.uid;
  final notificationService = NotificationsService();
  messageSent(ChatMessageEntity entity) {
    _messages.add(entity);
    print("addMessages${_messages}");
  }

  void initState() {
    notificationService.firebaseNotification(context);
    _firebaseProvider = Provider.of<FirebaseProvider>(context, listen: false);
    _firebaseProvider.getUserMessages(widget.userId);
    _firebaseProvider.getUserById(widget.userId);
    _firebaseProvider.markMessagesAsRead(CurrentUserId, widget.userId);
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addObserver(this);
    super.dispose();
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
          {'isOnline': false},
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
              user: widget.userName,
            ),
          ],
        ));
  }

  AppBar _buildChatAppBar() => AppBar(
      backgroundColor: Colors.transparent,
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
                        style: ThemTextStyles.ChatUserName(context),
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
