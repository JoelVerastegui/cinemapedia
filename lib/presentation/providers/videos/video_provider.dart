import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/domain/entities/video.dart';
import 'package:cinemapedia/presentation/providers/videos/video_repository_provider.dart';

final videoProvider = StateNotifierProvider<VideoNotifier, Map<String, List<Video>>>((ref) {
  final getVideosByMovie = ref.watch(videoRepositoryProvider).getVideosByMovie;

  return VideoNotifier(getVideosByMovie: getVideosByMovie);
});

typedef VideosByMovie = Future<List<Video>> Function(String movieId);

class VideoNotifier extends StateNotifier<Map<String, List<Video>>> {
  final VideosByMovie getVideosByMovie;

  VideoNotifier({
    required this.getVideosByMovie
  }): super({});

  Future<void> fetchVideos(String movieId) async {
    if(state[movieId] != null) return;

    final response = await getVideosByMovie(movieId);

    final tempVideos = response.where((x) => x.type.contains('Trailer') || x.type.contains('Teaser'))
      .toList()
      ..sort((a, b) => b.type.length.compareTo(a.type.length));

    state = { ...state, movieId: tempVideos.take(1).toList() };
  }
}