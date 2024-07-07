import 'dart:async';
import 'dart:typed_data';

import 'package:Talks/modals/messagesModal.dart';
import 'package:Talks/services/firebase_StorageService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseFirestoreService {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static Future<void> addTextMessage({
    required String content,
    required String receiverId,
  }) async {
    final message = Messages(
        senderId: FirebaseAuth.instance.currentUser!.uid,
        receiverId: receiverId,
        content: content,
        sentTime: DateTime.now(),
        messageType: MessageType.text);
    await _addMessageToChat(receiverId, message);
  }

  static Future<void> _addMessageToChat(
    String receiverId,
    Messages message,
  ) async {
    await firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chat')
        .doc(receiverId)
        .collection("messages")
        .add(message.toJson());
    await firestore
        .collection('users')
        .doc(receiverId)
        .collection('chat')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("messages")
        .add(message.toJson());
  }

  static Future<void> addImageMessage({
    required String receiverId,
    required Uint8List file,
  }) async {
    print('File in Firebase service ${file}');
    final image = await FirebaseStorageService.uploadImage(
        file, 'image/chat/${DateTime.now().microsecondsSinceEpoch}');
    print("image: ${image}");
    if (image != null) {
      final message = Messages(
          senderId: FirebaseAuth.instance.currentUser!.uid,
          receiverId: receiverId,
          content: image,
          sentTime: DateTime.now(),
          messageType: MessageType.image);
      await _addMessageToChat(receiverId, message);
    } else {
      print('Error: imageUrl is null');
    }
  }

  static Future<void> updateUserInformation(Map<String, dynamic> data) async =>
      await firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update(data);
  static Future<void> UserRegistration(
          Map<String, dynamic> data, String uid) async =>
      await firestore.collection('users').doc(uid).set(data);
}
