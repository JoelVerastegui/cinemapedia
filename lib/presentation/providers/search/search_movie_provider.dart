import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movie_repository_provider.dart';

final searchTitleProvider = StateProvider((ref) => '');

typedef SearchMoviesCallback = Future<List<Movie>> Function(String title);

class SearchMoviesNotifier extends StateNotifier<List<Movie>> {
  SearchMoviesCallback searchMovies;
  Ref ref;

  SearchMoviesNotifier({
    required this.searchMovies,
    required this.ref
  }): super([]);

  Future<List<Movie>> searchMoviesByTitle(String title) async {
    final movies = await searchMovies(title);

    state = movies;
    ref.read(searchTitleProvider.notifier).update((state) => title);

    return movies;
  }
}

final searchMoviesProvider = StateNotifierProvider<SearchMoviesNotifier, List<Movie>>((ref) {
  final moviesRepository = ref.read(movieRepositoryProvider);

  return SearchMoviesNotifier(searchMovies: moviesRepository.getMovieByTitle, ref: ref);
});