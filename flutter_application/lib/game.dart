class Game {
  // This class represents a game with its details.
  
  final String id;
  final String name;
  final String backgroundImage;
  final String releaseYear;
  final double score;
  final List<String> genres;
  String description;

  Game({
    required this.id,
    required this.name,
    required this.backgroundImage,
    required this.releaseYear,
    required this.score,
    required this.genres,
    this.description = 'Description not loaded yet.',
  });
  
  // Factory constructor to create a Game instance from JSON data
  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'].toString(),
      name: json['name'] ?? 'Unknown',
      backgroundImage: json['background_image'] ?? '',
      releaseYear: json['released'] != null
          ? DateTime.parse(json['released']).year.toString()
          : 'Unknown',
      score: (json['metacritic'] ?? 0).toDouble(),
      genres: (json['genres'] as List<dynamic>?)
              ?.map((genre) => genre['name'] as String)
              .toList() ??
          [],
    );
  }
}