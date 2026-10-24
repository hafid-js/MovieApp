import 'package:film_app/core/utils/result.dart';
import 'package:film_app/features/home/domain/repositories/film_repository.dart';
import 'package:film_app/models/swapi/swapi.dart';

class GetFilms {
  final FilmRepository repository;

  const GetFilms(this.repository);

  Future<Result<List<Film>>> call() {
    return repository.getFilms();
  }
}
