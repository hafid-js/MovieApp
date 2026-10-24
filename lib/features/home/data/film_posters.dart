const Map<String, String> _filmPosters = {
  'A New Hope': 'assets/images/film/a-new-hope.png',
  'The Empire Strikes Back': 'assets/images/film/the-empire-strikes-back.png',
  'Return of the Jedi': 'assets/images/film/return-of-jedi.png',
  'The Phantom Menace': 'assets/images/film/the-phantom-menace.png',
  'Attack of the Clones': 'assets/images/film/attack-of-the-clones.png',
  'Revenge of the Sith': 'assets/images/film/revenge-of-the-sith.png',
};

String posterForTitle(String title) {
  return _filmPosters[title] ?? 'assets/images/film/a-new-hope.png';
}
