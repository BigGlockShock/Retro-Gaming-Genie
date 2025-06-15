import 'dart:convert';
import 'dart:io';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:openapi/api.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:http/http.dart' as http;

import 'ai/ai.dart';
import 'ai/mock_ai.dart';
import 'ai/openai.dart';

class EnvVariables {
  static final useMockAi = 'CHAT_SERVER_USE_MOCK';
  static final port = 'CHAT_SERVER_PORT';
}
// The base URL for the RAWG API to fetch game data.
final String _baseUrl = 'https://api.rawg.io/api/games';

// The API key for the RAWG API is read from a secrets.json file.
final String _apiKey = jsonDecode(File('secrets.json').readAsStringSync())['rawg_apiKey'];

Ai _ai = OpenAiChat(model: Gpt4ChatModel());

final _router = Router()
  ..get('/', _rootHandler)
  ..post('/chat', _chatHandler)
  ..get('/games', _fetchGames)
  ..get('/games/<id>', _fetchGameDescription);

Response _rootHandler(Request req) {
  return Response.ok('Chat Server V0.0.1');
}

Future<Response> _chatHandler(Request request) async {
  if (request.contentLength == 0) {
    return Response.badRequest(body: 'Request body is empty');
  }
  final inJson = await request.readAsString();

  Map<String, dynamic> messageMap;
  try {
    messageMap = json.decode(inJson);
  } catch (e) {
    return Response.badRequest(body: 'Invalid JSON format: $e');
  }

  Message message;
  try {
    message = Message.fromJson(messageMap)!;
  } catch (e) {
    return Response.badRequest(body: 'Invalid Message format: $e');
  }

  Message response;
  try {
    response = await _ai.chat(message);
  } catch (e) {
    return Response.internalServerError(body: 'Error invoking AI: $e');
  }

  return Response.ok(json.encode(response.toJson()));
}

// This function fetches a list of games based on platform and genre
Future<Response> _fetchGames(Request request) async {
  final platform = request.url.queryParameters['platform'];
  final genre = request.url.queryParameters['genre'];

  if (platform == null || genre == null) {
    return Response.badRequest(body: 'Missing platform or genre query parameters');
  }

  final url = '$_baseUrl?key=$_apiKey&platforms=$platform&genres=$genre&page_size=20&ordering=-metacritic';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return Response.ok(response.body, headers: {'Content-Type': 'application/json'});
  } else {
    return Response.internalServerError(body: 'Failed to fetch games');
  }
}

// This function fetches the description of a game by its ID
Future<Response> _fetchGameDescription(Request request, String id) async {
  final url = '$_baseUrl/$id?key=$_apiKey';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return Response.ok(response.body, headers: {'Content-Type': 'application/json'});
  } else {
    return Response.internalServerError(body: 'Failed to fetch game description');
  }
}

void main(List<String> args) async {
  bool useMock = bool.parse(Platform.environment[EnvVariables.useMockAi] ?? 'false');
  if (useMock) {
    _ai = MockAi();
    print('Warning: Using Mock AI.');
  }

  final ip = InternetAddress.anyIPv4;
  final port = int.parse(Platform.environment[EnvVariables.port] ?? '8000');
  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(corsHeaders())
      .addHandler(_router.call);

  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}.');
}
