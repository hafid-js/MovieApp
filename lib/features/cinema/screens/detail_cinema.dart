import 'package:film_app/features/cinema/widgets/film_item.dart';
import 'package:film_app/features/home/data/film_posters.dart';
import 'package:film_app/features/home/presentation/bloc/film_bloc.dart';
import 'package:film_app/features/home/presentation/bloc/film_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:film_app/core/constants/app_colors.dart';
import 'package:film_app/features/cinema/data/cinema_film_mocks.dart';

import 'package:film_app/features/cinema/models/cinema.dart';

import 'package:film_app/features/home/presentation/screens/detail_screen.dart';
import 'package:film_app/features/mapbox/providers/map_provider.dart';

class DetailCinema extends StatelessWidget {
  final Cinema cinema;
  final VoidCallback onRouteCinema;
  final ValueChanged<int>? onViewFilmDetail;
  final MapNotifier onClearSelectedCinema;

  const DetailCinema({
    super.key,
    required this.cinema,
    required this.onRouteCinema,
    this.onViewFilmDetail,
    required this.onClearSelectedCinema,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: const Text('Detail Cinema'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 240,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/29/d4/8c/55/cgv-is-the-largest-multiplex.jpg?w=1200&h=1200&s=1',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const ColoredBox(
                    color: Colors.black12,
                    child: Icon(Icons.movie, size: 64),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.movie_creation_outlined),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cinema.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        '${cinema.brand} - ${cinema.city}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        cinema.address,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  cinema.openHours,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  onRouteCinema();
                  onClearSelectedCinema.clearSelectedCinema();
                  Get.back();
                },
                icon: const Icon(Icons.route),
                label: const Text('Route to Cinema'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Now Playing',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),

            BlocBuilder<FilmBloc, FilmState>(
              builder: (context, state) {
                if (state is FilmInitial || state is FilmLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is FilmFailure) {
                  return Text('Failed to load movies: ${state.message}');
                }

                if (state is FilmLoaded) {
                  final episodeIds =
                      cinemaFilmMocks[cinema.id] ?? const <int>[];

                  final films = state.films
                      .where((film) => episodeIds.contains(film.episodeId))
                      .toList();

                  if (films.isEmpty) {
                    return const Text('There are no movies available at this cinema.');
                  }
                  return Column(
                    children: films.map((film) {
                      return FilmItem(
                        title: film.title,
                        cinemaId: cinema.id,
                        cinema: cinema.name,
                        episode: film.episodeId,
                        director: film.director,
                        image: posterForTitle(film.title),
                        onTap: () {
                          Get.to(() => DetailScreen(film: film));
                        },
                      );
                    }).toList(),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
