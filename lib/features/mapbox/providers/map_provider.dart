import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:film_app/features/cinema/data/cinema_mock.dart';
import 'package:film_app/features/cinema/models/cinema.dart';
import 'package:film_app/features/mapbox/models/map_state.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:flutter_riverpod/legacy.dart';
import 'package:film_app/features/mapbox/services/direction_service.dart';
import 'package:film_app/features/mapbox/services/location_service.dart';

final mapProvider = StateNotifierProvider<MapNotifier, MapState>(
  (ref) => MapNotifier(),
);

class MapNotifier extends StateNotifier<MapState> {
  MapNotifier() : super(MapState());

  MapboxMap? _mapboxMap;
  geo.Position? _currentPosition;
  PointAnnotationManager? _annotationManager;
  PointAnnotationManager? _cinemaAnnotationManager;
  PointAnnotation? _driverMarker;
  StreamSubscription? _simulationSubscription;

  final _directionService = DirectionService();

  final List<PointAnnotation> _cinemaMarkers = [];
  final Map<String, Cinema> _cinemaByMarkerId = {};

  static const String _routeSourceId = 'route-source';
  static const String _routeLayerId = 'route-layer';

  bool _isDisposed = false;

  void selectCinema(Cinema cinema) {
    state = state.copyWith(selectedCinema: cinema);
  }

  void clearSelectedCinema() {
    state = state.copyWith(clearSelectedCinema: true);
  }

  Future<void> onMapCreated(MapboxMap mapboxMap) async {
    _annotationManager = await mapboxMap.annotations
        .createPointAnnotationManager(id: 'driver-layer', below: '');
    _cinemaAnnotationManager = await mapboxMap.annotations
        .createPointAnnotationManager(id: 'cinema-layer');
    _mapboxMap = mapboxMap;
    _registerCinemaClickListener();

    await mapboxMap.location.updateSettings(
      LocationComponentSettings(
        enabled: true,
        pulsingEnabled: true,
        showAccuracyRing: true,
      ),
    );

    await initLocation();
    await addCinemaMarkers();
  }

  Future<void> addCinemaMarkers() async {
    if (_isDisposed) return;

    final map = _mapboxMap;
    final manager = _cinemaAnnotationManager;

    if (map == null || manager == null) return;

    try {
      final isLoaded = await map.style.isStyleLoaded();

      if (_isDisposed || _mapboxMap == null) return;
      if (!isLoaded) return;

      for (final marker in _cinemaMarkers) {
        if (_isDisposed) return;
        await manager.delete(marker);
      }

      _cinemaMarkers.clear();
      _cinemaByMarkerId.clear();

      if (_isDisposed) return;

      final bytes = await rootBundle.load('assets/images/marker.png');

      if (_isDisposed || _mapboxMap == null) return;

      await map.style.addStyleImage(
        'cinema-marker',
        1.0,
        MbxImage(width: 512, height: 512, data: bytes.buffer.asUint8List()),
        false,
        [],
        [],
        null,
      );

      if (_isDisposed) return;

      for (final cinema in cinemaMocks) {
        if (_isDisposed) return;

        final marker = await manager.create(
          PointAnnotationOptions(
            geometry: Point(
              coordinates: Position(cinema.longitude, cinema.latitude),
            ),
            iconImage: 'cinema-marker',
            iconSize: 0.1,
            iconAnchor: IconAnchor.BOTTOM,
          ),
        );

        if (_isDisposed) {
          await manager.delete(marker);
          return;
        }

        _cinemaMarkers.add(marker);
        _cinemaByMarkerId[marker.id] = cinema;
      }
    } catch (e, stackTrace) {
      if (!_isDisposed) {
        debugPrint('addCinemaMarkers error: $e');
        debugPrintStack(stackTrace: stackTrace);
      }
    }
  }

  void _registerCinemaClickListener() {
    final manager = _cinemaAnnotationManager;
    if (manager == null) return;

    manager.addOnPointAnnotationClickListener(
      CinemaAnnotationClickListener((annotation) {
        final cinema = _cinemaByMarkerId[annotation.id];

        if (cinema != null) {
          selectCinema(cinema);
        }
      }),
    );
  }

  Future<void> routeToCinema({
    required double longitude,
    required double latitude,
  }) async {
    final position = await LocationService.getCurrentLocation();

    if (position == null) {
      return;
    }

    _currentPosition = position;

    final route = await _directionService.getRoute(
      originLng: position.longitude,
      originLat: position.latitude,
      destinationLng: longitude,
      destinationLat: latitude,
    );

    if (route == null) return;

    state = state.copyWith(currentRoute: route);

    await _drawRoute(route);
    await _fitRouteBounds(route);
  }

