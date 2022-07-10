import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class PushNotificactionService {
  final FirebaseMessaging _fcm;
  PushNotificactionService(this._fcm);

  Future initialise() async {
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings(

      ));
    }

    String token = await _fcm.getToken();
    print('Token: $token');

    _fcm.configure(onMessage: (Map<String, dynamic> message) async {
      print("onMessage: $message");
    }, onLaunch: (Map<String, dynamic> message) async {
      print("onMessage: $message");
    }, onResume: (Map<String, dynamic> message) async {
      print("onMessage: $message");
    });
  }
}
/*

onBackgroundMessage: (Map<String, dynamic> message) async {
      print("onMessage: $message");
    },

 */