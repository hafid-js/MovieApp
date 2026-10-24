import 'swapi_parsing.dart';

class Film {
  final String title;
  final int episodeId;
  final String openingCrawl;
  final String director;
  final String producer;
  final DateTime? releaseDate;
  final List<String> characters;
  final List<String> planets;
  final List<String> starships;
  final List<String> vehicles;
  final List<String> species;
  final DateTime? created;
  final DateTime? edited;
  final String url;

  const Film({
    required this.title,
    required this.episodeId,
    required this.openingCrawl,
    required this.director,
    required this.producer,
    required this.releaseDate,
    required this.characters,
    required this.planets,
    required this.starships,
    required this.vehicles,
    required this.species,
    required this.created,
    required this.edited,
    required this.url,
  });

  factory Film.fromJson(Map<String, dynamic> json) {
    return Film(
      title: json['title'] ?? '',
      episodeId: (json['episode_id'] as num?)?.toInt() ?? 0,
      openingCrawl: json['opening_crawl'] ?? '',
      director: json['director'] ?? '',
      producer: json['producer'] ?? '',
      releaseDate: swapiDate(json['release_date']),
      characters: swapiUrls(json['characters']),
      planets: swapiUrls(json['planets']),
      starships: swapiUrls(json['starships']),
      vehicles: swapiUrls(json['vehicles']),
      species: swapiUrls(json['species']),
      created: swapiDate(json['created']),
      edited: swapiDate(json['edited']),
      url: json['url'] ?? '',
    );
  }

  String get formattedOpeningCrawl {
    final normalized = openingCrawl
        .replaceAll('\r\n', '\n')
        .replaceAll('\r', '\n');

    return normalized
        .split(RegExp(r'\n\s*\n'))
        .map(
          (paragraph) => paragraph
              .split('\n')
              .map((line) => line.trim())
              .where((line) => line.isNotEmpty)
              .join(' '),
        )
        .where((paragraph) => paragraph.isNotEmpty)
        .join('\n\n');
  }

  List<int> get characterIds => characters.ids;

  List<int> get planetIds => planets.ids;

  List<int> get starshipIds => starships.ids;

  List<int> get vehicleIds => vehicles.ids;

  List<int> get speciesIds => species.ids;
}