  Future<void> initLocation() async {
    final position = await LocationService.getCurrentLocation();
    if (position != null) {
      _currentPosition = position;
      await flyToLocation(position.longitude, position.latitude, zoom: 14);
    }
  }

  Future<void> flyToLocation(double lng, double lat, {double zoom = 14}) async {
    await _mapboxMap?.flyTo(
      CameraOptions(
        center: Point(coordinates: Position(lng, lat)),
        zoom: zoom,
        bearing: 0,
        pitch: 0,
      ),
      MapAnimationOptions(duration: 1500),
    );
  }
  Future<void> _drawRoute(RouteResult route) async {
    if (_isDisposed || _mapboxMap == null) return;

    final map = _mapboxMap!;

    final styleLoaded = await map.style.isStyleLoaded();

    if (_isDisposed || _mapboxMap == null) return;
    if (!styleLoaded) return;
    await clearRoute(clearState: false);

    final geoJson = {
      'type': 'Feature',
      'geometry': {'type': 'LineString', 'coordinates': route.coordinates},
    };

    await map.style.addSource(
      GeoJsonSource(id: _routeSourceId, data: jsonEncode(geoJson)),
    );

    await map.style.addLayer(
      LineLayer(
        id: _routeLayerId,
        sourceId: _routeSourceId,
        lineColor: 0xFF4A90D9,
        lineWidth: 5.0,
        lineCap: LineCap.ROUND,
        lineJoin: LineJoin.ROUND,
      ),
    );
  }

  Future<void> _updateRouteProgress(List<List<double>> coordinates) async {
    final map = _mapboxMap;
    if (map == null || coordinates.isEmpty) return;

    final isLoaded = await map.style.isStyleLoaded();
    if (!isLoaded) return;

    final geoJson = {
      'type': 'Feature',
      'geometry': {'type': 'LineString', 'coordinates': coordinates},
    };

    await map.style.setStyleSourceProperty(
      _routeSourceId,
      'data',
      jsonEncode(geoJson),
    );
  }

  Future<void> clearRoute({bool clearState = true}) async {
    if (clearState) {
      await stopDriver();
      await _annotationManager?.deleteAll();
      _driverMarker = null;
    }
    final map = _mapboxMap;
    if (map == null) return;
    try {
      await map.style.removeStyleLayer(_routeLayerId);
      await map.style.removeStyleSource(_routeSourceId);
    } catch (_) {}
    if (clearState) {
      state = state.copyWith(clearRoute: true);
    }
  }

  Future<void> _fitRouteBounds(RouteResult route) async {
    if (route.coordinates.isEmpty) return;

    double minLng = route.coordinates[0][0];
    double maxLng = route.coordinates[0][0];
    double minLat = route.coordinates[0][1];
    double maxLat = route.coordinates[0][1];

    for (final c in route.coordinates) {
      if (c[0] < minLng) minLng = c[0];
      if (c[0] > maxLng) maxLng = c[0];
      if (c[1] < minLat) minLat = c[1];
      if (c[1] > maxLat) maxLat = c[1];
    }

    await _mapboxMap
        ?.cameraForCoordinateBounds(
          CoordinateBounds(
            southwest: Point(coordinates: Position(minLng, minLat)),
            northeast: Point(coordinates: Position(maxLng, maxLat)),
            infiniteBounds: false,
          ),
          MbxEdgeInsets(top: 100, left: 50, bottom: 200, right: 50),
          null,
          null,
          null,
          null,
        )
        .then(
          (camera) =>
              _mapboxMap?.flyTo(camera, MapAnimationOptions(duration: 1500)),
        );
  }

  Future<void> recenterLocation() async {
    final pos = await LocationService.getCurrentLocation();
    if (pos != null) {
      _currentPosition = pos;
      await flyToLocation(pos.longitude, pos.latitude, zoom: 15);
    }
  }

  Future<void> _createDriverMarker(double lng, double lat) async {
    if (_mapboxMap == null || _annotationManager == null) return;

    final isLoaded = await _mapboxMap?.style.isStyleLoaded() ?? false;
    if (!isLoaded) await Future.delayed(const Duration(milliseconds: 500));

    if (_driverMarker != null) {
      try {
        await _annotationManager?.delete(_driverMarker!);
      } catch (_) {}
      _driverMarker = null;
    }

    final ByteData bytes = await rootBundle.load('assets/images/marker.png');
    final imageData = bytes.buffer.asUint8List();

    await _mapboxMap?.style.addStyleImage(
      'driver-marker',
      1.0,
      MbxImage(width: 512, height: 512, data: imageData),
      false,
      [],
      [],
      null,
    );

    _driverMarker = await _annotationManager?.create(
      PointAnnotationOptions(
        geometry: Point(coordinates: Position(lng, lat)),
        iconImage: 'driver-marker',
        iconSize: 0.05,
        iconAnchor: IconAnchor.BOTTOM,
      ),
    );
  }

