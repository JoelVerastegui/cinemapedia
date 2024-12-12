import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PopularView extends ConsumerStatefulWidget {
  const PopularView({super.key});

  @override
  PopularViewState createState() => PopularViewState();
}

class PopularViewState extends ConsumerState<PopularView> with AutomaticKeepAliveClientMixin{
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    loadNextPage();
  }

  void loadNextPage() async {
    if(isLoading) return;
    isLoading = true;

    await ref.read(popularMoviesProvider.notifier).loadNextPageRandom();
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    // keep as original build
    super.build(context);

    final movies = ref.watch(popularMoviesProvider);

    return Scaffold(
      body: MovieMasonry(
        movies: movies,
        loadNextPage: () => loadNextPage(),
      ),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}