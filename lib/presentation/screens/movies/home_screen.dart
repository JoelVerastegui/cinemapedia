import 'package:flutter/material.dart';

import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:cinemapedia/presentation/views/views.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = 'home_screen';
  final int pageIndex;

  const HomeScreen({
    super.key, 
    required this.pageIndex
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final homeViews = <Widget>[
    const HomeView(),
    const PopularView(),
    FavoritesView(moveToPage: (value) => moveToPage(value))
  ];
  static final controller = PageController();

  static void moveToPage(int page) {
    controller.animateToPage(
      page, 
      duration: const Duration(milliseconds: 500), 
      curve: Curves.decelerate
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: homeViews,
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: widget.pageIndex,
        onPageChange: (value) => moveToPage(value),
      ),
    );
  }
}