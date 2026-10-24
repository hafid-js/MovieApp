import 'package:flutter_test/flutter_test.dart';
import 'package:film_app/models/swapi/swapi.dart';

void main() {
  group('Person', () {
    test('parses person and relationship ids', () {
      final person = Person.fromJson({
        'name': 'Luke Skywalker',
        'height': '172',
        'mass': '77',
        'hair_color': 'blond',
        'skin_color': 'fair',
        'eye_color': 'blue',
        'birth_year': '19BBY',
        'gender': 'male',
        'homeworld': 'https://swapi.dev/api/planets/1/',
        'films': [
          'https://swapi.dev/api/films/1/',
          'https://swapi.dev/api/films/2/',
          'https://swapi.dev/api/films/3/',
          'https://swapi.dev/api/films/6/',
        ],
        'species': <String>[],
        'vehicles': [
          'https://swapi.dev/api/vehicles/14/',
          'https://swapi.dev/api/vehicles/30/',
        ],
        'starships': [
          'https://swapi.dev/api/starships/12/',
          'https://swapi.dev/api/starships/22/',
        ],
        'created': '2014-12-09T13:50:51.644000Z',
        'edited': '2014-12-20T21:17:56.891000Z',
        'url': 'https://swapi.dev/api/people/1/',
      });

      expect(person.name, 'Luke Skywalker');
      expect(person.height, 172);
      expect(person.mass, 77);
      expect(person.homeworldId, 1);
      expect(person.filmIds, [1, 2, 3, 6]);
      expect(person.speciesIds, isEmpty);
      expect(person.vehicleIds, [14, 30]);
      expect(person.starshipIds, [12, 22]);
      expect(person.created, DateTime.utc(2014, 12, 9, 13, 50, 51, 644));
    });
  });

  group('Film', () {
    test('parses film and release date', () {
      final film = Film.fromJson({
        'title': 'A New Hope',
        'episode_id': 4,
        'opening_crawl': 'It is a period of civil war.',
        'director': 'George Lucas',
        'producer': 'Gary Kurtz, Rick McCallum',
        'release_date': '1977-05-25',
        'characters': [
          'https://swapi.dev/api/people/1/',
          'https://swapi.dev/api/people/2/',
        ],
        'planets': ['https://swapi.dev/api/planets/1/'],
        'starships': ['https://swapi.dev/api/starships/2/'],
        'vehicles': ['https://swapi.dev/api/vehicles/4/'],
        'species': ['https://swapi.dev/api/species/1/'],
        'created': '2014-12-10T14:23:31.880000Z',
        'edited': '2014-12-20T19:49:45.256000Z',
        'url': 'https://swapi.dev/api/films/1/',
      });

      expect(film.title, 'A New Hope');
      expect(film.episodeId, 4);
      expect(film.releaseDate, DateTime(1977, 5, 25));
      expect(film.characterIds, [1, 2]);
      expect(film.planetIds, [1]);
      expect(film.starshipIds, [2]);
      expect(film.vehicleIds, [4]);
      expect(film.speciesIds, [1]);
    });
  });

  group('Planet', () {
    test('parses numeric strings and unknown values', () {
      final planet = Planet.fromJson({
        'name': 'Coruscant',
        'rotation_period': '24',
        'orbital_period': '368',
        'diameter': '12240',
        'climate': 'temperate',
        'gravity': '1 standard',
        'terrain': 'cityscape, mountains',
        'surface_water': 'unknown',
        'population': '1000000000000',
        'residents': [
          'https://swapi.dev/api/people/34/',
          'https://swapi.dev/api/people/55/',
        ],
        'films': ['https://swapi.dev/api/films/3/'],
        'created': '2014-12-10T11:54:13.921000Z',
        'edited': '2014-12-20T20:58:18.432000Z',
        'url': 'https://swapi.dev/api/planets/9/',
      });

      expect(planet.name, 'Coruscant');
      expect(planet.rotationPeriod, 24);
      expect(planet.orbitalPeriod, 368);
      expect(planet.diameter, 12240);
      expect(planet.surfaceWater, isNull);
      expect(planet.population, 1000000000000);
      expect(planet.residentIds, [34, 55]);
      expect(planet.filmIds, [3]);
    });
  });

  group('Species', () {
    test('parses n/a, indefinite, and null homeworld', () {
      final species = Species.fromJson({
        'name': 'Droid',
        'classification': 'artificial',
        'designation': 'sentient',
        'average_height': 'n/a',
        'skin_colors': 'n/a',
        'hair_colors': 'n/a',
        'eye_colors': 'n/a',
        'average_lifespan': 'indefinite',
        'homeworld': null,
        'language': 'n/a',
        'people': [
          'https://swapi.dev/api/people/2/',
          'https://swapi.dev/api/people/3/',
        ],
        'films': ['https://swapi.dev/api/films/1/'],
        'created': '2014-12-10T15:16:16.259000Z',
        'edited': '2014-12-20T21:36:42.139000Z',
        'url': 'https://swapi.dev/api/species/2/',
      });

      expect(species.name, 'Droid');
      expect(species.averageHeight, isNull);
      expect(species.averageLifespan, isNull);
      expect(species.homeworld, isNull);
      expect(species.homeworldId, isNull);
      expect(species.peopleIds, [2, 3]);
      expect(species.filmIds, [1]);
    });
  });

  group('Vehicle', () {
    test('parses unknown cost and keeps crew as string', () {
      final vehicle = Vehicle.fromJson({
        'name': 'TIE/LN starfighter',
        'model': 'Twin Ion Engine/Ln Starfighter',
        'manufacturer': 'Sienar Fleet Systems',
        'cost_in_credits': 'unknown',
        'length': '6.4',
        'max_atmosphering_speed': '1200',
        'crew': '1',
        'passengers': '0',
        'cargo_capacity': '65',
        'consumables': '2 days',
        'vehicle_class': 'starfighter',
        'pilots': <String>[],
        'films': ['https://swapi.dev/api/films/1/'],
        'created': '2014-12-10T16:33:52.860000Z',
        'edited': '2014-12-20T21:30:21.670000Z',
        'url': 'https://swapi.dev/api/vehicles/8/',
      });

      expect(vehicle.costInCredits, isNull);
      expect(vehicle.length, 6.4);
      expect(vehicle.maxAtmospheringSpeed, 1200);
      expect(vehicle.crew, '1');
      expect(vehicle.passengers, 0);
      expect(vehicle.cargoCapacity, 65);
      expect(vehicle.vehicleClass, 'starfighter');
      expect(vehicle.pilotIds, isEmpty);
      expect(vehicle.filmIds, [1]);
    });
  });

  group('Starship', () {
    test('parses comma separated numbers and MGLT', () {
      final starship = Starship.fromJson({
        'name': 'Death Star',
        'model': 'DS-1 Orbital Battle Station',
        'manufacturer': 'Imperial Department of Military Research',
        'cost_in_credits': '1000000000000',
        'length': '120000',
        'max_atmosphering_speed': 'n/a',
        'crew': '342,953',
        'passengers': '843,342',
        'cargo_capacity': '1000000000000',
        'consumables': '3 years',
        'hyperdrive_rating': '4.0',
        'MGLT': '10',
        'starship_class': 'Deep Space Mobile Battlestation',
        'pilots': <String>[],
        'films': ['https://swapi.dev/api/films/1/'],
        'created': '2014-12-10T16:36:50.509000Z',
        'edited': '2014-12-20T21:26:24.783000Z',
        'url': 'https://swapi.dev/api/starships/9/',
      });

      expect(starship.crew, '342,953');
      expect(starship.passengers, 843342);
      expect(starship.costInCredits, 1000000000000);
      expect(starship.maxAtmospheringSpeed, isNull);
      expect(starship.hyperdriveRating, 4);
      expect(starship.mglt, 10);
      expect(starship.starshipClass, 'Deep Space Mobile Battlestation');
      expect(starship.filmIds, [1]);
    });
  });

  group('SwapiListResponse', () {
    test('parses list response', () {
      final page = SwapiListResponse<Person>.fromJson({
        'count': 82,
        'results': [
          {
            'name': 'Luke Skywalker',
            'homeworld': 'https://swapi.dev/api/planets/1/',
            'films': <String>[],
            'species': <String>[],
            'vehicles': <String>[],
            'starships': <String>[],
            'url': 'https://swapi.dev/api/people/1/',
          },
        ],
      }, Person.fromJson);

      expect(page.count, 82);
      expect(page.results.single.name, 'Luke Skywalker');
      expect(page.results.single.homeworldId, 1);
    });
  });

  group('swapiId', () {
    test('handles valid and invalid urls', () {
      expect(swapiId('https://swapi.dev/api/films/6/'), 6);
      expect(swapiId('https://swapi.dev/api/films/6'), 6);
      expect(swapiId('https://swapi.dev/api/films/'), isNull);
      expect(swapiId(''), isNull);
      expect(swapiId(null), isNull);
    });
  });
}
