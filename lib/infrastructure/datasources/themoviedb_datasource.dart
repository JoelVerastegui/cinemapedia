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

  List<Movie> _jsonToMovie(Map<String, dynamic> json) {
    final TheMovieDBResponse theMovieDBResponse = TheMovieDBResponse.fromJson(json);

    final List<Movie> movies = theMovieDBResponse.results
    .where((element) => element.posterPath != 'no-poster')
    .map(
      (e) => MovieMapper.theMovieDBToEntity(e)
    ).toList();
    
    return movies;
  }

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final response = await dio.get('/movie/now_playing', 
      queryParameters: {
        'page': page
      }
    );
    
    return _jsonToMovie(response.data);
  }
  
  @override
  Future<List<Movie>> getPopular({int page = 1}) async {
    final response = await dio.get('/movie/popular', 
      queryParameters: {
        'page': page
      }
    );
    
    return _jsonToMovie(response.data);
  }
  
  @override
  Future<List<Movie>> getTopRated({int page = 1}) async {
    final response = await dio.get('/movie/top_rated', 
      queryParameters: {
        'page': page
      }
    );
    
    return _jsonToMovie(response.data);
  }
  
  @override
  Future<List<Movie>> getUpcoming({int page = 1}) async {
    final response = await dio.get('/movie/upcoming', 
      queryParameters: {
        'page': page
      }
    );
    
    return _jsonToMovie(response.data);
  }

}