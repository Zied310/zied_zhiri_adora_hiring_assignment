import 'package:flutter_local_notifications/flutter_local_notifications.dart';
class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);
    await _plugin.initialize(initSettings);
  }

  static Future<void> showNotification({
    required double lat,
    required double lng,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'location_channel',
      'Location Tracking',
      importance: Importance.max,
      priority: Priority.high,
      ongoing: true,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _plugin.show(
      1,
      'Live Location Tracking',
      'Latitude: $lat, Longitude: $lng',
      notificationDetails,
    );
  }
}