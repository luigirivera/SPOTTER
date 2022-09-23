import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/task_model.dart';
import '../objectbox.dart';

class TaskDatabaseService {
  TaskDatabaseService();

  ///Get the current user id
  final String? uid = FirebaseAuth.instance.currentUser?.uid;

  final String defaultTaskGroup = 'Add a new group';
  final CollectionReference taskCollection =
      FirebaseFirestore.instance.collection('tasks');

  Future initiateGeneralCollection() async {
    await taskCollection.doc(uid).set({
      'task group array': ['General'],
    });
  }

  List<TaskGroup> getTaskGroups() => ObjectBox().getTaskGroups();

  List<Task> getTaskList() => ObjectBox().getTaskList();

  /// Collection doesn't exist if there are no documents in it.
  /// So every time the user wants to add a task, we'll just
  /// let the user select a taskGroup (collection) right there and then.
  /// If user doesn't choose one then use default 'General'
  Future addTask(String taskGroup, String taskDescription, bool completed,
      DateTime date) async {
    Task task = Task(
        taskDescription: taskDescription,
        taskGroup: taskGroup,
        completed: completed,
        date: date);

    ///Add new collection name to the doc if it doesn't exist
    ///This helps keeping track
    ///This shit took me way too long
    if (!await ifCollectionExistsOnFirebase(taskGroup) && taskGroup != 'General') {
      addTaskGroup(taskGroup);
      ObjectBox().addTaskGroup(taskGroup);
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

  ///Upon deleting a task, if the collection of the task doesn't exist anymore, then
  ///remove the group from the objectbox and the cloud doc
  Future deleteTask(Task task) async {
    ObjectBox().deleteTask(task);
    await taskCollection
        .doc(uid)
        .collection(task.taskGroup)
        .doc(task.taskDescription)
        .delete();

    if (!await ifCollectionExistsOnFirebase(task.taskGroup) &&
        task.taskGroup != 'General') {
      deleteTaskGroup(task.taskGroup);
    }
    return;
  }

  ///Returns a boolean
  Future ifCollectionExistsOnFirebase(String taskGroup) async {
    var snapshot =
        await taskCollection.doc(uid).collection(taskGroup).limit(1).get();
    return snapshot.docs.isNotEmpty;
  }

  Future addTaskGroup(String taskGroup) async {
    List<String> taskGroupNames = await _getFirebaseTaskGroups();
    taskGroupNames.add(taskGroup);
    return await taskCollection.doc(uid).set({'task group array': taskGroupNames});
  }

  Future deleteTaskGroup(String taskGroup) async {
    ObjectBox().deleteTaskGroup(taskGroup);

    List<String> taskCollectionNames = await _getFirebaseTaskGroups();
    int index = taskCollectionNames.indexOf(taskGroup);
    taskCollectionNames.removeAt(index);
    return await taskCollection.doc(uid).set(taskCollectionNames);
  }

  ///Returns a List<String>
  Future _getFirebaseTaskGroups() async {
    List dynamicList = [];
    List<String> taskGroups = <String>[];
    await taskCollection.doc(uid).get().then((value) {
      dynamicList = value['task group array'];
    });
    taskGroups = dynamicList.cast<String>();

    return taskGroups;
  }
}
