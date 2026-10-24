// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'film_reminder.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FilmReminderAdapter extends TypeAdapter<FilmReminder> {
  @override
  final int typeId = 1;

  @override
  FilmReminder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FilmReminder(
      id: fields[0] as String,
      cinemaId: fields[1] as String,
      cinemaName: fields[2] as String,
      filmEpisodeId: fields[3] as int,
      filmTitle: fields[4] as String,
      reminderTime: fields[5] as DateTime,
      imageUrl: fields[6] as String?,
      isEnabled: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, FilmReminder obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.cinemaId)
      ..writeByte(2)
      ..write(obj.cinemaName)
      ..writeByte(3)
      ..write(obj.filmEpisodeId)
      ..writeByte(4)
      ..write(obj.filmTitle)
      ..writeByte(5)
      ..write(obj.reminderTime)
      ..writeByte(6)
      ..write(obj.imageUrl)
      ..writeByte(7)
      ..write(obj.isEnabled);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FilmReminderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
