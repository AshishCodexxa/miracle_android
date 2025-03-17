import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:miracle/src/data/network/dio_client.dart';
import 'package:miracle/src/utils/constant.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:workmanager/workmanager.dart';

Future<void> scheduleNotifications() async {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();
  const initializationSettingsAndroid = AndroidInitializationSettings('logo');
  const initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await notificationsPlugin.initialize(initializationSettings);

  int howMany = GetStorage().read<int>(kNotificationHowMany) ?? 10;
  String startAt = GetStorage().read<String>(kNotificationStartAt) ?? '09:30';
  String endAt = GetStorage().read<String>(kNotificationEndAt) ?? '21:30';

  final notifications = await DioClient().getNotificationQuote(howMany);

  DateTime current = DateTime.now();
  DateTime notificationStartAt = DateFormat.Hm().parse(startAt);
  DateTime notificationEndAt = DateFormat.Hm().parse(endAt);

  await notificationsPlugin.cancelAll();

  notificationStartAt = DateTime(
    current.year,
    current.month,
    current.day,
    notificationStartAt.hour,
    notificationStartAt.minute,
  );

  notificationEndAt = DateTime(
    current.year,
    current.month,
    current.day,
    notificationEndAt.hour,
    notificationEndAt.minute,
  );

  final intervalInMinute =
      notificationEndAt.difference(notificationStartAt).inMinutes / howMany;

  tz.initializeTimeZones();

  for (int i = 0; i < howMany; i++) {
    bool shouldSchedule = notificationStartAt
        .add(Duration(minutes: (intervalInMinute * i).toInt()))
        .isAfter(current);

    if (shouldSchedule) {
      await notificationsPlugin.zonedSchedule(
        i,
        'Manifest Miracle',
        notifications.data[i].quote,
        tz.TZDateTime.from(
          notificationStartAt.add(
            Duration(
              minutes: (intervalInMinute * i).toInt(),
            ),
          ),
          tz.local,
        ),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'Miracle',
            'Miracle',
            channelDescription: 'Miracle',
          ),
        ),
        // androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exact,
      );
    }
  }
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await scheduleNotifications();
    // debugPrint('schedular called on ${DateTime.now()}');
    // debugPrint('schedular task $task');
    return Future.value(true);
  });
}
