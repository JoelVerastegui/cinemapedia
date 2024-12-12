import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infrastructure/models/movie_detail.dart';
import 'package:cinemapedia/infrastructure/models/themoviedb_movie.dart';

class MovieMapper {
  static Movie theMovieDBToEntity(TheMovieDBMovie movieDB) => Movie(
    adult: movieDB.adult, 
    backdropPath: (movieDB.backdropPath != '')
      ?  'https://image.imdb.org/t/p/w500${movieDB.backdropPath}'
      : 'https://sd.keepcalms.com/i-w600/keep-calm-poster-not-found.jpg', 
    genreIds: movieDB.genreIds.map((e) => e.toString()).toList(), 
    id: movieDB.id, 
    originalLanguage: movieDB.originalLanguage, 
    originalTitle: movieDB.originalTitle,
    overview: movieDB.overview, 
    popularity: movieDB.popularity, 
    posterPath: (movieDB.posterPath != '')
      ?  'https://image.imdb.org/t/p/w500${movieDB.posterPath}'
      : 'no-poster', 
    releaseDate: movieDB.releaseDate, 
    title: movieDB.title, 
    video: movieDB.video, 
    voteAverage: movieDB.voteAverage, 
    voteCount: movieDB.voteCount
  );

  static Movie movieDetailsToEntity(MovieDetail movieDB) => Movie(
    adult: movieDB.adult, 
    backdropPath: (movieDB.backdropPath != '')
      ?  'https://image.imdb.org/t/p/w500${movieDB.backdropPath}'
      : 'https://sd.keepcalms.com/i-w600/keep-calm-poster-not-found.jpg', 
    genreIds: movieDB.genres.map((e) => e.name).toList(), 
    id: movieDB.id, 
    originalLanguage: movieDB.originalLanguage, 
    originalTitle: movieDB.originalTitle,
    overview: movieDB.overview, 
    popularity: movieDB.popularity, 
    posterPath: (movieDB.posterPath != '')
      ?  'https://image.imdb.org/t/p/w500${movieDB.posterPath}'
      : 'https://sd.keepcalms.com/i-w600/keep-calm-poster-not-found.jpg', 
    releaseDate: movieDB.releaseDate, 
    title: movieDB.title, 
    video: movieDB.video, 
    voteAverage: movieDB.voteAverage, 
    voteCount: movieDB.voteCount
  );
}