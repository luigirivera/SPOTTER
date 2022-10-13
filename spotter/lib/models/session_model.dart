import 'package:objectbox/objectbox.dart';

@Entity()
class Theme {
  @Id()
  int id = 0; //don't delete this. it's for objectbox
  int index;
}
