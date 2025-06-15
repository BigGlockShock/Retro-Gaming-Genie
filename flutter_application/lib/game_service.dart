import 'dart:convert';
import 'package:http/http.dart' as http;
import 'game.dart';

class GameService {
  // This class handles communication with the backend server to fetch game data.
  final String _backendUrl = 'http://localhost:8000'; // Backend server URL

 // Fetches a list of games based on platform and genre
  Future<String> fetchGameDescription(String gameId) async {
    final response = await http.get(Uri.parse('$_backendUrl/games/$gameId'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['description_raw'] ?? 'No description available.';
    } else {
      throw Exception('Failed to load game description');
    }
  }
  // Fetches a list of games based on the selected platform and genre
  Future<List<Game>> fetchGamesByCategory(String platform, String genre) async {
    final response = await http.get(Uri.parse('$_backendUrl/games?platform=$platform&genre=$genre'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List games = data['results'];
      return games.map((game) => Game.fromJson(game)).toList();
    } else {
      throw Exception('Failed to load games');
    }
  }
}
