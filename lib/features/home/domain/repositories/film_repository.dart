import 'package:film_app/core/utils/result.dart';
import 'package:film_app/models/swapi/swapi.dart';

abstract class FilmRepository {
  Future<Result<List<Film>>> getFilms();
  Future<Result<Film>> getFilmDetail(int id);
  Future<Result<List<Person>>> getFilmActors(Film film);
  Future<Result<List<Planet>>> getFilmPlanets(Film films);
}
