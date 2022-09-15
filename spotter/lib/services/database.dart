import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;

  DatabaseService({required this.uid});

  //collection reference
  //Firestore class name was changed
  final CollectionReference tasksCollection =
      FirebaseFirestore.instance.collection('tasks');

  Future updateUserData(String task) async {
    //Linking the new document with the user uid
    return await tasksCollection.doc(uid).set({
      'task': task,
    });
  }
}
