import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

// Service untuk handle semua notification (Todo, Timer, etc)
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  // Initialize notification service
  // Dipanggil sekali saat app start di main.dart
  Future<void> initialize() async {
    if (_initialized) return;

    // Initialize timezone
    tz.initializeTimeZones();

    // Set local timezone (default Jakarta/Asia)
    // Bisa disesuaikan dengan timezone user
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));

    // Android initialization settings
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // iOS initialization settings
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // Initialize plugin
    await _notifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Note: Permission tidak auto-request lagi
    // Sekarang dipanggil manual dari HomePage dengan dialog

    _initialized = true;
  }

  // Request notification permissions (Android 13+, iOS)
  // Public method yang bisa dipanggil dari HomePage
  Future<bool> requestPermissions() async {
    // Android 13+ requires runtime permission
    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    bool granted = true;
    if (androidPlugin != null) {
      final notifGranted = await androidPlugin.requestNotificationsPermission();
      final alarmGranted = await androidPlugin.requestExactAlarmsPermission();
      granted = (notifGranted ?? false) && (alarmGranted ?? false);
    }

    // iOS requires permission
    final iosPlugin = _notifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();

    if (iosPlugin != null) {
      final iosGranted = await iosPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      granted = iosGranted ?? false;
    }

    return granted;
  }

  // Callback saat user tap notification
  void _onNotificationTapped(NotificationResponse response) {
    // TODO: Handle navigation saat notif di-tap
    // Misal: buka detail todo, atau navigasi ke progress page
    print('Notification tapped: ${response.payload}');
  }

  // Schedule notification untuk Todo
  // Notif akan muncul di tanggal & waktu yang ditentukan
  Future<void> scheduleTodoNotification({
    required int id,
    required String title,
    required String description,
    required DateTime scheduledDate,
  }) async {
    if (!_initialized) {
      throw Exception(
        'NotificationService belum di-initialize. Panggil initialize() di main.dart',
      );
    }

    // Convert DateTime ke TZDateTime (timezone-aware)
    final tzScheduledDate = tz.TZDateTime.from(scheduledDate, tz.local);

    // Cek apakah waktu sudah lewat
    if (tzScheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
      print('⚠️ Scheduled time sudah lewat, notif tidak akan muncul');
      return;
    }

    await _notifications.zonedSchedule(
      id: id,
      title: title,
      body: description,
      scheduledDate: tzScheduledDate,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'todo_channel',
          'Todo Reminders',
          channelDescription: 'Notifications for todo reminders',
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: 'todo_$id', // Data yang dikirim ke callback
    );

    print('✅ Todo notification scheduled for $tzScheduledDate');
  }

  // Cancel notification by ID
  // Dipanggil saat todo di-delete atau completed
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id: id);
    print('🗑️ Notification $id cancelled');
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
    print('🗑️ All notifications cancelled');
  }

  // Get pending notifications (untuk debug/testing)
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  // Check jika notification sudah scheduled untuk ID tertentu
  Future<bool> isNotificationScheduled(int id) async {
    final pending = await getPendingNotifications();
    return pending.any((notif) => notif.id == id);
  }
}
