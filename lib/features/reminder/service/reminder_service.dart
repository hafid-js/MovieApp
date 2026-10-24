import 'package:film_app/features/reminder/film_reminder.dart';
import 'package:film_app/features/reminder/service/notification_service.dart';
import 'package:hive/hive.dart';

class FilmReminderService {
  static const String _boxName = 'FilmRemindersBox';

  Box<FilmReminder> get _box => Hive.box<FilmReminder>(_boxName);

 
int _getNotificationId(String stringId) {
  return stringId.hashCode & 0x7fffffff;
}

 Future<void> addReminder(FilmReminder reminder) async {
  await _box.put(reminder.id, reminder);

  if (reminder.isEnabled) {
    await NotificationService().scheduleNotification(
      id: _getNotificationId(reminder.id),
      title: 'Film Reminder: ${reminder.filmTitle}',
      body: 'Your movie schedule at ${reminder.cinemaName} will start soon!',
      scheduledDate: reminder.reminderTime,
    );
  }
}

  List<FilmReminder> getReminders() {
    return _box.values.toList();
  }

  FilmReminder? getReminderById(String id) {
    return _box.get(id);
  }

  Future<void> updateReminder(FilmReminder reminder) async {
    await reminder.save();

    final notifId = _getNotificationId(reminder.id);

    if (reminder.isEnabled) {
      await NotificationService().scheduleNotification(
        id: notifId,
        title: 'Film Reminder: ${reminder.filmTitle}',
        body: 'Your movie schedule at ${reminder.cinemaName} will start soon!',
        scheduledDate: reminder.reminderTime,
      );
    } else {
      await NotificationService().cancelNotification(notifId);
    }
  }

 Future<void> deleteReminder(String id) async {
  await _box.delete(id);

  await NotificationService().cancelNotification(
    _getNotificationId(id),
  );
}

  Future<void> clearAllReminders() async {
    await _box.clear();

    await NotificationService().cancelAllNotifications();
  }

  Future<void> deleteExpiredReminders() async {
    final now = DateTime.now();

    final expiredReminders = _box.values
        .where((reminder) => reminder.reminderTime.isBefore(now))
        .toList();

    for (final reminder in expiredReminders) {
      await deleteReminder(reminder.id);
    }
  }
}
