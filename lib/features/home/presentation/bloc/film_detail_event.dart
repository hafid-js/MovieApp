import 'package:equatable/equatable.dart';
import 'package:film_app/models/swapi/swapi.dart';

abstract class FilmDetailEvent extends Equatable {
  const FilmDetailEvent();

  @override
  List<Object?> get props => [];
}

class FilmActorsRequested extends FilmDetailEvent {
  final Film film;

  const FilmActorsRequested(this.film);

  @override
  List<Object?> get props => [film];
}

class FilmPlanetRequested extends FilmDetailEvent {
  final Film film;

  const FilmPlanetRequested(this.film);

  @override
  List<Object?> get props => [film];
}