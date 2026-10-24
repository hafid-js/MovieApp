import 'package:film_app/features/home/presentation/bloc/film_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/route_manager.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:film_app/features/cinema/screens/detail_cinema.dart';
import 'package:film_app/features/cinema/widgets/cinema_popup.dart';
import 'package:film_app/features/mapbox/providers/map_provider.dart';
import 'package:film_app/features/mapbox/widgets/route_info_card.dart';

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapState = ref.watch(mapProvider);
    final notifier = ref.read(mapProvider.notifier);
    final selectedCinema = mapState.selectedCinema;
    return Scaffold(
      body: Stack(
        children: [
          MapWidget(
            key: ValueKey('mapWidget'),
            styleUri: mapState.currentStyle,
            cameraOptions: CameraOptions(
              center: Point(coordinates: Position(106.826666, -6.175275)),
              zoom: 13,
            ),
            onMapCreated: notifier.onMapCreated,
          ),
          Positioned(
            bottom: mapState.currentRoute != null ? 130 : 50,
            right: 16,
            child: FloatingActionButton(
              elevation: 3,
              heroTag: 'location',
              backgroundColor: Theme.of(context).cardColor,
              foregroundColor: Theme.of(context).cardColor,
              onPressed: notifier.recenterLocation,
              child: Icon(Icons.my_location, color: Colors.white),
            ),
          ),

          Positioned(
            bottom: mapState.currentRoute != null ? 130 : 50,
            left: 16,
            child: FloatingActionButton.small(
              heroTag: 'back',
              backgroundColor: Theme.of(context).cardColor,
              onPressed: () async {
                await ref.read(mapProvider.notifier).stopDriver();
                Get.back();
              },
              child: const Padding(
                padding: EdgeInsets.only(left: 4),
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          if (mapState.currentRoute != null)
            Positioned(
              bottom: 30,
              left: 16,
              right: 16,
              child: RouteInfoCard(
                route: mapState.currentRoute!,
                isSimulating: mapState.isSimulating,
                remainingDistance: mapState.remainingDistance,
                remainingDuration: mapState.remainingDuration,
                onClear: notifier.clearRoute,
                onDrive: () => mapState.isSimulating
                    ? notifier.stopDriver()
                    : notifier.startDriver(mapState.currentRoute!),
              ),
            ),

          if (selectedCinema != null)
            Positioned(
              left: 16,
              right: 16,
              bottom: mapState.currentRoute != null ? 190 : 110,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {},
                child: CinemaPopup(
                  cinema: selectedCinema,
                  onClose: notifier.clearSelectedCinema,
                  onViewDetail: () {
                    FilmBloc? filmBloc;
                    try {
                      filmBloc = context.read<FilmBloc>();
                    } catch (e) {
                      print('FilmBloc tidak ditemukan di context: $e');
                    }
                    Get.to(
                      () => filmBloc != null
                          ? BlocProvider.value(
                              value: filmBloc,
                              child: DetailCinema(
                                cinema: selectedCinema,
                                onClearSelectedCinema: notifier,
                                onRouteCinema: () {
                                  notifier.routeToCinema(
                                    longitude: selectedCinema.longitude,
                                    latitude: selectedCinema.latitude,
                                  );
                                  notifier.clearSelectedCinema();
                                },
                              ),
                            )
                          : DetailCinema(
                              cinema: selectedCinema,
                              onClearSelectedCinema: notifier,
                              onRouteCinema: () {
                                notifier.routeToCinema(
                                  longitude: selectedCinema.longitude,
                                  latitude: selectedCinema.latitude,
                                );
                                notifier.clearSelectedCinema();
                              },
                            ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
