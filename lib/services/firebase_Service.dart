import "package:Talks/modals/chatUserModal.dart";
import "package:Talks/modals/messagesModal.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import 'package:flutter/material.dart';

class FirebaseProvider extends ChangeNotifier {
  ScrollController scrollController = ScrollController();
  List<ChatUserModal> users = [];
  ChatUserModal? user;
  List<Messages> messages = [];
  List<ChatUserModal> getAllUsers() {
    try {
      FirebaseFirestore.instance
          .collection('users')
          .snapshots(includeMetadataChanges: true)
          .listen((users) {
        this.users = users.docs
            .map((doc) => ChatUserModal.fromJson(doc.data()))
            .toList();
        notifyListeners();
      });
      print("user fetched: $users");
    } catch (error) {
      print("error in fetching users");
      print(error);
    }
    return users;
  }

  ChatUserModal? getUserById(String userId) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots(includeMetadataChanges: true)
        .listen((user) {
      this.user = ChatUserModal.fromJson(user.data()!);
      print("users present in db, ${user}");
      notifyListeners();
    });
    return user;
  }

  List<Messages> getUserMessages(String receiverId) {
    print(
        "firebasecurrentUserId ${FirebaseAuth.instance.currentUser!.uid}, ${receiverId}");
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chat')
        .doc(receiverId)
        .collection('messages')
        .orderBy('sentTime', descending: false)
        .snapshots(includeMetadataChanges: true)
        .listen((messages) {
      print("Messages ${messages}");
      this.messages =
          messages.docs.map((doc) => Messages.fromJson(doc.data())).toList();
      notifyListeners();
      chatScrollDown();
    });
    print("messages, ${messages}");
    return messages;
  }

  void chatScrollDown() => WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        }
      });
}
