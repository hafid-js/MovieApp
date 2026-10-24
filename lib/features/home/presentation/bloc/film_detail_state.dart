
import 'package:equatable/equatable.dart';
import 'package:film_app/models/swapi/swapi.dart';

enum DataStatus {
  initial,
  loading,
  loaded,
  failure,
}

class FilmDetailState extends Equatable {
  final DataStatus actorsStatus;
  final DataStatus planetsStatus;

  final List<Person> actors;
  final List<Planet> planets;

  final String? actorsError;
  final String? planetsError;

  const FilmDetailState({
    this.actorsStatus = DataStatus.initial,
    this.planetsStatus = DataStatus.initial,
    this.actors = const [],
    this.planets = const [],
    this.actorsError,
    this.planetsError,
  });

  FilmDetailState copyWith({
    DataStatus? actorsStatus,
    DataStatus? planetsStatus,
    List<Person>? actors,
    List<Planet>? planets,
    String? actorsError,
    String? planetsError,
  }) {
    return FilmDetailState(
      actorsStatus: actorsStatus ?? this.actorsStatus,
      planetsStatus: planetsStatus ?? this.planetsStatus,
      actors: actors ?? this.actors,
      planets: planets ?? this.planets,
      actorsError: actorsError ??
          (actorsStatus == DataStatus.loading ||
                  actorsStatus == DataStatus.loaded
              ? null
              : this.actorsError),
      planetsError: planetsError ??
          (planetsStatus == DataStatus.loading ||
                  planetsStatus == DataStatus.loaded
              ? null
              : this.planetsError),
    );
  }

  @override
  List<Object?> get props => [
        actorsStatus,
        planetsStatus,
        actors,
        planets,
        actorsError,
        planetsError,
      ];
}
