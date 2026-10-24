import 'package:film_app/core/constants/app_colors.dart';
import 'package:film_app/features/reminder/film_reminder.dart';
import 'package:film_app/features/reminder/service/reminder_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ReminderScreen extends StatelessWidget {
  const ReminderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = FilmReminderService();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('Reminder', style: Theme.of(context).textTheme.titleMedium),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<FilmReminder>(
          'filmRemindersBox',
        ).listenable(),
        builder: (context, Box<FilmReminder> box, _) {
          final reminders = box.values.toList();

          if (reminders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.notifications_off_outlined,
                    size: 50,
                    color: Colors.white54,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'You have no upcoming movie reminders',
                    style: TextStyle(fontSize: 16, color: Colors.white54),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: reminders.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index) {
              final reminder = reminders[index];

              final formattedTime =
                  '${reminder.reminderTime.day}/${reminder.reminderTime.month}/${reminder.reminderTime.year} '
                  '${reminder.reminderTime.hour.toString().padLeft(2, '0')}:${reminder.reminderTime.minute.toString().padLeft(2, '0')}';

              return Card(
                color: Theme.of(context).cardColor,
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),

                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child:
                        reminder.imageUrl != null &&
                            reminder.imageUrl!.isNotEmpty
                        ? Image.asset(
                            reminder.imageUrl!,
                            width: 50,
                            height: 70,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                                  Icons.movie,
                                  size: 40,
                                  color: Colors.white54,
                                ),
                          )
                        : Container(
                            width: 50,
                            height: 70,
                            color: AppColors.primary.withAlpha(120),
                            child: const Icon(Icons.movie, color: Colors.white),
                          ),
                  ),
                  title: Text(
                    reminder.filmTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 14,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                reminder.cinemaName,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 14,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              formattedTime,
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.secondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  trailing: IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () {
                      service.deleteReminder(reminder.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Reminder successfully deleted'),
                        ),
                      );
                    },
                  ),

                  onTap: () {},
                ),
              );
            },
          );
        },
      ),
    );
  }
}
