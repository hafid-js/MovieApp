

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:film_app/core/network/dio_client.dart';
import 'package:film_app/features/home/data/datasources/film_remote_data_source.dart';
import 'package:film_app/features/home/data/repositories/film_repository_impl.dart';
import 'package:film_app/features/home/domain/usecases/get_film_actors.dart';
import 'package:film_app/features/home/presentation/bloc/film_detail_bloc.dart';
import 'package:film_app/features/home/presentation/bloc/film_detail_event.dart';
import 'package:film_app/features/home/widgets/detail_view.dart';
import 'package:film_app/models/swapi/swapi.dart';

class DetailScreen extends StatelessWidget {
  final Film film;

  const DetailScreen({
    super.key,
    required this.film,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FilmDetailBloc(
        GetFilmActors(
          FilmRepositoryImpl(
            FilmRemoteDataSourceImpl(DioClient()),
          ),
        ),
        GetFilmPlanets(
          FilmRepositoryImpl(
            FilmRemoteDataSourceImpl(DioClient()),
          ),
        ),
      )..add(FilmActorsRequested(film))..add(FilmPlanetRequested(film)),
      child: DetailView(film: film),
    );
  }
}