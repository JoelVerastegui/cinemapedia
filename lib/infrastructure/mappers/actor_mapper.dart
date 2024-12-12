import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/infrastructure/models/credits_response.dart';

class ActorMapper {
  static Actor castToEntity(Cast cast) => Actor(
    id: cast.id,
    name: cast.name,
    profilePath: 
      cast.profilePath != null 
      ? 'https://image.tmdb.org/t/p/w500${cast.profilePath}' 
      : 'https://cdn.iconscout.com/icon/free/png-256/free-incognito-6-902117.png',
    character: cast.character
  );
}