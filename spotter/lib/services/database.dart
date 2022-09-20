import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/task_model.dart';

class DatabaseService {
  DatabaseService();

  ///Get the current user id
  final String? uid = FirebaseAuth.instance.currentUser?.uid;

  final String defaultTaskGroup = 'General';
  final CollectionReference taskCollection = FirebaseFirestore.instance.collection('tasks');

  /// Collection doesn't exist if there are no documents in it.
  /// So every time the user wants to add a task, we'll just
  /// let the user select a taskGroup (collection) right there and then.
  /// If user doesn't choose one then use default 'General'
  Future updateTaskData(String? taskGroup, String taskDescription, bool completed) async {
    //Linking the new document with the user uid

    return await taskCollection.doc(uid).collection(taskGroup ?? defaultTaskGroup).doc(taskDescription).set({
      'taskDescription': taskDescription,
      'taskGroup': taskGroup ?? defaultTaskGroup,
      'completed': completed,
    });
  }

  List<Task> _taskListSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Task(
        ///nullable
        taskDescription: doc['taskDescription'],
        taskGroup: doc['taskGroup'],
        completed: doc['completed'],
      );
    }).toList();
  }

  ///fixing this later
  //get brews stream
  Stream<List<Task>> get tasks {
    return taskCollection.doc(uid).snapshots().map(_taskListSnapshot);
  }
}
