import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movie_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final movieInfoProvider = StateNotifierProvider<MovieMapNotifier,Map<String,Movie>>((ref) {
  final getMovie = ref.watch(movieRepositoryProvider).getMovieById;

  return MovieMapNotifier(getMovie: getMovie);
});

typedef GetMovie = Future<Movie> Function(String id);

class MovieMapNotifier extends StateNotifier<Map<String,Movie>> {
  final GetMovie getMovie;
  MovieMapNotifier({required this.getMovie}): super({});

  Future<void> loadMovie(String movieId) async {
    if(state[movieId] != null) return;

    final movie = await getMovie(movieId);

    state = {...state, movieId: movie};
  }
}