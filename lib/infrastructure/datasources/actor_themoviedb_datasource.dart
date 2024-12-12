import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/actor_datasource.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/infrastructure/mappers/actor_mapper.dart';
import 'package:cinemapedia/infrastructure/models/credits_response.dart';
import 'package:dio/dio.dart';

class ActorTheMovieDBDatasource extends ActorDatasource {
  final dio = Dio(BaseOptions(
    baseUrl: Environment.baseUrl,
    queryParameters: {
      'api_key': Environment.theMovieDBKey,
      'language': 'en-EN'
    }
  ));

  List<Actor> _jsonToActors(Map<String, dynamic> json) {
    CreditsResponse creditsResponse = CreditsResponse.fromJson(json);

    List<Actor> actors = creditsResponse.cast
    .map(
      (e) => ActorMapper.castToEntity(e)
    ).toList();

    return actors;
  }

  @override
  Future<List<Actor>> getActorsByMovie(String movieId) async {
    final response = await dio.get('/movie/$movieId/credits');
    List<Actor> actors = _jsonToActors(response.data);
    return actors;
  }

}