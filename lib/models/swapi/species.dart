import 'swapi_parsing.dart';

class Species {
  final String name;
  final String classification;
  final String designation;
  final double? averageHeight;
  final String skinColors;
  final String hairColors;
  final String eyeColors;
  final int? averageLifespan;
  final String? homeworld;
  final String language;
  final List<String> people;
  final List<String> films;
  final DateTime? created;
  final DateTime? edited;
  final String url;

  const Species({
    required this.name,
    required this.classification,
    required this.designation,
    required this.averageHeight,
    required this.skinColors,
    required this.hairColors,
    required this.eyeColors,
    required this.averageLifespan,
    required this.homeworld,
    required this.language,
    required this.people,
    required this.films,
    required this.created,
    required this.edited,
    required this.url,
  });

  factory Species.fromJson(Map<String, dynamic> json) {
    return Species(
      name: json['name'] ?? '',
      classification: json['classification'] ?? '',
      designation: json['designation'] ?? '',
      averageHeight: swapiDouble(json['average_height']),
      skinColors: json['skin_colors'] ?? '',
      hairColors: json['hair_colors'] ?? '',
      eyeColors: json['eye_colors'] ?? '',
      averageLifespan: swapiInt(json['average_lifespan']),
      homeworld: swapiUrl(json['homeworld']),
      language: json['language'] ?? '',
      people: swapiUrls(json['people']),
      films: swapiUrls(json['films']),
      created: swapiDate(json['created']),
      edited: swapiDate(json['edited']),
      url: json['url'] ?? '',
    );
  }

  int? get homeworldId => swapiId(homeworld);

  List<int> get peopleIds => people.ids;

  List<int> get filmIds => films.ids;
}
