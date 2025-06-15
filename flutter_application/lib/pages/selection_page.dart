import 'package:flutter/material.dart';
import 'game_page.dart';

class SelectionPage extends StatefulWidget {
  const SelectionPage({super.key});

  @override
  // Create a state for the SelectionPage
  State<SelectionPage> createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {

  // List of platforms 
  final List<String> platforms = [
    'PlayStation 1',
    'PlayStation 2',
    'Sega Genesis',
    'Sega Dreamcast',
    'Nintendo 64',
    'Game Boy Advance',
    'Game Boy Color',
    'Super Nintendo',
    'GameCube',
    'Commodore 64',
    'Atari 2600',
    'Atari 5200',
    'Atari 7800',
  ];

  // Map of platform names to their corresponding codes
  final Map<String, String> platformCodes = {
    'PlayStation 1': '27',
    'PlayStation 2': '15',
    'Sega Genesis': '167',
    'Sega Dreamcast': '106',
    'Nintendo 64': '83',
    'Game Boy Advance': '24',
    'Game Boy Color': '43',
    'Super Nintendo': '79',
    'GameCube': '105',
    'Commodore 64': '166',
    'Atari 2600': '23',
    'Atari 5200' : '31',
    'Atari 7800' : '28',
  };

  // List of genres
  final List<String> genres = [
    'action',
    'adventure',
    'role-playing-games-rpg',
    'simulation',
    'strategy',
    'sports',
    'platformer',
    'puzzle',
    'shooter',
    'fighting',
    'racing',
    'arcade',
  ];

  String? selectedPlatform;
  String? selectedGenre;

  // Method to navigate to the GamePage with selected platform and genre
  void _navigateToGamePage() {
    if (selectedPlatform != null && selectedGenre != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GamePage(
            // Pass the selected platform code and genre to GamePage
            // Search request requires platform code and not the platform name
            platform: platformCodes[selectedPlatform!]!,
            genre: selectedGenre!,
            platformName: selectedPlatform!,
          ),
        ),
      );
    } else {
      // Show a SnackBar if either platform or genre is not selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both a platform and a genre.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // AppBar with title and background color
      appBar: AppBar(
        title: const Text(
          'Welcome to Retro Gaming Genie!',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.tealAccent,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Padding(
  padding: const EdgeInsets.all(16.0),

  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Introduction section with an image and description
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'assets/images/genie_lamp.jpg',
            height: 120,
          ),
          const SizedBox(width: 24),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Discover the best retro games and learn more about them!',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
                SizedBox(height: 12),
                Text(
                  '1. Select your favorite platform and genre to explore a curated list of retro games.\n'
                  '2. Click on a game to learn more about it, including its description and gameplay features.\n'
                  '3. Ask the Genie any questions you have about the game, and get your answers!',
                  style: TextStyle(fontSize: 15, color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),

      // Dropdowns for platform and genre selection
      const Text(
        'Select a Console Platform:',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      const SizedBox(height: 8),
      DropdownButton<String>(
        value: selectedPlatform,
        hint: const Text('Choose a platform', style: TextStyle(color: Colors.redAccent)),
        dropdownColor: Colors.grey[900],
        isExpanded: true,
        items: platforms.map((platform) {
          return DropdownMenuItem(
            value: platform,
            child: Text(platform, style: const TextStyle(color: Colors.tealAccent)),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedPlatform = value;
          });
        },
      ),
      const SizedBox(height: 16),
      const Text(
        'Select a Genre:',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      const SizedBox(height: 8),
      DropdownButton<String>(
        value: selectedGenre,
        hint: const Text('Choose a genre', style: TextStyle(color: Colors.redAccent)),
        dropdownColor: Colors.grey[900],
        isExpanded: true,
        items: genres.map((genre) {
          return DropdownMenuItem(
            value: genre,
            child: Text(genre, style: const TextStyle(color: Colors.tealAccent)),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedGenre = value;
          });
        },
      ),
      const SizedBox(height: 24),
      
      // Button to navigate to the GamePage
      Center(
        child: ElevatedButton(
          onPressed: _navigateToGamePage,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.tealAccent,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text(
            'Find Games',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    ],
  ),
),
    );
  }
}