import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';

class FavoritesView extends ConsumerStatefulWidget {
  final ValueChanged<int> moveToPage;
  const FavoritesView({
    super.key,
    required this.moveToPage
  });

  @override
  FavoritesViewState createState() => FavoritesViewState();
}

class FavoritesViewState extends ConsumerState<FavoritesView> with AutomaticKeepAliveClientMixin{
  bool isLoading = false;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();

    loadNextPage();
  }

  void loadNextPage() async {
    if(isLoading || isLastPage) return;
    isLoading = true;

    final movies = await ref.read(favoriteMoviesProvider.notifier).loadNextPage();
    isLoading = false;

    if(movies.isEmpty) {
      isLastPage = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    // keep as original build
    super.build(context);
    
    final movies = ref.watch(favoriteMoviesProvider).values.toList();

    if(movies.isEmpty) {
      final colors = Theme.of(context).colorScheme;

      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.favorite_outline_sharp, color: colors.primary, size: 60),
            Text('Oh no!', style: TextStyle(color: colors.primary, fontSize: 30)),
            const Text('You don\'t have favorites =(', style: TextStyle(color: Colors.black38, fontSize: 20)),
            const SizedBox(height: 40),
            FilledButton.tonal(
              onPressed: () {
                context.go('/home/0/');
                widget.moveToPage(0);
              }, 
              child: const Text('Find some movies!')
            )
          ],
        ),
      );
    }

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