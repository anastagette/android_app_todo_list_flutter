import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class NotificationService {

  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'todos_notifications_channel',
        'To-dos notifications',
        icon: 'notification_icon',
        priority: Priority.max,
        importance: Importance.max,
        enableVibration: true
      ),
      iOS: IOSNotificationDetails()
    );
  }

  static Future addNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDateTime
  }) async {

    var tzDate =  tz.TZDateTime.from(
      scheduledDateTime,
      tz.getLocation(await FlutterNativeTimezone.getLocalTimezone()));

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tzDate.toLocal(),
      await _notificationDetails(),
      uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true
    );
  }

  static void removeNotification({
    required int id,
  }) async {
    _notifications.cancel(id);
  }

  static void updateNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDateTime
  }) async {
    removeNotification(id: id);
    addNotification(
      id: id,
      title: title,
      body: body,
      scheduledDateTime: scheduledDateTime
    );
  }
}