import 'package:equatable/equatable.dart';

abstract class FilmEvent extends Equatable {
  const FilmEvent();

  @override
  List<Object?> get props => [];
}

class FilmLoadRequested extends FilmEvent {
  const FilmLoadRequested();
}