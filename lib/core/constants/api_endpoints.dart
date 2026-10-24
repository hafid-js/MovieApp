class ApiEndpoints {
  ApiEndpoints._();

  static const baseUrl = "https://swapi.dev/api";

  static const people = "/people";
  static const planets = "/planets";
  static const films = "/films";
  static const species = "/species";
  static const vehicles = "/vehicles";
  static const starships = "/starships";

  static String detailPerson(int id) => "$people/$id";

  static String detailPlanet(int id) => "$planets/$id";

  static String detailFilm(int id) => "$films/$id";

  static String detailSpecies(int id) => "$species/$id";

  static String detailVehicle(int id) => "$vehicles/$id";

  static String detailStarship(int id) => "$starships/$id";
}
