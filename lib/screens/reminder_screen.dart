import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import '../services/appwrite_data_service.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final AppwriteDataService _dataService = AppwriteDataService();

  final TextEditingController controller = TextEditingController();

  List<Map<String, dynamic>> reminders = [];
  bool isLoading = false;

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    initNotification();
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    setState(() => isLoading = true);
    final docs = await _dataService.getReminders();
    setState(() {
      reminders = docs.map((doc) {
        final data = Map<String, dynamic>.from(doc.data);
        data['id'] = doc.$id;
        if (data['time'] is String) {
          data['time'] = DateTime.parse(data['time']);
        }
        return data;
      }).toList();
      reminders.sort((a, b) => (a["time"] as DateTime).compareTo(b["time"] as DateTime));
      isLoading = false;
    });
  }

  Future<void> initNotification() async {
    tz.initializeTimeZones();
    try {
      final timezoneInfo = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timezoneInfo.identifier));
    } catch (e) {
      tz.setLocalLocation(tz.getLocation("UTC"));
    }

    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
        InitializationSettings(android: androidSettings);

    await notificationsPlugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap
      },
    );

    if (await Permission.scheduleExactAlarm.isDenied) {
      await Permission.scheduleExactAlarm.request();
    }
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
      int notificationId, String title, DateTime scheduledDate) async {
    final scheduledTZ = tz.TZDateTime.from(scheduledDate, tz.local);

    if (scheduledTZ.isBefore(tz.TZDateTime.now(tz.local))) {
      return; 
    }

    const androidDetails = AndroidNotificationDetails(
      'alarm_channel_id',
      'Reminders',
      channelDescription: 'Notifications for user reminders',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      fullScreenIntent: true,
      category: AndroidNotificationCategory.alarm,
      visibility: NotificationVisibility.public,
    );

    const details = NotificationDetails(android: androidDetails);

    try {
      await notificationsPlugin.zonedSchedule(
        id: notificationId,
        title: "⏰ Reminder",
        body: title,
        scheduledDate: scheduledTZ,
        notificationDetails: details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } catch (e) {
      debugPrint("Error scheduling notification: $e");
    }
  }

  // ➕ ADD REMINDER
  void addReminder() async {
    if (controller.text.trim().isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a reminder title")),
      );
      return;
    }

    DateTime scheduledDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    if (scheduledDateTime.isBefore(DateTime.now())) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a future date and time")),
      );
      return;
    }

    final newReminderData = {
      "title": controller.text,
      "time": scheduledDateTime.toIso8601String(),
    };

    final doc = await _dataService.addReminder(newReminderData);
    
    if (doc != null) {
      // Use a consistent ID for the notification if needed
      final notificationId = doc.$id.hashCode.remainder(100000);
      await scheduleAlarm(notificationId, controller.text, scheduledDateTime);
      controller.clear();
      _loadReminders();
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Reminder set successfully!")),
      );
    }
  }

  // ❌ DELETE
  void deleteReminder(Map<String, dynamic> reminder) async {
    final docId = reminder["id"];
    await _dataService.deleteReminder(docId);
    
    final notificationId = docId.hashCode.remainder(100000);
    await notificationsPlugin.cancel(id: notificationId);
    _loadReminders();
  }

  String formatTime(DateTime dt) {
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
                        child: Text(
                            TimeOfDay.fromDateTime(DateTime(2022, 1, 1, selectedTime.hour, selectedTime.minute)).format(context),
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
              child: isLoading 
                ? const Center(child: CircularProgressIndicator())
                : reminders.isEmpty
                  ? const Center(child: Text("No reminders"))
                  : ListView.builder(
                itemCount: reminders.length,
                itemBuilder: (context, index) {
                  final r = reminders[index];
                  final dt = r["time"] as DateTime;

                  return ListTile(
                    title: Text(r["title"]),
                    subtitle: Text(
                        "${dt.toString().split(' ')[0]} • ${formatTime(dt)}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => deleteReminder(r),
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
