
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'movie_reminders';
  static const String _channelName = 'Movie Reminders';

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    // Initialize timezone database.
    tz_data.initializeTimeZones();

    // Get device timezone.
    final timezoneInfo = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timezoneInfo.identifier));

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: DarwinInitializationSettings(),
    );

    await _notifications.initialize(
      settings: initializationSettings,
    );

    _isInitialized = true;
  }

  Future<bool> requestNotificationPermission() async {
    await initialize();

    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin == null) return false;

    return await androidPlugin.requestNotificationsPermission() ?? false;
  }

  Future<void> scheduleReminder({
    required String id,
    required String title,
    required String body,
    required DateTime date,
    String repeat = 'none',
  }) async {
    await initialize();

    final notificationId = _generateNotificationId(id);

    final scheduledDate = _getScheduledDate(date, repeat);

    if (scheduledDate == null) {
      await cancelNotification(id);
      return;
    }

    DateTimeComponents? matchDateTimeComponents;

    switch (repeat) {
      case 'daily':
        matchDateTimeComponents = DateTimeComponents.time;
        break;

      case 'weekly':
        matchDateTimeComponents =
            DateTimeComponents.dayOfWeekAndTime;
        break;

      case 'none':
      default:
        matchDateTimeComponents = null;
    }

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: 'Notifications for your movie reminders',
      importance: Importance.max,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _notifications.zonedSchedule(
      id: notificationId,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      notificationDetails: notificationDetails,
      androidScheduleMode:
          AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: matchDateTimeComponents,
      payload: id,
    );
  }

  tz.TZDateTime? _getScheduledDate(
    DateTime date,
    String repeat,
  ) {
    final now = tz.TZDateTime.now(tz.local);

    var scheduledDate = tz.TZDateTime(
      tz.local,
      date.year,
      date.month,
      date.day,
      date.hour,
      date.minute,
    );

    if (repeat == 'daily') {
      scheduledDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        date.hour,
        date.minute,
      );

      if (!scheduledDate.isAfter(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      return scheduledDate;
    }

    if (repeat == 'weekly') {
      final daysUntilTarget =
          (date.weekday - now.weekday + 7) % 7;

      scheduledDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        date.hour,
        date.minute,
      ).add(Duration(days: daysUntilTarget));

      if (!scheduledDate.isAfter(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 7));
      }

      return scheduledDate;
    }

    if (!scheduledDate.isAfter(now)) {
      return null;
    }

    return scheduledDate;
  }

  Future<void> cancelNotification(String id) async {
    await initialize();

    await _notifications.cancel(
      id: _generateNotificationId(id),
    );
  }

  Future<void> cancelAllNotifications() async {
    await initialize();
    await _notifications.cancelAll();
  }

  int _generateNotificationId(String value) {
    var hash = 0x811c9dc5;

    for (final codeUnit in value.codeUnits) {
      hash ^= codeUnit;
      hash = (hash * 0x01000193) & 0x7fffffff;
    }

    return hash == 0 ? 1 : hash;
  }
}
