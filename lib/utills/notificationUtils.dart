import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import '../views/navbarModule/bloc/navbar_bloc.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

final localNotifications = FlutterLocalNotificationsPlugin();

class NotificationUtils {
  Future<void> onSelectNotification(String payload) async {
    Map<dynamic, dynamic> messageData;
    messageData = json.decode(payload);
    if (messageData['type'] == '3') {
      Get.find<BottomNavController>().navigateToTab(2);
    }
    if (messageData['type'] == '9') {
      Get.find<BottomNavController>().navigateToTab(3);
    }
  }

  Future<void> foregroundNotificatioCustomAuddio(RemoteMessage payload) async {
    final initializationSettingsDarwin = DarwinInitializationSettings(
      defaultPresentBadge: true,
      requestSoundPermission: true,
      requestBadgePermission: true,
      defaultPresentSound: false,
    );
    final android = const AndroidInitializationSettings('@mipmap/ic_launcher');
    final initialSetting = InitializationSettings(
      android: android,
      iOS: initializationSettingsDarwin,
    );
    localNotifications.initialize(
      initialSetting,
      onDidReceiveNotificationResponse: (_) {
        onSelectNotification(json.encode(payload.data));
      },
    );
    final customSound = 'app_sound.wav';
    AndroidNotificationDetails androidDetails =
        const AndroidNotificationDetails(
          'channel_id_17',
          'channel.name',
          importance: Importance.max,
          icon: "@mipmap/ic_launcher",
          playSound: true,
          enableVibration: true,
          sound: RawResourceAndroidNotificationSound('app_sound'),
        );

    final iOSDetails = DarwinNotificationDetails(sound: customSound);
    final platformChannelSpecifics = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await localNotifications.show(
      10,
      payload.notification?.title,
      payload.notification?.body,
      platformChannelSpecifics,
      payload: json.encode(payload.data.toString()),
    );
  }

  Future<void> foregroundNotification(RemoteMessage payload) async {
    NotificationUtils().requestNotificationPermission();

    log('--------------------------------------------------');
    log('started foreground notification');
    log('--------------------------------------------------');

    final initializationSettingsDarwin = DarwinInitializationSettings(
      defaultPresentBadge: true,
      requestSoundPermission: true,
      requestBadgePermission: true,
      defaultPresentSound: false,
    );
    final android = const AndroidInitializationSettings('@mipmap/ic_launcher');
    final initialSetting = InitializationSettings(
      android: android,
      iOS: initializationSettingsDarwin,
    );

    localNotifications.initialize(
      initialSetting,
      onDidReceiveNotificationResponse: (_) {
        onSelectNotification(json.encode(payload.data));
      },
    );

    String? imageUrl =
        payload.notification?.android?.imageUrl ?? payload.data['image'];
    AndroidNotificationDetails androidDetails;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      final bigPicture = BigPictureStyleInformation(
        FilePathAndroidBitmap(
          await _downloadAndSaveFile(imageUrl, 'notif_img'),
        ),
        contentTitle: payload.notification?.title,
        htmlFormatContentTitle: true,
        summaryText: payload.notification?.body,
        htmlFormatSummaryText: true,
      );

      androidDetails = AndroidNotificationDetails(
        'channel_id-111',
        'channel.name',
        importance: Importance.max,
        priority: Priority.high,
        icon: "@mipmap/ic_launcher",
        styleInformation: bigPicture,
        playSound: true,
        enableVibration: true,
      );
    } else {
      androidDetails = const AndroidNotificationDetails(
        'channel_id-111',
        'channel.name',
        importance: Importance.max,
        priority: Priority.high,
        icon: "@mipmap/ic_launcher",
        playSound: true,
        enableVibration: true,
      );
    }

    final iOSDetails = const DarwinNotificationDetails();
    final platformChannelSpecifics = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    int notificationId = DateTime.now().millisecondsSinceEpoch.remainder(
      100000,
    );

    await localNotifications.show(
      notificationId,
      payload.notification?.title,
      payload.notification?.body,
      platformChannelSpecifics,
      payload: json.encode(payload.data.toString()),
    );
  }

  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';
    try {
      final response = await Dio().get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );

      final file = File(filePath);
      await file.writeAsBytes(response.data!);
      return filePath;
    } catch (e) {
      return "";
    }
  }

  Future<void> requestNotificationPermission() async {
    NotificationSettings settings = await FirebaseMessaging.instance
        .requestPermission(alert: true, badge: true, sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('User granted permission');
    } else {
      log('User declined or has not accepted permission');
    }
  }
}
