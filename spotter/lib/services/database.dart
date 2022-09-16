import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;

  DatabaseService({this.uid});

  //collection reference
  //Firestore class name was changed
  final CollectionReference tasksCollection =
      FirebaseFirestore.instance.collection('tasks');

  Future updateUserData(String task) async {
    //Linking the new document with the user uid
    int taskCount = 0;
    return await tasksCollection.doc(uid).set({
      taskCount : 0,
    });
  }

  //get brews stream
  Stream<QuerySnapshot> get tasks {
    return tasksCollection.snapshots();
  }
}
