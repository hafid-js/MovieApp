
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:film_app/core/utils/result.dart';
import 'package:film_app/features/home/domain/usecases/get_film_actors.dart';

import 'film_detail_event.dart';
import 'film_detail_state.dart';

class FilmDetailBloc
    extends Bloc<FilmDetailEvent, FilmDetailState> {
  final GetFilmActors getFilmActors;
  final GetFilmPlanets getFilmPlanets;

  FilmDetailBloc(this.getFilmActors, this.getFilmPlanets)
      : super(const FilmDetailState()) {
    on<FilmActorsRequested>(_onActorsRequested);
    on<FilmPlanetRequested>(_onPlanetRequested);
  }

  Future<void> _onActorsRequested(
    FilmActorsRequested event,
    Emitter<FilmDetailState> emit,
  ) async {
    emit(state.copyWith(
      actorsStatus: DataStatus.loading,
    ));

    final result = await getFilmActors(event.film);

    result.when(
      success: (actors) {
        emit(state.copyWith(
          actorsStatus: DataStatus.loaded,
          actors: actors,
        ));
      },
      failure: (message, statusCode) {
        emit(state.copyWith(
          actorsStatus: DataStatus.failure,
          actorsError: message,
        ));
      },
    );
  }

  Future<void> _onPlanetRequested(
    FilmPlanetRequested event,
    Emitter<FilmDetailState> emit,
  ) async {
    emit(state.copyWith(
      planetsStatus: DataStatus.loading,
    ));

    final result = await getFilmPlanets(event.film);

    result.when(
      success: (planets) {
        emit(state.copyWith(
          planetsStatus: DataStatus.loaded,
          planets: planets,
        ));
      },
      failure: (message, statusCode) {
        emit(state.copyWith(
          planetsStatus: DataStatus.failure,
          planetsError: message,
        ));
      },
    );
  }
}
