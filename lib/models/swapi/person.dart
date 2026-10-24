import 'swapi_parsing.dart';

class Person {
  final String name;
  final double? height;
  final double? mass;
  final String hairColor;
  final String skinColor;
  final String eyeColor;
  final String birthYear;
  final String gender;
  final String? homeworld;
  final List<String> films;
  final List<String> species;
  final List<String> vehicles;
  final List<String> starships;
  final DateTime? created;
  final DateTime? edited;
  final String url;

  const Person({
    required this.name,
    required this.height,
    required this.mass,
    required this.hairColor,
    required this.skinColor,
    required this.eyeColor,
    required this.birthYear,
    required this.gender,
    required this.homeworld,
    required this.films,
    required this.species,
    required this.vehicles,
    required this.starships,
    required this.created,
    required this.edited,
    required this.url,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      name: json['name'] ?? '',
      height: swapiDouble(json['height']),
      mass: swapiDouble(json['mass']),
      hairColor: json['hair_color'] ?? '',
      skinColor: json['skin_color'] ?? '',
      eyeColor: json['eye_color'] ?? '',
      birthYear: json['birth_year'] ?? '',
      gender: json['gender'] ?? '',
      homeworld: swapiUrl(json['homeworld']),
      films: swapiUrls(json['films']),
      species: swapiUrls(json['species']),
      vehicles: swapiUrls(json['vehicles']),
      starships: swapiUrls(json['starships']),
      created: swapiDate(json['created']),
      edited: swapiDate(json['edited']),
      url: json['url'] ?? '',
    );
  }

  int? get homeworldId => swapiId(homeworld);

  List<int> get filmIds => films.ids;

  List<int> get speciesIds => species.ids;

  List<int> get vehicleIds => vehicles.ids;

  List<int> get starshipIds => starships.ids;
}
