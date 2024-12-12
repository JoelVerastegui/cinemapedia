import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/local_storage_repository.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoriteMoviesNotifier extends StateNotifier<Map<int, Movie>> {
  final LocalStorageRepository localStorageRepository;
  int page = 0;

  FavoriteMoviesNotifier({
    required this.localStorageRepository
  }) :super({});

  Future<List<Movie>> loadNextPage() async {
    final movies = await localStorageRepository.loadMovies(offset: page * 12);
    page++;

    final tempMovies = <int, Movie>{};

    for(final movie in movies) {
      tempMovies[movie.id] = movie;
    }

    state = {...state, ...tempMovies};

    return movies;
  }

  Future<void> toggleFavorite(Movie movie) async {
    // await localStorageRepository.toggleFavorite(movie);
    // final bool isMovieInFavorites = state[movie.id] != null;
    final bool isMovieInFavorites = await localStorageRepository.toggleFavorite(movie);

    if(isMovieInFavorites) {
      state.remove(movie.id);
      state = { ...state };
    } else {
      state = { ...state, movie.id: movie};
    }
  }
}

final favoriteMoviesProvider = StateNotifierProvider<FavoriteMoviesNotifier, Map<int, Movie>>((ref) {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);

  return FavoriteMoviesNotifier(localStorageRepository: localStorageRepository);
});