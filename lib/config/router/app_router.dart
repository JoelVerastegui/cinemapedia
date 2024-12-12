import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cinemapedia/presentation/screens/screens.dart';

final appRouter = GoRouter(
  initialLocation: '/home/0',
  routes: [
    GoRoute(
      path: '/home/:page',
      name: HomeScreen.routeName,
      builder: (context, state) {
        final pageIndex = int.parse(state.pathParameters['page'] ?? '0');

        return HomeScreen(pageIndex: pageIndex);
      },
      routes: [
        GoRoute(
          path: 'movie/:id',
          name: MovieScreen.routeName,
          pageBuilder: (context, state) {
            final movieId = state.pathParameters['id'] ?? 'no-id';

            return CustomTransitionPage(
              key: state.pageKey,
              child: MovieScreen(movieId: movieId),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: animation.drive(
                    Tween<Offset>(
                      begin: const Offset(1, 0),
                      end: Offset.zero,
                    ).chain(CurveTween(curve: Curves.easeIn)),
                  ),
                  child: child
                );
              }
            );
          },
        )
      ]
    ),

    GoRoute(
      path: '/',
      redirect: (_, __) => '/home/0',
    )
  ]
);