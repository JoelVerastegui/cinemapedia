import 'package:cinemapedia/domain/entities/video.dart';
import 'package:cinemapedia/domain/datasources/video_datasource.dart';
import 'package:cinemapedia/domain/repositories/video_repository.dart';

class VideoRepositoryImpl extends VideoRepository{
  final VideoDatasource videoDatasource;
  VideoRepositoryImpl(this.videoDatasource);

  @override
  Future<List<Video>> getVideosByMovie(String movieId) {
    return videoDatasource.getVideosByMovie(movieId);
  }
}