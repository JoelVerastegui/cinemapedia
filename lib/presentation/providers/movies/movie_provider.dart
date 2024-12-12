import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movie_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final nowPlayingMoviesProvider = StateNotifierProvider<MovieNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getNowPlaying;

  return MovieNotifier(fetchMoreMovies: fetchMoreMovies);
});

final popularMoviesProvider = StateNotifierProvider<MovieNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getPopular;

  return MovieNotifier(fetchMoreMovies: fetchMoreMovies);
});

final topRatedMoviesProvider = StateNotifierProvider<MovieNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getTopRated;

  return MovieNotifier(fetchMoreMovies: fetchMoreMovies);
});

final upcomingMoviesProvider = StateNotifierProvider<MovieNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getUpcoming;

  return MovieNotifier(fetchMoreMovies: fetchMoreMovies);
});

final recommendationMoviesProvider = StateNotifierProvider<RecommendationsNotifier, Map<String, List<Movie>>>((ref) {
  final getRecommendationsByMovie = ref.watch(movieRepositoryProvider).getRecommendationsByMovie;

  return RecommendationsNotifier(getRecommendationsByMovie: getRecommendationsByMovie);
});

typedef MovieCallback = Future<List<Movie>> Function({ int page });

class MovieNotifier extends StateNotifier<List<Movie>>{
  int currentPage = 0;
  MovieCallback fetchMoreMovies;
  bool isLoading = false;
  
  MovieNotifier({
    required this.fetchMoreMovies
  }): super([]);

  Future<void> loadNextPage() async {
    if(isLoading) return;
    isLoading = true;
    currentPage++;
    final List<Movie> movies = await fetchMoreMovies(page: currentPage);
    state = [...state, ...movies];
    await Future.delayed(const Duration(milliseconds: 500));
    isLoading = false;
  }

  // Sort new entries randomly
  Future<void> loadNextPageRandom() async {
    if(isLoading) return;
    isLoading = true;
    currentPage++;
    final List<Movie> movies = await fetchMoreMovies(page: currentPage);
    state = [...state, ...movies..shuffle()];
    await Future.delayed(const Duration(milliseconds: 500));
    isLoading = false;
  }
}

typedef RecommendationCallback = Future<List<Movie>> Function(String movieId);

class RecommendationsNotifier extends StateNotifier<Map<String, List<Movie>>> {
  RecommendationCallback getRecommendationsByMovie;

  RecommendationsNotifier({
    required this.getRecommendationsByMovie
  }) :super({});

  Future<void> fetchRecommendations(String movieId) async {
    if(state[movieId] != null) return;

    final response = await getRecommendationsByMovie(movieId);

    final temp = response.take(10);

    state = { ...state, movieId: temp.toList() };
  }
}