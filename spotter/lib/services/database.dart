import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';

class DatabaseService {
  final String? uid;

  DatabaseService({this.uid});

  //collection reference
  //Firestore class name was changed
  final CollectionReference tasksCollection =
      FirebaseFirestore.instance.collection('tasks');

  //create a new task document and collection for user
  void makeCollection(String? uid) {
    tasksCollection.doc(uid).set(
        {"taskDescription": "Add your first task here", "icon": "defaultIcon"});

    tasksCollection
        .doc(uid)
        .collection('default')
        .add({"taskDescription": "Task 1"});
  }

  Future initiateTaskData(String task) async {
    //Linking the new document with the user uid
    String taskDescription = task;
    int taskGroup = 0;

    return await tasksCollection.doc(uid).set({
      'icon': 'defaultIcon',
      'taskDescription': taskDescription,
      'taskGroup': taskGroup,
      'completed': false,
    });
  }

  List<Task> _taskListSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Task(
        ///nullable
        icon: doc['icon'],
        taskDescription: doc['taskDescription'],
        taskGroup: doc['taskGroup'],
        completed: doc['completed'],
      );
    }).toList();
  }

  //get brews stream
  Stream<List<Task>> get tasks {
    return tasksCollection.snapshots().map(_taskListSnapshot);
  }
}
