import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  final TextEditingController controller = TextEditingController();

  List<Map<String, dynamic>> reminders = [];

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    initNotification();
  }

  Future<void> initNotification() async {
    tz.initializeTimeZones();

    tz.setLocalLocation(tz.getLocation("Asia/Kolkata")); // 🔥 FIX

    await Permission.notification.request();

    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
    InitializationSettings(android: androidSettings);

    await notificationsPlugin.initialize(settings);
  }

  // 📅 Date
  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  // ⏰ Time
  Future<void> pickTime() async {
    final picked =
    await showTimePicker(context: context, initialTime: selectedTime);

    if (picked != null) {
      setState(() => selectedTime = picked);
    }
  }

  // 🔥 PRO ALARM FUNCTION
  Future<void> scheduleAlarm(
      String title, DateTime scheduledDate) async {

    final scheduledTZ =
    tz.TZDateTime.from(scheduledDate, tz.local);

    const androidDetails = AndroidNotificationDetails(
      'alarm_channel',
      'Alarm',
      channelDescription: 'Alarm Notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,

      // 🔥 PRO SETTINGS
      fullScreenIntent: true,
      category: AndroidNotificationCategory.alarm,
      visibility: NotificationVisibility.public,
      ticker: "Alarm ringing",
      timeoutAfter: 60000, // auto dismiss after 1 min
    );

    const details = NotificationDetails(android: androidDetails);

    await notificationsPlugin.zonedSchedule(
      111,
      "⏰ Reminder",
      title,
      scheduledTZ,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // ➕ ADD REMINDER
  void addReminder() {
    if (controller.text.isEmpty) return;

    DateTime scheduledDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    // 🔥 FORCE FUTURE
    if (scheduledDateTime.isBefore(DateTime.now())) {
      scheduledDateTime =
          DateTime.now().add(const Duration(minutes: 1));
    }

    scheduleAlarm(controller.text, scheduledDateTime);

    setState(() {
      reminders.add({
        "title": controller.text,
        "date": selectedDate,
        "time": selectedTime,
      });
      controller.clear();
    });
  }

  // ❌ DELETE
  void deleteReminder(int index) {
    setState(() {
      reminders.removeAt(index);
    });
  }

  String formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt =
    DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return TimeOfDay.fromDateTime(dt).format(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final textColor = isDark ? Colors.white : Colors.black87;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Reminder"),
        centerTitle: true,
        backgroundColor: const Color(0xFF26C6DA),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF121212) : null,
          gradient: isDark
              ? null
              : const LinearGradient(
            colors: [
              Color(0xFFE0F7FA),
              Color(0xFFB2EBF2),
              Color(0xFF80DEEA),
            ],
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(15),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: "Enter reminder...",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          selectedDate.toString().split(' ')[0],
                          style: TextStyle(color: textColor),
                        ),
                      ),
                      TextButton(onPressed: pickDate, child: const Text("Date")),
                    ],
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: Text(formatTime(selectedTime),
                            style: TextStyle(color: textColor)),
                      ),
                      TextButton(onPressed: pickTime, child: const Text("Time")),
                    ],
                  ),

                  ElevatedButton(
                    onPressed: addReminder,
                    child: const Text("Set Reminder"),
                  )
                ],
              ),
            ),

            Expanded(
              child: reminders.isEmpty
                  ? const Center(child: Text("No reminders"))
                  : ListView.builder(
                itemCount: reminders.length,
                itemBuilder: (context, index) {
                  final r = reminders[index];

                  return ListTile(
                    title: Text(r["title"]),
                    subtitle: Text(
                        "${r["date"].toString().split(' ')[0]} • ${formatTime(r["time"])}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => deleteReminder(index),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}