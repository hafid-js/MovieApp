import 'package:carousel_slider/carousel_slider.dart';
import 'package:film_app/features/reminder/screens/reminder_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:film_app/core/network/dio_client.dart';
import 'package:film_app/features/home/data/datasources/film_remote_data_source.dart';
import 'package:film_app/features/home/data/film_posters.dart';
import 'package:film_app/features/home/data/repositories/film_repository_impl.dart';
import 'package:film_app/features/home/domain/usecases/get_films.dart';
import 'package:film_app/features/home/presentation/bloc/film_bloc.dart';
import 'package:film_app/features/home/presentation/bloc/film_event.dart';
import 'package:film_app/features/home/presentation/bloc/film_state.dart';
import 'package:film_app/features/home/presentation/screens/detail_screen.dart';
import 'package:film_app/features/mapbox/screens/map_screen.dart';
import 'package:film_app/models/swapi/swapi.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FilmBloc(
        GetFilms(FilmRepositoryImpl(FilmRemoteDataSourceImpl(DioClient()))),
      )..add(const FilmLoadRequested()),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  static const double _posterWidth = 320;
  static const double _posterHeight = 500;
  static const double _posterSpacing = 10;
  static const double _enlargeFactor = 0.3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Row(
            children: [
              Image.asset(
                'assets/images/logo-netflix.png',
                height: 30,
                width: 30,
                fit: BoxFit.contain,
              ),
              Text(
                'Beranda',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        centerTitle: false,
        titleSpacing: 0,
        actions: [GestureDetector(
          onTap: () => Get.to(() => ReminderScreen(),),
          child: Row(
            children: [
              Text("Reminder"),
              SizedBox(width: 5),
              Icon(Iconsax.calendar_tick)
            ],
          ),
        )],
        actionsPadding: const EdgeInsets.only(right: 12),
      ),
      body: BlocBuilder<FilmBloc, FilmState>(
        builder: (context, state) {
          if (state is FilmInitial || state is FilmLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FilmFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        context.read<FilmBloc>().add(
                          const FilmLoadRequested(),
                        );
                      },
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is FilmLoaded) {
            if (state.films.isEmpty) {
              return const Center(child: Text('Belum ada film.'));
            }

            return _buildBody(context, state.films);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, List<Film> films) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Films',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final pageWidth = _posterWidth + _posterSpacing;
                final viewportFraction = (pageWidth / constraints.maxWidth)
                    .clamp(0.0, 1.0);

                return CarouselSlider.builder(
                  itemCount: films.length,
                  itemBuilder: (context, index, realIndex) {
                    return _buildPoster(context, films[index]);
                  },
                  options: CarouselOptions(
                    height: _posterHeight,
                    viewportFraction: viewportFraction,
                    enableInfiniteScroll: films.length > 1,
                    autoPlay: false,
                    enlargeCenterPage: true,
                    enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                    enlargeFactor: _enlargeFactor,
                    scrollPhysics: const BouncingScrollPhysics(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Material(
              color: Colors.red,
              borderRadius: BorderRadius.circular(30),
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: () {
                  final filmBloc = context.read<FilmBloc>();

                  Get.to(
                    () => BlocProvider.value(
                      value: filmBloc,
                      child: const MapScreen(),
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Iconsax.map, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Find Cinemas',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPoster(BuildContext context, Film film) {
    final year = film.releaseDate?.year ?? '-';

    return GestureDetector(
      onTap: () => Get.to(() => DetailScreen(film: film)),
      child: Center(
        child: SizedBox(
          width: _posterWidth,
          height: _posterHeight,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    Image.asset(
                      posterForTitle(film.title),
                      height: _posterHeight,
                      width: _posterWidth,
                      fit: BoxFit.cover,
                    ),
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0),
                              Colors.black.withValues(alpha: 0.3),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      film.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$year',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        Flexible(
                          child: Text(
                            'Director: ${film.director}',
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.labelSmall!
                                .copyWith(fontWeight: FontWeight.w200),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
