import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/task_model.dart';

class DatabaseService {
  DatabaseService();

  ///Get the current user id
  final String? uid = FirebaseAuth.instance.currentUser?.uid;

  /// Set up a collection of tasks for the particular user
  final CollectionReference taskCollection = FirebaseFirestore.instance.collection('tasks').doc(FirebaseAuth.instance.currentUser?.uid).collection(
      'Task List');

  Future updateTaskData(int taskGroup, String taskNumber, String taskDescription) async {
    //Linking the new document with the user uid

    return await taskCollection.doc(taskNumber).set({
      'taskDescription': taskDescription,
      'taskGroup': taskGroup,
      'completed': false,
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

  //get brews stream
  Stream<List<Task>> get tasks {
    return taskCollection.snapshots().map(_taskListSnapshot);
  }
}
