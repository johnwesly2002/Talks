import "package:Talks/modals/chatUserModal.dart";
import "package:Talks/modals/messagesModal.dart";
import "package:Talks/services/firebase_Firestore_service.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import 'package:flutter/material.dart';

class FirebaseProvider extends ChangeNotifier {
  ScrollController scrollController = ScrollController();
  List<ChatUserModal> users = [];
  List<ChatUserModal> searchUsers = [];
  List<ChatUserModal> conversationUsers = [];
  ChatUserModal? user;
  List<Messages> messages = [];

  FirebaseProvider() {
    // Initialize listeners or perform initial setup here
    startListeningForMessages();
  }

  void startListeningForMessages() {
    final currentUserUid = FirebaseAuth.instance.currentUser!.uid;

    // Listen for changes in the chat collection of the current user
    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserUid)
        .collection('chat')
        .snapshots()
        .listen((querySnapshot) async {
      users.clear(); // Clear existing list to avoid duplicates

      // Iterate through each conversation (document) in the chat collection
      for (var doc in querySnapshot.docs) {
        final otherUserId = doc.id;

        // Check if there are messages exchanged between current user and this user
        bool conversationExists =
            await checkConversationExists(currentUserUid, otherUserId);

        if (conversationExists) {
          // Fetch user details and add to users list
          FirebaseFirestore.instance
              .collection('users')
              .doc(otherUserId)
              .get()
              .then((userDoc) {
            if (userDoc.exists) {
              users.add(ChatUserModal.fromJson(userDoc.data()!));
            }
          });
        }
        notifyListeners();
      }
    });
  }

  static Future<ChatUserModal> getCurrentUser(String currentUserId) async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .get();
    print("userDoc ${userDoc.data()}");
    return ChatUserModal.fromJson(userDoc.data() as Map<String, dynamic>);
  }

  Future<List<ChatUserModal>> getAllUsers(String currentUserId) async {
    try {
      final QuerySnapshot usersSnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      users.clear();
      // Iterate through each user document
      for (var userDoc in usersSnapshot.docs) {
        final userData = userDoc.data() as Map<String, dynamic>;
        final userId = userDoc.id;

        // Check if there are messages exchanged between current user and this user
        final conversationExists =
            await checkConversationExists(currentUserId, userId);

        if (conversationExists) {
          // Add user to the list if a conversation exists
          users.add(ChatUserModal.fromJson(userData));
        }
      }
      notifyListeners();
      return users;
    } catch (error) {
      print("Error in fetching users: $error");
      return [];
    }
  }

  Future<bool> checkConversationExists(
      String currentUserId, String otherUserId) async {
    try {
      final QuerySnapshot messagesSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .collection('chat')
          .doc(otherUserId)
          .collection('messages')
          .get();
      return messagesSnapshot.docs.isNotEmpty;
    } catch (error) {
      print("Error checking conversation: $error");
      return false;
    }
  }

  ChatUserModal? getUserById(String userId) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots(includeMetadataChanges: true)
        .listen((user) {
      this.user = ChatUserModal.fromJson(user.data()!);
      notifyListeners();
    });
    return user;
  }

  List<Messages> getUserMessages(String receiverId) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chat')
        .doc(receiverId)
        .collection('messages')
        .orderBy('sentTime', descending: false)
        .snapshots(includeMetadataChanges: true)
        .listen((messagesSnapshot) {
      messages.clear();
      this.messages = messagesSnapshot.docs
          .map((doc) => Messages.fromJson(doc.data()))
          .toList();
      notifyListeners();
      chatScrollDown();
    });
    return messages;
  }

  void chatScrollDown() => WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        }
      });

  Future<void> SearchUser(String name) async {
    searchUsers = await FirebaseFirestoreService.UserSearch(name);
    notifyListeners();
  }
}
