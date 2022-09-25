import 'package:firebase_auth/firebase_auth.dart';

class SpotterUser {
  late final String? uid;
  late final bool? isAnon;
  SpotterUser({this.uid, this.isAnon});
}
