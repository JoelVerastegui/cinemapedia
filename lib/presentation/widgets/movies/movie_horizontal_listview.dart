import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';

class MovieHorizontalListview extends StatefulWidget {
  final String? title;
  final String? subtitle;
  final List<Movie> movies;
  final VoidCallback? loadNextPage;

  const MovieHorizontalListview({
    super.key, this.title, this.subtitle, required this.movies, required this.loadNextPage,
  });

  @override
  State<MovieHorizontalListview> createState() => _MovieHorizontalListviewState();
}

class _MovieHorizontalListviewState extends State<MovieHorizontalListview> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if(widget.loadNextPage == null) return;

      if((scrollController.position.pixels + 200) >= scrollController.position.maxScrollExtent) {
        widget.loadNextPage!();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: Column(
        children: [
          if(widget.title != null || widget.subtitle != null)
            _Title(title: widget.title, subtitle: widget.subtitle,),

          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView.builder(
                controller: scrollController,
                itemCount: widget.movies.length,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return _Slide(movie: widget.movies[index]);
                },
              ),
            )
          )
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String? title;
  final String? subtitle;

  const _Title({
    this.title,
    this.subtitle
  });

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleLarge;

    return Container(
      padding: const EdgeInsets.only(top: 10),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          if(title != null)
            Text(title!, style: titleStyle),

          const Spacer(),
          
          if(subtitle != null)
            FilledButton.tonal(
              style: const ButtonStyle(visualDensity: VisualDensity.compact),
              child: Text(subtitle!),
              onPressed: () {
                
              },
            )
        ],
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  final Movie movie;
  
  const _Slide({
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                movie.posterPath.replaceAll('.imdb.', '.tmdb.'),
                fit: BoxFit.cover,
                width: 150,
                loadingBuilder: (context, child, loadingProgress) {
                  if(loadingProgress != null){
                    return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                  }
                    
                  return FadeIn(child: child);
                },
              ),
            ),
          ),

          const SizedBox(height: 10),

          SizedBox(
            width: 150,
            child: Text(movie.title, maxLines: 2, style: textStyles.titleSmall)
          ),

          Row(
            children: [
              Icon(Icons.star_half_outlined, color: Colors.yellow.shade800),
              const SizedBox(width: 3),
              Text('${movie.voteAverage}', style: textStyles.bodyMedium?.copyWith(color: Colors.yellow.shade800)),
              const SizedBox(width: 10),
              const Icon(Icons.remove_red_eye_outlined),
              const SizedBox(width: 3),
              Text(HumanFormats.number(movie.popularity), style: textStyles.bodySmall)
            ],
          )
        ],
      ),
    );
  }
}