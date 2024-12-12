import 'package:cinemapedia/domain/entities/video.dart';

abstract class VideoRepository {
  Future<List<Video>> getVideosByMovie(String movieId);
}