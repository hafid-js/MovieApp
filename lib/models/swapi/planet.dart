import 'swapi_parsing.dart';

class Planet {
  final String name;
  final int? rotationPeriod;
  final int? orbitalPeriod;
  final double? diameter;
  final String climate;
  final String gravity;
  final String terrain;
  final double? surfaceWater;
  final int? population;
  final List<String> residents;
  final List<String> films;
  final DateTime? created;
  final DateTime? edited;
  final String url;

  const Planet({
    required this.name,
    required this.rotationPeriod,
    required this.orbitalPeriod,
    required this.diameter,
    required this.climate,
    required this.gravity,
    required this.terrain,
    required this.surfaceWater,
    required this.population,
    required this.residents,
    required this.films,
    required this.created,
    required this.edited,
    required this.url,
  });

  factory Planet.fromJson(Map<String, dynamic> json) {
    return Planet(
      name: json['name'] ?? '',
      rotationPeriod: swapiInt(json['rotation_period']),
      orbitalPeriod: swapiInt(json['orbital_period']),
      diameter: swapiDouble(json['diameter']),
      climate: json['climate'] ?? '',
      gravity: json['gravity'] ?? '',
      terrain: json['terrain'] ?? '',
      surfaceWater: swapiDouble(json['surface_water']),
      population: swapiInt(json['population']),
      residents: swapiUrls(json['residents']),
      films: swapiUrls(json['films']),
      created: swapiDate(json['created']),
      edited: swapiDate(json['edited']),
      url: json['url'] ?? '',
    );
  }

  List<int> get residentIds => residents.ids;

  List<int> get filmIds => films.ids;
}
