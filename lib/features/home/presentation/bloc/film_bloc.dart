import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:film_app/core/utils/result.dart';
import 'package:film_app/features/home/domain/usecases/get_films.dart';

import 'film_event.dart';
import 'film_state.dart';

class FilmBloc extends Bloc<FilmEvent, FilmState> {
  final GetFilms getFilms;

  FilmBloc(this.getFilms) : super(const FilmInitial()) {
    on<FilmLoadRequested>(_onLoadRequested);
  }

  Future<void> _onLoadRequested(
    FilmLoadRequested event,
    Emitter<FilmState> emit,
  ) async {
    emit(const FilmLoading());

    final result = await getFilms();

    result.when(
      success: (films) {
        final sortedFilms = List.of(films)
          ..sort((a, b) => a.episodeId.compareTo(b.episodeId));

        emit(FilmLoaded(sortedFilms));
      },
      failure: (message, statusCode) {
        emit(FilmFailure(message));
      },
    );
  }
}