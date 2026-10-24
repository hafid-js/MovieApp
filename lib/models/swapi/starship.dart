import 'swapi_parsing.dart';

class Starship {
  final String name;
  final String model;
  final String manufacturer;
  final int? costInCredits;
  final double? length;
  final int? maxAtmospheringSpeed;
  final String crew;
  final int? passengers;
  final int? cargoCapacity;
  final String consumables;
  final double? hyperdriveRating;
  final int? mglt;
  final String starshipClass;
  final List<String> pilots;
  final List<String> films;
  final DateTime? created;
  final DateTime? edited;
  final String url;

  const Starship({
    required this.name,
    required this.model,
    required this.manufacturer,
    required this.costInCredits,
    required this.length,
    required this.maxAtmospheringSpeed,
    required this.crew,
    required this.passengers,
    required this.cargoCapacity,
    required this.consumables,
    required this.hyperdriveRating,
    required this.mglt,
    required this.starshipClass,
    required this.pilots,
    required this.films,
    required this.created,
    required this.edited,
    required this.url,
  });

  factory Starship.fromJson(Map<String, dynamic> json) {
    return Starship(
      name: json['name'] ?? '',
      model: json['model'] ?? '',
      manufacturer: json['manufacturer'] ?? '',
      costInCredits: swapiInt(json['cost_in_credits']),
      length: swapiDouble(json['length']),
      maxAtmospheringSpeed: swapiInt(json['max_atmosphering_speed']),
      crew: json['crew'] ?? '',
      passengers: swapiInt(json['passengers']),
      cargoCapacity: swapiInt(json['cargo_capacity']),
      consumables: json['consumables'] ?? '',
      hyperdriveRating: swapiDouble(json['hyperdrive_rating']),
      mglt: swapiInt(json['MGLT']),
      starshipClass: json['starship_class'] ?? '',
      pilots: swapiUrls(json['pilots']),
      films: swapiUrls(json['films']),
      created: swapiDate(json['created']),
      edited: swapiDate(json['edited']),
      url: json['url'] ?? '',
    );
  }

  List<int> get pilotIds => pilots.ids;

  List<int> get filmIds => films.ids;
}
