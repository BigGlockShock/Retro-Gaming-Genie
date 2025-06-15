import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/selection_page.dart';
import 'package:openapi/api.dart'; 

void main() {
  var apiClient = ApiClient(basePath: 'http://localhost:8000'); 
  var api = ChatApi(apiClient);

  runApp(
    Provider<ChatApi>(
      create: (_) => api,
      child: const AiApp(),
    ),
  );
}

class AiApp extends StatelessWidget {
  const AiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Retro-Gaming Genie',
      theme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: Colors.tealAccent,
          onPrimary: Colors.black,
          secondary: Colors.purpleAccent,
          onSecondary: Colors.black,
          surface: Colors.grey[900]!,
          onSurface: Colors.white,
          error: Colors.redAccent,
          onError: Colors.black,
        ),
        fontFamily: 'PressStart2P', 
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.tealAccent),
        ),
      ),
      home: const SelectionPage(),
    );
  }
}