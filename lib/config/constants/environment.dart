import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment{
  static String theMovieDBKey = dotenv.env['THE_MOVIEDB_APIKEY'] ?? '';
  static String baseUrl = dotenv.env['BASE_URL'] ?? '';
}