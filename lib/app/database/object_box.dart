import 'package:music/app/database/entities/audio_entity.dart';
import 'package:music/app/database/entities/video_entity.dart';
import 'package:music/objectbox.g.dart'; // created by `flutter pub run build_runner build`
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ObjectBox {
  late final Store store;

  late final Box<AudioEntity> _audioBox;
  late final Box<VideoEntity> _videoBox;
  ObjectBox._create(this.store) {
    _audioBox = Box<AudioEntity>(store);
  }

  static Future<ObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store = await openStore(directory: p.join(docsDir.path, "narvenBD"));
    return ObjectBox._create(store);
  }

  Future<void> addAudio(AudioEntity entity) => _audioBox.putAsync(entity);
  Future<void> addAudios(List<AudioEntity> list) => _audioBox.putManyAsync(list);
  Future<void> removeNote(int id) => _audioBox.removeAsync(id);
  Future<List<AudioEntity>> audioList() => _audioBox.getAllAsync();
}
