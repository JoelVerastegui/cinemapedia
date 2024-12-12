import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/domain/entities/movie.dart';

import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/delegates/search_movie_delegate.dart';

class CustomAppbar extends ConsumerWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final colors = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.titleMedium;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Icon(Icons.movie_outlined, color: colors.primary),
              const SizedBox(width: 5),
              Text('Cinemapedia', style: titleStyle),
              const Spacer(),
              IconButton(
                onPressed: () => ref.read(themeProvider.notifier).toggleDarkMode(), 
                icon: const Icon(Icons.brightness_4)
              ),
              IconButton(
                icon: const Icon(Icons.search_outlined),
                onPressed: () {
                  final searchMovies = ref.read(searchMoviesProvider);
                  final queryValue = ref.read(searchTitleProvider);

                  showSearch<Movie?>(
                    query: queryValue,
                    context: context,
                    delegate: SearchMovieDelegate(
                      initialMovies: searchMovies,
                      searchMovies: ref.read(searchMoviesProvider.notifier).searchMoviesByTitle
                    )
                  ).then((value) {
                    final movie = value;
                    
                    if(movie != null) {
                      context.push('/home/0/movie/${movie.id}');
                    }
                  });
                }
              )
            ],
          ),
        ),
      )
    );
  }
}