  Future<void> startDriver(RouteResult route) async {
    if (route.coordinates.isEmpty) return;

    await stopDriver();

    final smoothCoords = _interpolateCoordinates(route.coordinates, steps: 20);

    if (smoothCoords.isEmpty) return;

    state = state.copyWith(
      isSimulating: true,
      remainingDistance: route.distanceText,
      remainingDuration: route.durationText,
    );

    // final start = smoothCoords.first;
    // await _createDriverMarker(start[0], start[1]);

    await _updateRouteProgress(smoothCoords);

    final totalSteps = smoothCoords.length;
    int index = 0;

    _simulationSubscription = Stream.periodic(const Duration(milliseconds: 100))
        .listen((_) async {
          if (index >= totalSteps) {
            await _simulationSubscription?.cancel();
            _simulationSubscription = null;

            state = state.copyWith(
              isSimulating: false,
              remainingDistance: '0 m',
              remainingDuration: '0 min',
            );
            return;
          }

          final lng = smoothCoords[index][0];
          final lat = smoothCoords[index][1];

          if (_driverMarker != null) {
            _driverMarker!.geometry = Point(coordinates: Position(lng, lat));

            await _annotationManager?.update(_driverMarker!);
          }

          final remainingRoute = smoothCoords.sublist(index);

          if (remainingRoute.length >= 2) {
            await _updateRouteProgress(remainingRoute);
          }

          await _mapboxMap?.easeTo(
            CameraOptions(
              center: Point(coordinates: Position(lng, lat)),
              zoom: 16,
              pitch: 45,
              bearing: _calculateBearing(smoothCoords, index),
            ),
            MapAnimationOptions(duration: 100),
          );

          final progress = index / totalSteps;

          state = state.copyWith(
            remainingDistance: _formatDistance(
              route.distanceMeters * (1 - progress),
            ),
            remainingDuration: _formatDuration(
              route.durationSeconds * (1 - progress),
            ),
          );

          index++;
        });
  }

  Future<void> stopDriver({bool removeMarker = true}) async {
    await _simulationSubscription?.cancel();
    _simulationSubscription = null;

    final marker = _driverMarker;
    _driverMarker = null;

    if (removeMarker && marker != null && !_isDisposed) {
      try {
        await _annotationManager?.delete(_driverMarker!);
      } catch (e) {
        debugPrint('Delete marker error: $e');
      }
      _driverMarker = null;
    }

    if (!_isDisposed) {
      state = state.copyWith(
        isSimulating: false,
        remainingDistance: '',
        remainingDuration: '',
      );
    }
  }

  String _formatDuration(double seconds) {
    final minutes = (seconds / 60).round();
    if (minutes >= 60) {
      final h = minutes ~/ 60;
      final m = minutes % 60;
      return '${h}h ${m}min';
    }
    return '$minutes min';
  }

  String _formatDistance(double meters) {
    if (meters >= 1000) return '${(meters / 1000).toStringAsFixed(1)} km';
    return '${meters.toInt()} m';
  }

  List<List<double>> _interpolateCoordinates(
    List<List<double>> coords, {
    int steps = 10,
  }) {
    final result = <List<double>>[];
    for (int i = 0; i < coords.length - 1; i++) {
      final startLng = coords[i][0];
      final startLat = coords[i][1];
      final endLng = coords[i + 1][0];
      final endLat = coords[i + 1][1];
      for (int step = 0; step < steps; step++) {
        final t = step / steps;
        result.add([
          startLng + (endLng - startLng) * t,
          startLat + (endLat - startLat) * t,
        ]);
      }
    }
    result.add(coords.last);
    return result;
  }

  double _calculateBearing(List<List<double>> coords, int index) {
    if (index >= coords.length - 1) return 0;
    final lat1 = coords[index][1] * (math.pi / 180);
    final lat2 = coords[index + 1][1] * (math.pi / 180);
    final dLon = (coords[index + 1][0] - coords[index][0]) * (math.pi / 180);
    final y = math.sin(dLon) * math.cos(lat2);
    final x =
        math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLon);
    return (math.atan2(y, x) * (180 / math.pi) + 360) % 360;
  }

  geo.Position? get currentPosition => _currentPosition;

  @override
  void dispose() {
    _isDisposed = true;

    _simulationSubscription?.cancel();
    _simulationSubscription = null;

    super.dispose();
  }
}

class CinemaAnnotationClickListener extends OnPointAnnotationClickListener {
  final void Function(PointAnnotation annotation) onClick;

  CinemaAnnotationClickListener(this.onClick);

  @override
  void onPointAnnotationClick(PointAnnotation annotation) {
    onClick(annotation);
  }
}
