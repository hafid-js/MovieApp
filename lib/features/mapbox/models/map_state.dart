import 'package:film_app/features/cinema/models/cinema.dart';
import 'package:film_app/features/mapbox/services/direction_service.dart';

class MapState {
  final bool isSimulating;
  final RouteResult? currentRoute;
  final String currentStyle;
  final String remainingDistance;
  final String remainingDuration;
  final Cinema? selectedCinema;

  const MapState({
    this.isSimulating = false,
    this.currentStyle = 'mapbox://styles/mapbox/streets-v12',
    this.currentRoute,
    this.remainingDistance = '',
    this.remainingDuration = '',
    this.selectedCinema,
  });

  MapState copyWith({
    bool? isSimulating,
    String? currentStyle,
    RouteResult? currentRoute,
    bool clearRoute = false,
    String? remainingDistance,
    String? remainingDuration,
    Cinema? selectedCinema,
    bool clearSelectedCinema = false,
  }) {
    return MapState(
      isSimulating: isSimulating ?? this.isSimulating,
      currentStyle: currentStyle ?? this.currentStyle,
      currentRoute: clearRoute ? null : (currentRoute ?? this.currentRoute),
      remainingDistance: remainingDistance ?? this.remainingDistance,
      remainingDuration: remainingDuration ?? this.remainingDuration,
      selectedCinema: clearSelectedCinema
          ? null
          : (selectedCinema ?? this.selectedCinema),
    );
  }
}
