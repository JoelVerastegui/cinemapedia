import 'dart:async';

import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/movie.dart';

typedef SearchMoviesCallback = Future<List<Movie>> Function(String title);

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  final SearchMoviesCallback searchMovies;
  StreamController<List<Movie>> debouncedMovies = StreamController.broadcast();
  Timer? debounceTimer;
  List<Movie> initialMovies;
  StreamController<bool> isStreamLoading = StreamController.broadcast();

  SearchMovieDelegate({
    required this.searchMovies,
    required this.initialMovies
  });


  void clearStreams() {
    debouncedMovies.close();
    isStreamLoading.close();
  }

  void _onQueryChanged(String query) {
    isStreamLoading.add(true);
    if(debounceTimer?.isActive ?? false) debounceTimer!.cancel();

    debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      final movies = await searchMovies(query);
      debouncedMovies.add(movies);
      initialMovies = movies;
      isStreamLoading.add(false);
    });
  }

  @override
  String? get searchFieldLabel => 'Search movies...';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      StreamBuilder(
        stream: isStreamLoading.stream, 
        initialData: false,
        builder: (context, snapshot) {
          if(snapshot.data == null) const SizedBox();

          return snapshot.data! && query.isNotEmpty
          ? SpinPerfect(
              infinite: true,
              duration: const Duration(milliseconds: 1000),
              child: IconButton(
                icon: const Icon(Icons.refresh_outlined),
                onPressed: () {}, 
              ),
            )
          : FadeIn(
              animate: query.isNotEmpty,
              duration: const Duration(milliseconds: 100),
              child: IconButton(
                icon: const Icon(Icons.clear_outlined),
                onPressed: () => query = '', 
              ),
          );
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new_outlined),
      onPressed: () {
        clearStreams();
        close(context, null);
      }
    );
  }

  Widget _buildResultsAndSuggestions(BuildContext context) {
    return StreamBuilder(
      initialData: initialMovies,
      stream: debouncedMovies.stream,
      builder: (context, snapshot) {
        final movies = snapshot.data ?? [];

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];

            return _CustomMovieTile(
              movie: movie,
              onMovieSelected: (context, movie) {
                clearStreams();
                close(context, movie);
              }
            );
          },
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildResultsAndSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChanged(query);

    return _buildResultsAndSuggestions(context);
  }
}

class _CustomMovieTile extends StatelessWidget {
  final Movie movie;
  final Function onMovieSelected;

  const _CustomMovieTile({
    required this.movie,
    required this.onMovieSelected
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => onMovieSelected(context, movie),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            SizedBox(
              width: size.width * 0.2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  movie.posterPath,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) => FadeIn(child: child),
                ),
              ),
            ),
      
            const SizedBox(width: 5),
      
            SizedBox(
              width: size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movie.title, style: textTheme.titleMedium),
      
                  movie.overview.length > 100
                  ? Text('${movie.overview.substring(0, 100)}...')
                  : Text(movie.overview),
      
                  Row(
                    children: [
                      Icon(Icons.star_half_outlined, color: Colors.yellow.shade800),
                      const SizedBox(width: 5),
                      Text(
                        HumanFormats.number(movie.voteAverage, 1), 
                        style: textTheme.bodyMedium!.copyWith(color: Colors.yellow.shade900)
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}