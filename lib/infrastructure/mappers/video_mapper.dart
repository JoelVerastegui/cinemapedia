import 'package:cinemapedia/domain/entities/video.dart';
import 'package:cinemapedia/infrastructure/models/videos_response.dart';

class VideoMapper {
  static Video videoToEntity(Result result) => Video(
    id: result.id, 
    name: result.name, 
    key: result.key, 
    type: result.type
  );
}