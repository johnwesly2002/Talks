import 'dart:convert';
import 'package:Talks/modals/chatUserModal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:Talks/Chat_Page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NotificationsService {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void _initLocalNotification() {
    try {
      debugPrint('Initializing local notifications...');
      const androidSettings = AndroidInitializationSettings('app_icon');
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestCriticalPermission: true,
        requestSoundPermission: true,
      );

      const initializationSettings =
          InitializationSettings(android: androidSettings, iOS: iosSettings);
      flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onDidReceiveNotificationResponse: (response) {
        if (response.payload != null) {
          debugPrint(
              "background messages in initialize ${response.payload.toString()}");
        } else {
          debugPrint("Received a null payload");
        }
      });
    } catch (e) {
      debugPrint('Error initializing notifications: $e');
    }
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    if (message.notification == null) {
      debugPrint('No notification data available');
      return; // Exit if no notification data
    }
    final styleInformation = BigTextStyleInformation(
      message.notification!.body.toString() ?? 'No body',
      htmlFormatBigText: true,
      contentTitle: message.notification!.title ?? 'No title',
      htmlFormatTitle: true,
    );
    final androidDetails = AndroidNotificationDetails(
      'com.example.helloworld',
      'mychannelid',
      channelDescription: 'Talks Messenger',
      importance: Importance.max,
      icon: 'app_icon',
      styleInformation: styleInformation,
      priority: Priority.max,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    debugPrint(' notification message ${message.data}');
    debugPrint('AndroidNotificationDetails:');
    debugPrint('Channel ID: ${androidDetails.channelId}');
    debugPrint('Channel Name: ${androidDetails.channelName}');
    debugPrint('Importance: ${androidDetails.importance}');
    debugPrint('Priority: ${androidDetails.priority}');
    debugPrint('Icon: ${androidDetails.icon}');
    debugPrint(
        'Style Information: ${androidDetails.styleInformation.toString()}');
    try {
      Future.delayed(Duration.zero, () {
        flutterLocalNotificationsPlugin.show(
          0,
          message.notification?.title ?? 'No Title',
          message.notification?.body ?? 'No Body',
          notificationDetails,
          payload: 'senderId=${message.data['senderId']}' ?? 'No Payload',
        );
      });
    } catch (e, stacktrace) {
      debugPrint('Error showing notification: $e');
      debugPrint('Stacktrace: $stacktrace');
    }
  }

  Future<void> requestPermission() async {
    final messaging = FirebaseMessaging.instance;

    final settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint('User granted provisional permission');
    } else {
      debugPrint('User declined or has not accepted permission');
    }
  }

  Future<void> getToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    _saveToken(token!);
  }

  Future<void> _saveToken(String token) async =>
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({'token': token}, SetOptions(merge: true));

  String receiverToken = '';

  Future<void> getReceiverToken(String? receiverId) async {
    final getToken = await FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .get();

    receiverToken = await getToken.data()!['token'];
    debugPrint("token fetched");
  }

  void firebaseNotification(context) {
    _initLocalNotification();
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      debugPrint("user ${jsonDecode(message.data['sender'].fromJson())}");
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ChatPage(
              userId: message.data['senderId'],
              userName: jsonDecode(message.data['sender'].fromJson())),
        ),
      );
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // bool notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
      // if (notificationsEnabled) {
      await _showLocalNotification(message);
      // }
    });
  }

  static Future<String> getAccessToken() async {
    //serviceJson to create server key
    final serviceAccountJson =
        jsonDecode(dotenv.env['ServiceAccountJson']!) ?? {};
    debugPrint("ServiceJson $serviceAccountJson");
    List<String> scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging'
    ];
    http.Client client = await auth.clientViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceAccountJson), scopes);

    //obtain the access token using credientals
    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
            auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
            scopes,
            client);

    //close the client
    client.close();
    debugPrint('serverAccesskey ${credentials.accessToken.data}');
    return credentials.accessToken.data;
  }

  Future<void> sendNotification(
      {required String body,
      required String senderId,
      required String? sender}) async {
    try {
      final serverAccessToken = await getAccessToken();
      debugPrint('hello Msg $serverAccessToken');

      final response = await http.post(
        Uri.parse(
            'https://fcm.googleapis.com/v1/projects/talks-d3253/messages:send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $serverAccessToken'
        },
        body: jsonEncode(<String, dynamic>{
          'message': {
            'token': receiverToken,
            'notification': <String, dynamic>{
              'body': body,
              'title': sender,
            },
            'data': <String, String>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done',
              'senderId': senderId,
              'sender': sender!,
            },
            'android': {
              'priority': 'high',
            },
          }
        }),
      );

      if (response.statusCode == 200) {
        debugPrint('Success while sending push notifications');
      } else {
        debugPrint('Failed to send push notification: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error while sending push notifications ${e.toString()}');
    }
  }
}
