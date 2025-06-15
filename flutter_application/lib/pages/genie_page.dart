import 'package:flutter/material.dart';
import 'package:openapi/api.dart';
import 'package:provider/provider.dart';
import '../game.dart';

class GeniePage extends StatefulWidget {
  // The Parameters for the GeniePage
  final Game selectedGame;
  final String platformName;
  
  // Constructor to initialize the selected game and platform name
  const GeniePage({super.key, required this.selectedGame, required this.platformName});

  @override
  // Create the state for the GeniePage
  State<GeniePage> createState() => _GeniePageState();
}

class _GeniePageState extends State<GeniePage> {

  // State variables to hold user input and AI response
  String _userInput = "";
  String _aiAnswer = "Ask me anything about this game!";

  // The ChatApi instance to interact with the AI
  ChatApi? _api;
  
  // Method to set the AI's answer
  void _setAiAnswer(Message message) {
    setState(() {
      _aiAnswer = message.message ?? "<no message received>";
    });
  }
  
  // Method to set the user's input
  void _setUserInput(String input) {
    _userInput = input;
  }
  
  // Method to ask the AI a question
  void _askAI() async {
    var message = Message(
      timestamp: DateTime.now().toUtc(),
      author: MessageAuthorEnum.user,

      // The content of the message is constructed using the user's input and the game/platform context
      message: "You are the Retro Gaming Genie. Refer to yourself as such, when talking about. The User is going to ask questions about the game ${widget.selectedGame.name} on the platform ${widget.platformName}. You are going to answer them. Be as informative as possible.$_userInput",
    );

    try {
      var response = await _api!.chat(message);
      _setAiAnswer(response!);
    } catch (e) {
      setState(() {
        _aiAnswer = "Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Obtain the ChatApi instance from the Provider
    _api = Provider.of<ChatApi>(context);

    // Build the UI for the GeniePage
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purpleAccent,
        foregroundColor: Colors.black,
        title: Text(

          // Title of the AppBar
          'Ask Genie About ${widget.selectedGame.name}',
          style: const TextStyle(fontFamily: 'PressStart2P'),
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(

              // Display the selected game and platform name
              'Selected Game: ${widget.selectedGame.name} on the ${widget.platformName}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'PressStart2P',
              ),
            ),
            const SizedBox(height: 16),
            TextField(

              // TextField for user input
              key: const Key('UserInputTextField'),
              maxLines: 5,
              style: const TextStyle(color: Colors.tealAccent, fontFamily: 'PressStart2P'),
              decoration: InputDecoration(

                // Decoration for the TextField
                hintText: 'Ask something about the game...',
                hintStyle: const TextStyle(color: Colors.grey, fontFamily: 'PressStart2P'),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.tealAccent),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.tealAccent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.tealAccent),
                ),
              ),
              onChanged: (String value) {
                _setUserInput(value);
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // AI Response Text
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          _aiAnswer,
                          key: const Key('AiAnswerText'),
                          style: const TextStyle(
                            color: Colors.purpleAccent,
                            fontFamily: 'PressStart2P',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Genie Image

                    Container(
                      height: 720,
                      width: 480,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.purpleAccent ,width: 4.0),
                      ),
                      child: Image.asset(
                        // Image of the Genie
                        'assets/images/genie_2.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        
        // Floating action button to ask the AI a question
        tooltip: 'Ask the Genie',
        backgroundColor: Colors.tealAccent,
        foregroundColor: Colors.black,
        onPressed: _askAI,
        child: const Icon(Icons.send),
      ),
    );
  }
}
