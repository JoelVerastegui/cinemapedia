import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({ super.key });

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> with AutomaticKeepAliveClientMixin{
  @override
  void initState() {
    super.initState();
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    ref.read(topRatedMoviesProvider.notifier).loadNextPage();
    ref.read(upcomingMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    // keep as original build
    super.build(context);

    final initialLoading = ref.watch(initialLoadingProvider);
    if(initialLoading) return const FullscreenLoader();

    final slideShowMovies = ref.watch(movieSlideshowProvider);
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final topRatedMovies = ref.watch(topRatedMoviesProvider);
    final upcomingMovies = ref.watch(upcomingMoviesProvider);

    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          floating: true,
          flexibleSpace: CustomAppbar()
        ),

        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return Column(
              children: [
                MovieSlideshow(movies: slideShowMovies),
            
                MovieHorizontalListview(
                  title: 'Now playing',
                  subtitle: 'February 12',
                  movies: nowPlayingMovies, 
                  loadNextPage: () => ref.read(nowPlayingMoviesProvider.notifier).loadNextPage()
                ),
            
                MovieHorizontalListview(
                  title: 'Top Rated',
                  // subtitle: 'Febrero 08',
                  movies: topRatedMovies, 
                  loadNextPage: () => ref.read(topRatedMoviesProvider.notifier).loadNextPage()
                ),
            
                MovieHorizontalListview(
                  title: 'Upcoming',
                  subtitle: 'Coming soon',
                  movies: upcomingMovies, 
                  loadNextPage: () => ref.read(upcomingMoviesProvider.notifier).loadNextPage()
                ),

                const SizedBox(height: 10)
              ],
            );
          },
          childCount: 1)
        )
      ],
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}