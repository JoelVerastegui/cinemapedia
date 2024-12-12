import 'package:dio/dio.dart';
import 'package:cinemapedia/infrastructure/mappers/video_mapper.dart';
import 'package:cinemapedia/infrastructure/models/videos_response.dart';
import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/video_datasource.dart';
import 'package:cinemapedia/domain/entities/video.dart';

class VideoThemoviedbDatasource extends VideoDatasource {
  final dio = Dio(BaseOptions(
    baseUrl: Environment.baseUrl,
    queryParameters: {
      'api_key': Environment.theMovieDBKey,
      'language': 'en-EN'
    }
  ));

  @override
  Future<List<Video>> getVideosByMovie(String movieId) async {
    final response = await dio.get('/movie/$movieId/videos');

    final videosResponse = VideosResponse.fromJson(response.data);

    return videosResponse.results.map((e) => VideoMapper.videoToEntity(e)).toList();
  }

}