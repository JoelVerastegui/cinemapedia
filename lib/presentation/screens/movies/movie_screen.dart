import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/entities/video.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';

import '../../widgets/widgets.dart';

class MovieScreen extends ConsumerStatefulWidget {
  static const routeName = 'movie_screen';
  final String movieId;

  const MovieScreen({
    super.key, 
    required this.movieId
  });

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  void initState() {
    super.initState();

    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId);
    ref.read(actorsByMovieProvider.notifier).loadActors(widget.movieId);
    ref.read(videoProvider.notifier).fetchVideos(widget.movieId);
    ref.read(recommendationMoviesProvider.notifier).fetchRecommendations(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    final movie = ref.watch(movieInfoProvider)[widget.movieId];
    final actors = ref.watch(actorsByMovieProvider)[widget.movieId];
    final videos = ref.watch(videoProvider)[widget.movieId];
    if(movie == null || actors == null || videos == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(strokeWidth: 2)
        )
      );
    }

    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          _CustomSliverAppBar(movie: movie),
          SliverList(delegate: SliverChildBuilderDelegate(
            (context, index) => _MovieDetails(movie: movie, actors: actors, videos: videos),
            childCount: 1
          ))
        ],
      ),
    );
  }
}

final isFutureProvider = FutureProvider.family.autoDispose((ref, int movieId) {
  final localStorageProvider = ref.watch(localStorageRepositoryProvider);

  return localStorageProvider.isMovieFavorite(movieId);
});

class _CustomSliverAppBar extends ConsumerWidget {
  final Movie movie;
  const _CustomSliverAppBar({ required this.movie });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final isFavorite = ref.watch(isFutureProvider(movie.id));

    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.7,
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          onPressed: () async {
            // ref.read(localStorageRepositoryProvider).toggleFavorite(movie);
            await ref.read(favoriteMoviesProvider.notifier).toggleFavorite(movie);

            ref.invalidate(isFutureProvider(movie.id));
          }, 
          icon: isFavorite.when(
            loading: () => const CircularProgressIndicator(),
            data: (favorite) => favorite
              ? const Icon(Icons.favorite_outlined, color: Colors.red)
              : const Icon(Icons.favorite_border_outlined), 
            error: (_, __) => throw UnimplementedError()
          )
          // const Icon(Icons.favorite_border_outlined)
        )
      ],
      flexibleSpace: Stack(
        children: [
          FlexibleSpaceBar(
            titlePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            background: Stack(
              children: [
                SizedBox.expand(
                  child: Image.network(
                    movie.posterPath.replaceAll('.imdb.', '.tmdb.'),
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if(loadingProgress != null) return Image.asset('assets/loading.gif');
            
                      return FadeIn(child: child);
                    },
                  )
                ),
            
                const _CustomGradient(
                  begin: Alignment.topLeft,
                  stops: [0.0, 0.3],
                  colors: [Colors.black87, Colors.transparent]
                ),
            
                const _CustomGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  stops: [0.0, 0.2],
                  colors: [Colors.black54, Colors.transparent]
                )
              ],
            ),
          ),
      
          const _CustomGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.7, 1.0],
            colors: [Colors.transparent, Colors.black87]
          ),
        ],
      ),
    );
  }
}

class _MovieDetails extends ConsumerWidget {
  final Movie movie;
  final List<Actor> actors;
  final List<Video> videos;

  const _MovieDetails({ 
    required this.movie,
    required this.actors,
    required this.videos
  });

  @override
  Widget build(BuildContext context, ref) {
    final size = MediaQuery.of(context).size;
    final textStyles = Theme.of(context).textTheme;
    final recommendationMovies = ref.watch(recommendationMoviesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  movie.posterPath.replaceAll('.imdb.', '.tmdb.'),
                  width: size.width * 0.3,
                ),
              ),

              const SizedBox(width: 10),

              SizedBox(
                width: (size.width - 40) * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(movie.title, style: textStyles.titleLarge),
                    Text(movie.overview)
                  ],
                ),
              )
            ],
          ),
        ),

        Container(
          width: size.width,
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [
              ...movie.genreIds.map((gender) => Container(
                margin: const EdgeInsets.only(right: 10),
                child: Chip(
                  label: Text(gender),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                  )
                )
              ))
            ],
          ),
        ),

        _ActorsByMovie(movieId: movie.id.toString()),

        const SizedBox(height: 20),

        (videos.isNotEmpty) 
          ? _VideosByMovie(video: videos[0])

          : const SizedBox(),
        
        const SizedBox(height: 20),

        MovieHorizontalListview(
          title: 'Recomendaciones',
          movies: recommendationMovies['${movie.id}'] ?? [], 
          loadNextPage: () => ref.read(recommendationMoviesProvider.notifier).fetchRecommendations('${movie.id}')
        )
      ],
    );
  }
}

class _ActorsByMovie extends ConsumerWidget {
  final String movieId;

  const _ActorsByMovie({
    required this.movieId,
  });

  @override
  Widget build(BuildContext context, ref) {
    final actorsProvider = ref.watch(actorsByMovieProvider);

    if(actorsProvider[movieId] == null) {
      return const CircularProgressIndicator(strokeWidth: 2);
    }

    final actors = actorsProvider[movieId]!;

    return SizedBox(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actors.length,
        itemBuilder: (context, index) {
          final actor = actors[index];
      
          return Container(
            padding: const EdgeInsets.all(8.0),
            width: 135,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInRight(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      actor.profilePath,
                      width: 135,
                      height: 180,
                      fit: BoxFit.cover
                    ),
                  ),
                ),
      
                const SizedBox(height: 5),
      
                Text(actor.name, maxLines: 2),
      
                Text(actor.character ?? '', 
                  maxLines: 2,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold, 
                    overflow: TextOverflow.ellipsis
                  )
                )
              ],
            ),
          );
        },),
    );
  }
}

class _VideosByMovie extends StatelessWidget {
  final Video video;

  const _VideosByMovie({
    required this.video
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final controller = YoutubePlayerController(
      initialVideoId: video.key,
      flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Videos', style: textStyle.titleLarge!.copyWith(fontWeight: FontWeight.bold) ),
          Text(video.name, style: textStyle.titleMedium),
          SizedBox(
            height: 250,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: YoutubePlayer(
                controller: controller,
                showVideoProgressIndicator: true,
                progressIndicatorColor: colors.primary,
                progressColors: ProgressBarColors(
                  playedColor: colors.primary,
                  handleColor: colors.secondary,
                ),
                onReady: () {},
              ),
            )
          )
        ],
      ),
    );
  }
}

class _CustomGradient extends StatelessWidget {
  final Alignment begin;
  final Alignment end;
  final List<double> stops;
  final List<Color> colors;

  const _CustomGradient({
    required this.begin, 
    this.end = const Alignment(0.0, 0.0), 
    required this.stops, 
    required this.colors
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: begin,
            end: end,
            stops: stops,
            colors: colors
          )
        ),
      ),
    );
  }
}