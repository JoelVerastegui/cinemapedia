import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/infrastructure/datasources/video_themoviedb_datasource.dart';
import 'package:cinemapedia/infrastructure/repositories/video_repository_impl.dart';

final videoRepositoryProvider = Provider((ref) {
  return VideoRepositoryImpl(VideoThemoviedbDatasource());
});