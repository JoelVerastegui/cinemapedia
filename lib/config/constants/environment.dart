import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment{
  static String theMovieDBKey = dotenv.env['THE_MOVIEDB_APIKEY'] ?? 'No hay api.';
}