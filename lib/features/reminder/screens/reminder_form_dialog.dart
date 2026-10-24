import 'package:film_app/core/constants/app_colors.dart';
import 'package:film_app/features/reminder/film_reminder.dart';
import 'package:film_app/features/reminder/service/reminder_service.dart';
import 'package:flutter/material.dart';

void showReminderForm(
  BuildContext context, {
  required String cinemaId,
  required String cinemaName,
  required int filmEpisodeId,
  required String filmTitle,
}) {
  // sejakm dari skarang
  DateTime selectedDateTime = DateTime.now();

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(
              'Set Reminder',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Reminder Time:',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                const SizedBox(height: 8),

                OutlinedButton.icon(
                  onPressed: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDateTime,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.dark(
                              primary: Colors.red,
                              onPrimary: Colors.white,
                              surface: Theme.of(context).cardColor,
                              onSurface: Colors.white,
                            ),

                            datePickerTheme: DatePickerThemeData(
                              cancelButtonStyle: ButtonStyle(
                                foregroundColor: WidgetStateProperty.all(
                                  Colors.white54,
                                ),
                              ),
                              confirmButtonStyle: ButtonStyle(
                                foregroundColor: WidgetStateProperty.all(
                                  Colors.red,
                                ),
                              ),
                            ),
                          ),

                          child: child!,
                        );
                      },
                    );

                    if (pickedDate == null) return;

                    if (!context.mounted) return;

                    final TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(selectedDateTime),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.dark(
                              primary: Colors.red,
                              onPrimary: Colors.white,
                              surface: Theme.of(context).cardColor,
                              onSurface: Colors.white,
                            ),
                            timePickerTheme: TimePickerThemeData(
                              helpTextStyle: Theme.of(
                                context,
                              ).textTheme.titleSmall,
                              backgroundColor: Theme.of(context).cardColor,
                              hourMinuteColor: Theme.of(context).cardColor,
                              hourMinuteTextColor: Colors.white,
                              dayPeriodColor: Colors.white,
                              dayPeriodTextColor: Colors.red,
                              dialHandColor: Colors.red,
                              dialBackgroundColor: Theme.of(
                                context,
                              ).cardColor.withAlpha(180),
                              dialTextColor: Colors.white,
                              cancelButtonStyle: TextButton.styleFrom(
                                foregroundColor: Colors.white70,
                              ),
                              confirmButtonStyle: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );

                    if (pickedTime == null) return;

                    setState(() {
                      selectedDateTime = DateTime(
                        pickedDate.year,
                        pickedDate.month,
                        pickedDate.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );
                    });
                  },
                  icon: Icon(
                    Icons.calendar_today,
                    size: 18,
                    color: AppColors.secondary,
                  ),
                  label: Text(
                    '${selectedDateTime.day}/${selectedDateTime.month}/${selectedDateTime.year}  ${selectedDateTime.hour.toString().padLeft(2, '0')}:${selectedDateTime.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () async {
                  final newReminder = FilmReminder(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    cinemaId: cinemaId,
                    cinemaName: cinemaName,
                    filmEpisodeId: filmEpisodeId,
                    filmTitle: filmTitle,
                    reminderTime: selectedDateTime,
                  );

                  await FilmReminderService().addReminder(newReminder);

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Awesome! The reminder form is fully set up',
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
