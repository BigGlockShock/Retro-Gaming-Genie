import 'package:flutter/material.dart';
import '../game_service.dart';
import '../game.dart';
import 'genie_page.dart';

class GamePage extends StatefulWidget {
  // Parameters for the GamePage
  final String platform;
  final String genre;
  final String platformName;

  // Constructor to initialize the GamePage with platform, genre, and platformName
  const GamePage({super.key, required this.platform, required this.genre, required this.platformName});
  
  // Override the createState method to create the state for this widget
  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  // Future to hold the list of games fetched from the GameService
  late Future<List<Game>> _games;

  // Instance of GameService to fetch games
  final GameService _gameService = GameService();
  
  // Initialize the state by fetching games based on the platform and genre
  @override
  void initState() {
    super.initState();
    _games = _gameService.fetchGamesByCategory(widget.platform, widget.genre,);
  }
  
  // Method to navigate to the GeniePage with the selected game
  void _navigateToGeniePage(Game selectedGame) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GeniePage(selectedGame: selectedGame, platformName: widget.platformName,),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    // Build the UI for the GamePage
    // Scaffold provides the basic structure for the page
    return Scaffold(

      // AppBar with title and background color
      appBar: AppBar(
        title: Text(

          // Title of the AppBar combining platform name and genre
          '${widget.platformName} - ${widget.genre}',
          style: const TextStyle(fontFamily: 'PressStart2P'),
        ),
        backgroundColor: Colors.tealAccent,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,

      // Body of the Scaffold containing a FutureBuilder to handle asynchronous data fetching
      body: FutureBuilder<List<Game>>(
        future: _games,

        // Builder function to build the UI based on the state of the Future
        builder: (context, snapshot) {

          // Check the connection state of the Future
          // If the Future is still loading, show a loading indicator
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.tealAccent),
            );

            // If the Future has an error, show an error message
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.redAccent, fontFamily: 'PressStart2P'),
              ),
            );

            // If the Future has data but it's empty, show a message indicating no games found
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No games found.',
                style: TextStyle(color: Colors.tealAccent, fontFamily: 'PressStart2P'),
              ),
            );
          }

          // If the Future has data, build the ListView to display the games
          final games = snapshot.data!;

          // Use ListView.builder for efficient list rendering
          // Each game is displayed in a Card with its details
          // Each card contains the game's image, name, release year, genres, score, description, and buttons to load description and ask the genie
          return ListView.builder(

            // Set the item count to the number of games
            itemCount: games.length,

            // Use itemBuilder to build each item in the list
            itemBuilder: (context, index) {
              final game = games[index];
              return Card(
                color: Colors.grey[900],
                margin: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [

                          // Display the game's background image or a default icon if the image is not available
                          game.backgroundImage.isNotEmpty
                              ? Image.network(
                                  game.backgroundImage,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(Icons.videogame_asset, size: 100, color: Colors.tealAccent),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(

                                  // Display the game's name in bold with a specific font style
                                  game.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'PressStart2P',
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  // Display the game's release year, genres, and score
                                  'Release Year: ${game.releaseYear}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                    fontFamily: 'PressStart2P',
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Genres: ${game.genres.join(', ') }',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                    fontFamily: 'PressStart2P',
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Score: ${game.score}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                    fontFamily: 'PressStart2P',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(

                        // Display the game's description, limited to 100 lines and with ellipsis for overflow
                        'Description: ${game.description}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.tealAccent,
                          fontFamily: 'PressStart2P',
                        ),
                        maxLines: 100,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(

                        // Button to load the game's description
                        // Description not contained in the initial game data
                        // When pressed, it fetches the description from the GameService
                        onPressed: () async {
                          try {
                            final description = await _gameService.fetchGameDescription(game.id);
                            setState(() {
                              game.description = description;
                            });
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed to load description: $e')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.tealAccent,
                          foregroundColor: Colors.black,
                        ),
                        child: const Text(
                          'Load Description',
                          style: TextStyle(fontFamily: 'PressStart2P'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(

                        // Button to navigate to the GeniePage with the selected game
                        onPressed: () => _navigateToGeniePage(game),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purpleAccent,
                          foregroundColor: Colors.black,
                        ),
                        child: const Text(
                          'Ask Genie',
                          style: TextStyle(fontFamily: 'PressStart2P'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}