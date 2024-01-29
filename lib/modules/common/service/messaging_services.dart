import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessagingService {
  static String? fcmToken; // Variable to store the FCM token

  static final MessagingService _instance = MessagingService._internal();

  factory MessagingService() => _instance;

  MessagingService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> init(BuildContext context) async {
    /// permission for notifications
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint(
        'User granted notifications permission: ${settings.authorizationStatus}');

    /// Retrieving the FCM token

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('fcm') ?? '';
    print(token + "is FCM ");

    if (token == '') {
      print('Token is empty');
      fcmToken = await _fcm.getToken();

      ///storing token
      await storeFCMToken(fcmToken!);
      await saveFCMTokenToFirestore();
    } else {
      print('Token is not empty');
      fcmToken = token;
    }
    log('fcmToken: $fcmToken');
    // Handling background messages using the specified handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    ///diolog shows from here
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.notification!.title.toString()}');

      if (message.notification != null) {
        if (message.notification!.title != null &&
            message.notification!.body != null) {
          final notificationData = message.data;
          final screen = notificationData['screen'];

          /// alert dialog Foreground
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return WillPopScope(
                onWillPop: () async => false,
                child: AlertDialog(
                  title: Text(message.notification!.title!),
                  content: Text(message.notification!.body!),
                  actions: [
                    if (notificationData.containsKey('screen'))
                      TextButton(
                        onPressed: () {
                          // _storeFCMToken(fcmToken);
                          //saveFCMTokenToFirestore();
                          Navigator.pop(context);
                          Navigator.of(context).pushNamed(screen);
                        },
                        child: const Text('Open Screen'),
                      ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Dismiss'),
                    ),
                  ],
                ),
              );
            },
          );
        }
      }
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        _handleNotificationClick(context, message);
      }
    });

    /// Handling a notification click event when the app is in the background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint(
          'onMessageOpenedApp: ${message.notification!.title.toString()}');
      _handleNotificationClick(context, message);
    });
  }

  /// Handling a notification click event by navigating to the specified screen
  void _handleNotificationClick(BuildContext context, RemoteMessage message) {
    final notificationData = message.data;

    if (notificationData.containsKey('screen')) {
      final screen = notificationData['screen'];
      Navigator.of(context).pushNamed(screen);
    }
  }
}

///Save localy
Future<void> storeFCMToken(String token) async {
  // Obtain shared preferences.
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('fcm', token);
}

///Storing FCM token in Firestore
Future<void> saveFCMTokenToFirestore() async {
  // final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  final String? fcmToken = await messaging.getToken();

  // Save the FCM token to Firestore
  if (fcmToken != null) {
    await FirestoreHelper.saveFCMToken(fcmToken);
    print('FCM Token saved to Firestore: $fcmToken');
  } else {
    print('Failed to retrieve FCM Token');
  }
}

class FirestoreHelper {
  static Future<void> saveFCMToken(String fcmToken) async {
    final CollectionReference tokens =
        FirebaseFirestore.instance.collection('tokens');

    await tokens.add({
      'token': fcmToken,
    });
  }
}

/// Handler for background messages
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  debugPrint('Handling a background message: ${message.notification!.title}');
}
