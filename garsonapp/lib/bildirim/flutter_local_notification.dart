import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHelper {
  // Nesnemizi oluşturduk
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future initialize() async {
    // Bildirim ikonu belirttik.
    const androidInitialize =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationsSettings =
        InitializationSettings(android: androidInitialize);

    // Paketimizi bildirim ikonu belirttikten sonra başlattık.
    await _notifications.initialize(initializationsSettings);
  }

  // Bildirimimizle ilgili tüm ayarları çağırmak üzere burada belirttik.
  static Future _notificationDetails() async => const NotificationDetails(
        android: AndroidNotificationDetails(
          "GunSayaci",
          "day_counterr_1",
          importance: Importance.max,
        ),
      );

  // Normal bildirim gösterme.
  static Future showNotification({
    int id = 123,
    required String title,
    required String body,
    required String payload, // bildirime extra veri eklemek istersek
  }) async =>
      _notifications.show(id, title, body, await _notificationDetails(),
          payload: payload);

  // Zamanlanmış bildirim gösterme.
}
