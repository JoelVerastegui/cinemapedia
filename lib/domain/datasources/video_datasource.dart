import 'package:cinemapedia/domain/entities/video.dart';

abstract class VideoDatasource {
  Future<List<Video>> getVideosByMovie(String movieId);
}