import 'package:film_app/core/utils/result.dart';
import 'package:film_app/features/home/data/datasources/film_remote_data_source.dart';
import 'package:film_app/features/home/domain/repositories/film_repository.dart';
import 'package:film_app/models/swapi/swapi.dart';

class FilmRepositoryImpl implements FilmRepository {
  final FilmRemoteDataSource _remoteDataSource;

  FilmRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<Film>>> getFilms() async {
    final result = await _remoteDataSource.getFilms();
    return result.when(
      success: (response) => Success(response.results),
      failure: (message, statusCode) =>
          Failure(message, statusCode: statusCode),
    );
  }

  @override
  Future<Result<Film>> getFilmDetail(int id) {
    return _remoteDataSource.getFilm(id);
  }

  @override
  Future<Result<List<Person>>> getFilmActors(
    Film film) async {
    final ids = film.characterIds.toList();
    if (ids.isEmpty) return const Success<List<Person>>([]);

    final results = await Future.wait(
      ids.map((id) => _remoteDataSource.getPerson(id)),
    );

    final actors = <Person>[];
    String? lastMessage;
    int? lastStatusCode;

    for (final result in results) {
      result.when(
        success: actors.add,
        failure: (message, statusCode) {
          lastMessage = message;
          lastStatusCode = statusCode;
        },
      );
    }

    if (actors.isEmpty && lastMessage != null) {
      return Failure(lastMessage!, statusCode: lastStatusCode);
    }

    return Success(actors);
  }


@override
  Future<Result<List<Planet>>> getFilmPlanets(
    Film film) async {
    final ids = film.planetIds;
    if (ids.isEmpty) return const Success<List<Planet>>([]);

    final results = await Future.wait(
      ids.map((id) => _remoteDataSource.getPlanet(id)),
    );

    final planets = <Planet>[];
    String? lastMessage;
    int? lastStatusCode;

    for (final result in results) {
      result.when(
        success: planets.add,
        failure: (message, statusCode) {
          lastMessage = message;
          lastStatusCode = statusCode;
        },
      );
    }

    if (planets.isEmpty && lastMessage != null) {
      return Failure(lastMessage!, statusCode: lastStatusCode);
    }

    return Success(planets);
  }
}
