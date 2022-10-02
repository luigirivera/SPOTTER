import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'models/task_model.dart';
import 'objectbox.g.dart';

class ObjectBox {
  ObjectBox();

  late Store store;
  late final Box<TaskGroup> taskGroups;
  late final Box<Task> taskList;
  late final Box<TaskDate> taskDate;

  final String? uid = FirebaseAuth.instance.currentUser?.uid;
  final CollectionReference taskCollection =
      FirebaseFirestore.instance.collection('Tasks');

  /// Code section to open objectbox store / Init setters------------///
  ObjectBox._open(this.store) {
    taskGroups = Box<TaskGroup>(store);
    taskList = Box<Task>(store);
    taskDate = Box<TaskDate>(store);
    if (taskGroups.isEmpty()) {
      taskGroups.put(TaskGroup(taskGroup: '+ Add a New Group'));
      taskGroups.put(TaskGroup(taskGroup: 'General'));
    }
  }

  static Future<ObjectBox> open() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final databaseDirectory = join(documentsDirectory.path, 'objectbox');
    final store = await openStore(directory: databaseDirectory);
    return ObjectBox._open(store);
  }

  Future initTaskCollection() async {
    return await taskCollection.doc(uid).set({
      'Task Groups': ['General']
    });
  }

  ///==////////////////////////////////////////////////////////////////

  /// Getters ------------------------------------------------------///
  List<TaskGroup> getTaskGroupList() => taskGroups.getAll().toList();

  List<Task> getTaskList() => taskList.getAll().toList();

  List<TaskDate> getTaskDateList() => taskDate.getAll().toList();

  TaskGroup getTaskGroup(String taskGroup) => findTaskGroup(taskGroup)!;

  TaskDate getTaskDate(DateTime date) => findTaskDate(date);

  List<Task> getTaskListByDate(DateTime date) =>
      findTaskDate(date).tasks.toList();

  List<Task> getTaskListByGroup(String taskGroup) =>
      findTaskGroup(taskGroup)!.tasks.toList();

  ///==////////////////////////////////////////////////////////////////

  ///Objectbox Management ------------------------------------------///
  void addTask(Task task) {
    String taskGroup = task.taskGroup.target!.taskGroup;
    taskCollection
        .doc(uid)
        .collection(taskGroup)
        .doc(task.taskDescription)
        .set({
      'Task Description': task.taskDescription,
      'taskGroup': taskGroup,
      'completed': task.completed,
    });
    taskList.put(task);
  }

  Future addTaskGroup(String taskGroup) async {
    List<String> taskGroupList = await _getFirebaseTaskGroups();
    taskGroupList.add(taskGroup);
    taskCollection.doc(uid).set({'Task Groups': taskGroups});

    taskGroups.put(TaskGroup(taskGroup: taskGroup));
  }

  TaskDate addTaskDate(DateTime date) {
    TaskDate newTaskDate = TaskDate(date: date);
    taskDate.put(newTaskDate);
    return newTaskDate;
  }

  Future deleteTaskGroup(String taskGroup) async {
    List<String> taskGroupList = await _getFirebaseTaskGroups();
    int index = taskGroupList.indexOf(taskGroup);
    taskGroupList.removeAt(index);
    taskCollection.doc(uid).set({'Task Groups': taskGroups});

    TaskGroup group = findTaskGroup(taskGroup)!;
    taskGroups.remove(group.id);
  }

  void deleteTask(Task task) {
    if (!task.taskDate.hasValue) {
      deleteTaskDate(task.taskDate.target!);
    }
    taskList.remove(task.id);
  }

  void deleteTaskDate(TaskDate date) {
    taskDate.remove(date.id);
  }

  bool ifTaskGroupExistsInObjectBox(String taskGroup) {
    if (findTaskGroup(taskGroup) != null) return true;
    return false;
  }

  TaskGroup? findTaskGroup(String taskGroup) {
    List<TaskGroup> tempList = getTaskGroupList();
    for (var group in tempList) {
      if (group.taskGroup == taskGroup) return group;
    }
    return null;
  }

  TaskDate findTaskDate(DateTime date) {
    if (taskDate.isEmpty()) {
      return addTaskDate(date);
    }

    List<TaskDate> tempDateList = getTaskDateList();
    for (var tempDate in tempDateList) {
      if (tempDate.date.compareTo(date) == 0) {
        return tempDate;
      }
    }

    return addTaskDate(date);
  }

  ///==////////////////////////////////////////////////////////////////

  ///Firebase Management ------------------------------------------///
  Future ifCollectionExistsOnFirebase(String taskGroup) async {
    var snapshot =
        await taskCollection.doc(uid).collection(taskGroup).limit(1).get();
    return snapshot.docs.isNotEmpty;
  }

  Future _getFirebaseTaskGroups() async {
    List dynamicList = [];
    List<String> taskGroups = <String>[];
    await taskCollection.doc(uid).get().then((value) {
      dynamicList = value['Task Groups'];
    });
    taskGroups = dynamicList.cast<String>();

    return taskGroups;
  }

  ///==////////////////////////////////////////////////////////////////
}
