import 'package:firebase_auth/firebase_auth.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class SpotterUser {
  @Id()
  int id = 0;

  late final String? uid;
  late final bool? isAnon;
  bool deleteUser;
  SpotterUser({this.uid, this.isAnon, this.deleteUser = false});
}
