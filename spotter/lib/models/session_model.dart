import 'package:objectbox/objectbox.dart';

@Entity()
class StudyTheme {
  @Id()
  int id = 0; //don't delete this. it's for objectbox
  int index;
  String folder;
  String name;

  StudyTheme({required this.index, required this.folder, required this.name});
}
