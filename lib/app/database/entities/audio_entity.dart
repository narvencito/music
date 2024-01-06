import 'package:music/objectbox.g.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class AudioEntity {
  @Id()
  int id = 0;
  late String name;
  late String autor;
  late bool favorite;
}
