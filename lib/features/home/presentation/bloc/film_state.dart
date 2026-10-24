import 'package:equatable/equatable.dart';
import 'package:film_app/models/swapi/swapi.dart';

abstract class FilmState extends Equatable {
  const FilmState();

  @override
  List<Object?> get props => [];
}

class FilmInitial extends FilmState {
  const FilmInitial();
}

class FilmLoading extends FilmState {
  const FilmLoading();
}

class FilmLoaded extends FilmState {
  final List<Film> films;

  const FilmLoaded(this.films);

  @override
  List<Object?> get props => [films];
}

class FilmFailure extends FilmState {
  final String message;

  const FilmFailure(this.message);

  @override
  List<Object?> get props => [message];
}