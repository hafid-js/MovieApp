import 'package:film_app/core/constants/api_endpoints.dart';
import 'package:film_app/core/network/dio_client.dart';
import 'package:film_app/core/utils/result.dart';
import 'package:film_app/models/swapi/swapi.dart';

abstract class FilmRemoteDataSource {
  Future<Result<SwapiListResponse<Film>>> getFilms();
  Future<Result<Film>> getFilm(int id);
  Future<Result<Person>> getPerson(int id);
    Future<Result<Planet>> getPlanet(int id);
}

class FilmRemoteDataSourceImpl implements FilmRemoteDataSource {
  final DioClient _client;

  FilmRemoteDataSourceImpl(this._client);

  @override
  Future<Result<SwapiListResponse<Film>>> getFilms() async {
    final result = await _client.get(ApiEndpoints.films);
    return result.when(
      success: (response) {
        final data = response.data;
        if (data is! Map<String, dynamic>) {
          return const Failure('Format response film tidak valid.');
        }
        return Success(SwapiListResponse<Film>.fromJson(data, Film.fromJson));
      },
      failure: (message, statusCode) =>
          Failure(message, statusCode: statusCode),
    );
  }

  @override
  Future<Result<Film>> getFilm(int id) async {
    final result = await _client.get(ApiEndpoints.detailFilm(id));
    return result.when(
      success: (response) {
        final data = response.data;
        if (data is! Map<String, dynamic>) {
          return const Failure('Format response film tidak valid.');
        }
        return Success(Film.fromJson(data));
      },
      failure: (message, statusCode) =>
          Failure(message, statusCode: statusCode),
    );
  }

  @override
  Future<Result<Person>> getPerson(int id) async {
    final result = await _client.get(ApiEndpoints.detailPerson(id));
    return result.when(
      success: (response) {
        final data = response.data;
        if (data is! Map<String, dynamic>) {
          return const Failure('Format response person tidak valid.');
        }
        return Success(Person.fromJson(data));
      },
      failure: (message, statusCode) =>
          Failure(message, statusCode: statusCode),
    );
  }


  
@override
Future<Result<Planet>> getPlanet(int id) async {
  final result = await _client.get(
    ApiEndpoints.detailPlanet(id),
  );

  return result.when(
    success: (response) {
      final data = response.data;

      if (data is! Map<String, dynamic>) {
        return const Failure(
          'Format response planet tidak valid.',
        );
      }

      return Success(Planet.fromJson(data));
    },
    failure: (message, statusCode) =>
        Failure(message, statusCode: statusCode),
  );
}

}
