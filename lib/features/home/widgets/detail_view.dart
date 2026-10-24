import 'package:film_app/features/reminder/screens/reminder_form_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:film_app/core/constants/app_colors.dart';
import 'package:film_app/features/home/data/film_posters.dart';
import 'package:film_app/features/home/widgets/actor_section.dart';
import 'package:film_app/features/home/widgets/planet_section.dart';
import 'package:film_app/models/swapi/swapi.dart';

class DetailView extends StatefulWidget {
  final Film film;

  const DetailView({super.key, required this.film});

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  static const double _posterHeight = 500;

  final ScrollController _scrollController = ScrollController();

  bool _showAppBar = false;
  double _lastScrollOffset = 0;
  bool _showPosterBack = true;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final currentOffset = _scrollController.offset;

    final scrollingUp = currentOffset < _lastScrollOffset;
    final atTop = currentOffset <= 0;

    if (atTop) {
      if (_showAppBar || !_showPosterBack) {
        setState(() {
          _showAppBar = false;
          _showPosterBack = true;
        });
      }
    } else if (scrollingUp) {
      if (!_showAppBar || _showPosterBack) {
        setState(() {
          _showAppBar = true;
          _showPosterBack = false;
        });
      }
    } else if (currentOffset > _lastScrollOffset) {
      if (_showAppBar || _showPosterBack) {
        setState(() {
          _showAppBar = false;
          _showPosterBack = false;
        });
      }
    }

    _lastScrollOffset = currentOffset;
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final film = widget.film;
    final year = film.releaseDate?.year ?? '-';

    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                      child: Stack(
                        children: [
                          Image.asset(
                            posterForTitle(film.title),
                            height: _posterHeight,
                            width: double.infinity,
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
                      top: MediaQuery.of(context).padding.top + 8,
                      left: 12,
                      child: AnimatedOpacity(
                        opacity: _showPosterBack ? 1 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: IgnorePointer(
                          ignoring: !_showPosterBack,
                          child: IconButton(
                            onPressed: () => Get.back(),
                            icon: const Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                            ),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                PlanetSection(film: film),

                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              film.title,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          Text(
                            'Episode ${film.episodeId}',
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(color: Colors.white),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      Text(
                        'Director: ${film.director} • $year',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w200,
                          color: AppColors.secondary,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        film.formattedOpeningCrawl,
                        textAlign: TextAlign.justify,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w200,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Text(
                        'Actors',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),

                      const SizedBox(height: 10),

                      ActorsSection(film: film),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              ignoring: !_showAppBar,
              child: AnimatedSlide(
                offset: _showAppBar ? Offset.zero : const Offset(0, -1),
                duration: const Duration(milliseconds: 200),
                child: AnimatedOpacity(
                  opacity: _showAppBar ? 1 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    height: MediaQuery.of(context).padding.top + 56,
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top,
                    ),
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(Icons.arrow_back_ios_new),
                        ),
                        Expanded(
                          child: Text(
                            film.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
