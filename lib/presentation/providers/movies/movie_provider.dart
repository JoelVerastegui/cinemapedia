import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movie_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final nowPlayingMoviesProvider = StateNotifierProvider<MovieNotifier, List<Movie>>((ref) {
  // Invocar al método sin paréntesis se conoce como "Función de referencia" o "Método de referencia"
  // Se utiliza para ejecutar el método usando la variable fetchMoreMovies en otro momento
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getNowPlaying;

  return MovieNotifier(fetchMoreMovies: fetchMoreMovies);
});

typedef MovieCallback = Future<List<Movie>> Function({ int page });

class MovieNotifier extends StateNotifier<List<Movie>>{
  int currentPage = 0;
  MovieCallback fetchMoreMovies;
  
  MovieNotifier({
    required this.fetchMoreMovies
  }): super([]);

  Future<void> loadNextPage() async {
    currentPage++;
    //Ejecuta fetchMoreMovies con el método de referencia que se le haya asignado
    final List<Movie> movies = await fetchMoreMovies(page: currentPage);
    state = [...state, ...movies];
  }
}