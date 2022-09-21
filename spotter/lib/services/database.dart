import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/task_model.dart';
import '../objectbox.dart';

class DatabaseService {
  DatabaseService();

  ///Get the current user id
  final String? uid = FirebaseAuth.instance.currentUser?.uid;

  final String defaultTaskGroup = 'General';
  final CollectionReference taskCollection =
      FirebaseFirestore.instance.collection('tasks');

  Future initiateGeneralCollection() async {
    await taskCollection.doc(uid).set({
      'task group array': ['General']
    });
  }

  /// Collection doesn't exist if there are no documents in it.
  /// So every time the user wants to add a task, we'll just
  /// let the user select a taskGroup (collection) right there and then.
  /// If user doesn't choose one then use default 'General'
  Future addTask(
      String taskGroup, String taskDescription, bool completed) async {
    Task task = Task(
        taskDescription: taskDescription,
        taskGroup: taskGroup,
        completed: completed);

    ///Add new collection name to the doc if it doesn't exist
    ///This helps keeping track
    ///This shit took me way too long
    if (!await ifCollectionExists(taskGroup)) {
      addTaskCollectionName(taskGroup);
      ObjectBox().addTaskCollectionName(taskGroup);
    }

    ObjectBox().addTask(task);

    return await taskCollection
        .doc(uid)
        .collection(taskGroup)
        .doc(taskDescription)
        .set({
      'taskDescription': taskDescription,
      'taskGroup': taskGroup,
      'completed': completed,
    });
  }

  Future deleteTask(Task task) async {
    ObjectBox().deleteTask(task);
    return await taskCollection.doc(uid).collection(task.taskGroup).doc(task.taskDescription).delete();
  }

  ///Returns a boolean
  ///you have to add await to assign this function return value
  Future ifCollectionExists(String taskGroup) async {
    var snapshot =
        await taskCollection.doc(uid).collection(taskGroup).limit(1).get();
    return snapshot.docs.isNotEmpty;
  }

  Future addTaskCollectionName(String taskGroup) async {
    List<String> taskCollectionNames = await getTaskCollection();
    taskCollectionNames.add(taskGroup);
    taskCollection.doc(uid).set({'task group array': taskCollectionNames});
    return;
  }

  Future deleteTaskCollectionName(String taskGroup) async {
    
  }

  ///Returns a List<String>
  Future getTaskCollection() async {
    List dynamicList = [];
    List<String> taskCollectionNames = <String>[];
    await taskCollection.doc(uid).get().then((value) {
      dynamicList = value['task group array'];
    });
    taskCollectionNames = dynamicList.cast<String>();

    return taskCollectionNames;
  }
}
