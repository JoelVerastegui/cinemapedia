import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/movie_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infrastructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infrastructure/models/themoviedb_response.dart';
import 'package:dio/dio.dart';

class TheMovieDBDatasource extends MovieDatasource {
  
  final dio = Dio(BaseOptions(
    baseUrl: Environment.baseUrl,
    queryParameters: {
      'api_key': Environment.theMovieDBKey,
      'language': 'en-EN'
    }
  ));

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final response = await dio.get('/movie/now_playing');
    final TheMovieDBResponse theMovieDBResponse = TheMovieDBResponse.fromJson(response.data);

    final List<Movie> movies = theMovieDBResponse.results
    .where((element) => element.posterPath != 'no-poster')
    .map(
      (e) => MovieMapper.theMovieDBToEntity(e)
    ).toList();
    
    return movies;
  }

}