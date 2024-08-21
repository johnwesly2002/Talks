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
    // startListeningForMessages();
  }

  static Future<ChatUserModal> getCurrentUser(String currentUserId) async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .get();
    print("userDoc ${userDoc.data()}");
    return ChatUserModal.fromJson(userDoc.data() as Map<String, dynamic>);
  }

  Future<void> getAllUsers(String currentUserId) async {
    try {
      final Map<String, ChatUserModal> usersMap = {};

      // Step 1: Fetch users who have a conversation with the current user
      FirebaseFirestore.instance
          .collection('users')
          .snapshots()
          .listen((usersSnapshot) async {
        for (var userDoc in usersSnapshot.docs) {
          final userData = userDoc.data();
          final userId = userDoc.id;

          if (userId != currentUserId) {
            // Check if there are messages exchanged between the current user and this user
            final conversationExists =
                await checkConversationExists(currentUserId, userId);

            if (conversationExists) {
              // Add or update user in the map
              usersMap[userId] = ChatUserModal.fromJson(userData);

              // Step 2: Listen for changes in the specific conversation
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(currentUserId)
                  .collection('chat')
                  .doc(userId)
                  .collection('messages')
                  .snapshots()
                  .listen((messageSnapshot) async {
                if (messageSnapshot.docs.isNotEmpty) {
                  // Check if the user already exists in the map before notifying listeners
                  if (usersMap.containsKey(userId)) {
                    notifyListeners();
                  } else {
                    final userDoc = await FirebaseFirestore.instance
                        .collection('users')
                        .doc(userId)
                        .get();
                    final userData = userDoc.data();
                    usersMap[userId] = ChatUserModal.fromJson(userData!);
                    notifyListeners();
                  }
                }
              });

              // Step 3: Listen for online status changes in real-time
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(userId)
                  .snapshots()
                  .listen((userSnapshot) {
                if (userSnapshot.exists) {
                  final updatedUserData = userSnapshot.data();
                  if (updatedUserData != null) {
                    // Update only the online status and other details without duplicating
                    usersMap[userId] = ChatUserModal.fromJson(updatedUserData);
                    notifyListeners();
                  }
                }
              });
            }
          }
        }

        // Step 4: After processing all users, update the list from the map
        users.clear();
        users.addAll(usersMap.values.toList());
        notifyListeners();
      });
    } catch (error) {
      print("Error in fetching users: $error");
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
        .snapshots()
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
      messages = messagesSnapshot.docs
          .map((doc) => Messages.fromJson(doc.data()))
          .toList();
      chatScrollDown();
      notifyListeners();
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

  //Get the unreadMessages
  Future<int> getUnreadMessagesCount(
      String currentUserId, String otherUserId) async {
    try {
      final QuerySnapshot unreadMessagesSnapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(currentUserId)
          .collection('chat')
          .doc(otherUserId)
          .collection('messages')
          .where('isRead', isEqualTo: false)
          .get();
      print(
          "getting unread messages count: ${unreadMessagesSnapshot.docs.length}");
      return unreadMessagesSnapshot.docs.length;
    } catch (error) {
      print("Error getting unread messages count: $error");
      return 0;
    }
  }

  Stream<int> getUnreadMessageCountStream(
      String currentUserId, String otherUserId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('chat')
        .doc(otherUserId)
        .collection('messages')
        .where('isRead', isEqualTo: false)
        .where('senderId', isEqualTo: otherUserId)
        .snapshots()
        .map((snapshot) {
      print("Snapshot length for $otherUserId: ${snapshot.docs.length}");
      for (var doc in snapshot.docs) {
        print("Message ID: ${doc.id}, isRead: ${doc['isRead']}");
      }
      return snapshot.docs.length;
    });
  }

  Future<void> markMessagesAsRead(
      String CurrentUserId, String otherUserId) async {
    final batch = FirebaseFirestore.instance.batch();
    final messagesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(CurrentUserId)
        .collection('chat')
        .doc(otherUserId)
        .collection('messages')
        .where('isRead', isEqualTo: false)
        .where('senderId', isEqualTo: otherUserId);

    final snapshot = await messagesRef.get();

    for (var doc in snapshot.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
  }
}
