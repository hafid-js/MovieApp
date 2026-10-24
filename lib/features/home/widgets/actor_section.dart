
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:film_app/features/home/presentation/bloc/film_detail_bloc.dart';
import 'package:film_app/features/home/presentation/bloc/film_detail_event.dart';
import 'package:film_app/features/home/presentation/bloc/film_detail_state.dart';
import 'package:film_app/models/swapi/film.dart';

class ActorsSection extends StatelessWidget {
  final Film film;

  const ActorsSection({
    super.key,
    required this.film,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilmDetailBloc, FilmDetailState>(
      builder: (context, state) {
        if (state.actorsStatus == DataStatus.initial ||
            state.actorsStatus == DataStatus.loading) {
          return const SizedBox(
            width: double.infinity,
            height: 60,
            child: Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }

        if (state.actorsStatus == DataStatus.failure) {
          return Row(
            children: [
              Expanded(
                child: Text(
                  state.actorsError ?? 'Failed to load actors.',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
              TextButton(
                onPressed: () {
                  context.read<FilmDetailBloc>().add(
                    FilmActorsRequested(film),
                  );
                },
                child: const Text('Try Again'),
              ),
            ],
          );
        }

        if (state.actors.isEmpty) {
          return Text(
            'Actor data is unavailable.',
            style: Theme.of(context).textTheme.labelSmall,
          );
        }

        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: state.actors.map((actor) {
            return Text(
              actor.name,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w300,
                  ),
            );
          }).toList(),
        );
      },
    );
  }
}
