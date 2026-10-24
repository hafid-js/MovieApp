
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:film_app/features/home/presentation/bloc/film_detail_bloc.dart';
import 'package:film_app/features/home/presentation/bloc/film_detail_event.dart';
import 'package:film_app/features/home/presentation/bloc/film_detail_state.dart';
import 'package:film_app/models/swapi/film.dart';

class PlanetSection extends StatelessWidget {
  final Film film;

  const PlanetSection({
    super.key,
    required this.film,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilmDetailBloc, FilmDetailState>(
      builder: (context, state) {
        if (state.planetsStatus == DataStatus.initial ||
            state.planetsStatus == DataStatus.loading) {
          return const SizedBox(
            width: double.infinity,
            height: 60,
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            ),
          );
        }

        if (state.planetsStatus == DataStatus.failure) {
          return Row(
            children: [
              Expanded(
                child: Text(
                  state.planetsError ?? 'Failed to load planets.',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
              TextButton(
                onPressed: () {
                  context.read<FilmDetailBloc>().add(
                    FilmPlanetRequested(film),
                  );
                },
                child: const Text('Try Again'),
              ),
            ],
          );
        }

        if (state.planets.isEmpty) {
          return Text(
            'Planet data is unavailable.',
            style: Theme.of(context).textTheme.labelSmall,
          );
        }

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(12),
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 6,
          childAspectRatio: 7,
          children: [
            _buildTag(
              context,
              Icons.public,
              'Planets: ${state.planets.length}',
            ),
            _buildTag(
              context,
              Icons.people,
              'Species: ${film.species.length}',
            ),
            _buildTag(
              context,
              Icons.rocket,
              'Starships: ${film.starships.length}',
            ),
            _buildTag(
              context,
              Icons.movie,
              'Characters: ${film.characters.length}',
            ),
          ],
        );
      },
    );
  }
}

Widget _buildTag(
  BuildContext context,
  IconData icon,
  String label,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 12),
      const SizedBox(width: 4),
      Flexible(
        child: Text(
          label,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w200,
          ),
        ),
      ),
    ],
  );
}
