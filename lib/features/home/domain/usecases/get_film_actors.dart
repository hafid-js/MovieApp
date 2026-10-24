import 'package:film_app/core/utils/result.dart';
import 'package:film_app/features/home/domain/repositories/film_repository.dart';
import 'package:film_app/models/swapi/swapi.dart';

class GetFilmActors {
  final FilmRepository repository;

  const GetFilmActors(this.repository);

  Future<Result<List<Person>>> call(Film film) {
    return repository.getFilmActors(film);
  }
}


class GetFilmPlanets {
  final FilmRepository repository;

  const GetFilmPlanets(this.repository);

  Future<Result<List<Planet>>> call(Film film) {
    return repository.getFilmPlanets(film);
  }
}
