import 'package:hive/hive.dart';

part 'film_reminder.g.dart';

@HiveType(typeId: 1)
class FilmReminder extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String cinemaId;

  @HiveField(2)
  final String cinemaName; 

  @HiveField(3)
  final int filmEpisodeId; 

  @HiveField(4)
  final String filmTitle; 

  @HiveField(5)
  final DateTime reminderTime;

  @HiveField(6)
  final String? imageUrl;

  @HiveField(7)
  bool isEnabled;

  FilmReminder({
    required this.id,
    required this.cinemaId,
    required this.cinemaName,
    required this.filmEpisodeId,
    required this.filmTitle,
    required this.reminderTime,
    this.imageUrl,
    this.isEnabled = true,
  });
}