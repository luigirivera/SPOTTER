import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotter/main.dart';
import 'models/task_model.dart';
import 'models/session_model.dart';
import 'objectbox.g.dart';

class ObjectBox {
  ObjectBox();

  late Store store;
  late final Box<TaskGroup> taskGroups;
  late final Box<Task> taskList;
  late final Box<TaskDate> taskDate;
  late final Box<StudyTheme> theme;

  final CollectionReference taskCollection =
      FirebaseFirestore.instance.collection('Tasks');

  /// Code section to open objectbox store / Init setters------------///
  ObjectBox._open(this.store) {
    taskGroups = Box<TaskGroup>(store);
    taskList = Box<Task>(store);
    taskDate = Box<TaskDate>(store);
    theme = Box<StudyTheme>(store);
  }

  static Future<ObjectBox> open() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final databaseDirectory = join(documentsDirectory.path, 'objectbox');
    final store = await openStore(directory: databaseDirectory);
    return ObjectBox._open(store);
  }

  Future initTaskCollection() async {
    taskGroups.put(TaskGroup(taskGroup: '+ Add a New Group'));
    taskGroups.put(TaskGroup(taskGroup: 'General'));
    return await taskCollection.doc(FirebaseAuth.instance.currentUser!.uid).set({
      'groups': ['General'],
    });
  }

  ///==////////////////////////////////////////////////////////////////

  /// Getters ------------------------------------------------------///

  ///I read that map iteration cannot skip item, so this is the data pre-processing
  List<TaskGroup> getTaskGroupListWithoutAddOption() {
    List<TaskGroup> tempTaskGroup = getTaskGroupList();
    tempTaskGroup.removeAt(0);
    return tempTaskGroup;
  }

  StudyTheme getTheme() => theme.getAll().isEmpty
      ? StudyTheme(index: -1, folder: "1_trees", name: "trees")
      : theme.getAll().first;

  List<TaskGroup> getTaskGroupList() => taskGroups.getAll().toList();

  List<Task> getTaskList() => taskList.getAll().toList();

  List<TaskDate> getTaskDateList() => taskDate.getAll().toList();

  TaskGroup getTaskGroup(String taskGroup) => _findTaskGroup(taskGroup)!;

  TaskDate getTaskDate(DateTime date) => _findTaskDate(date);

  List<Task> getTaskListByDate(DateTime date) =>
      _findTaskDate(date).tasks.toList();

  List<Task> getTaskListByGroup(String taskGroup) =>
      _findTaskGroup(taskGroup)!.tasks.toList();

  List<TaskGroup> getTaskGroupsByDate(DateTime date) =>
      _findTaskDate(date).taskGroups.toList();

  List<Task> getTaskListByGroupAndDate(TaskDate date, TaskGroup group) =>
      _findTaskListByGroupAndDate(date, group);

  ///==////////////////////////////////////////////////////////////////

  ///Objectbox Management ------------------------------------------///

  Future setTheme(StudyTheme theme) async {
    this.theme.removeAll();
    this.theme.put(theme);
  }

  Future addTask(Task task) async {
    String taskGroup = task.taskGroup.target!.taskGroup;
    await taskCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(taskGroup)
        .doc(task.taskDescription)
        .set({
      'description': task.taskDescription,
      'group': taskGroup,
      'completed': task.completed,
    });
    taskList.put(task);
  }

  Future deleteSelectedTasks(List<Task> taskListToDelete, DateTime date) async {
    bool deletionMade = false;
    for (var task in taskListToDelete) {
      if (task.completed == true) {
        await deleteTask(task);
        deletionMade = true;
      }
    }

    return deletionMade;
  }

  TaskDate addTaskDate(DateTime date) {
    TaskDate newTaskDate = TaskDate(
        year: date.year,
        month: date.month,
        day: date.day,
        weekday: date.weekday);
    taskDate.put(newTaskDate);
    return newTaskDate;
  }

  Future addTaskGroup(String taskGroup) async {
    List<String> taskGroupList = await _getFirebaseTaskGroups();
    taskGroupList.add(taskGroup);
    await taskCollection.doc(FirebaseAuth.instance.currentUser!.uid).set({'groups': taskGroupList});

    taskGroups.put(TaskGroup(taskGroup: taskGroup));
  }

  Future deleteTaskGroup(String taskGroup) async {
    List<String> taskGroupList = await _getFirebaseTaskGroups();
    int index = taskGroupList.indexOf(taskGroup);
    taskGroupList.removeAt(index);
    await taskCollection.doc(FirebaseAuth.instance.currentUser!.uid).set({'groups': taskGroupList});

    TaskGroup group = _findTaskGroup(taskGroup)!;
    taskGroups.remove(group.id);
  }

  Future deleteTask(Task task) async {
    TaskDate oldTaskDate = task.taskDate.target!;
    TaskGroup oldTaskGroup = task.taskGroup.target!;
    if (!task.taskDate.hasValue) {
      deleteTaskDate(task.taskDate.target!);
    }

    await taskCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(task.taskGroup.target!.taskGroup)
        .doc(task.taskDescription)
        .delete();
    taskList.remove(task.id);

    if (_findTaskListByGroupAndDate(oldTaskDate, oldTaskGroup).isEmpty) {
      List<TaskGroup> taskGroupList = oldTaskDate.taskGroups.toList();
      List<TaskGroup> resultTaskGroupList = List.empty(growable: true);
      oldTaskDate.taskGroups.clear();
      oldTaskDate.taskGroups.applyToDb();

      for (var taskGroup in taskGroupList) {
        if (taskGroup.taskGroup != oldTaskGroup.taskGroup) {
          resultTaskGroupList.add(taskGroup);
        }
      }
      oldTaskDate.taskGroups.addAll(resultTaskGroupList);
      oldTaskDate.taskGroups.applyToDb();
    }

    if (oldTaskDate.tasks.isEmpty) {
      deleteTaskDate(oldTaskDate);
    }
  }

  void deleteTaskDate(TaskDate date) {
    taskDate.remove(date.id);
  }

  bool ifTaskGroupExistsInObjectBox(String taskGroup) {
    if (_findTaskGroup(taskGroup) != null) return true;
    return false;
  }

  TaskGroup? _findTaskGroup(String taskGroup) {
    List<TaskGroup> tempList = getTaskGroupList();
    for (var group in tempList) {
      if (group.taskGroup == taskGroup) return group;
    }
    return null;
  }

  List<Task> _findTaskListByGroupAndDate(TaskDate date, TaskGroup group) {
    List<Task> tempTaskList = group.tasks;
    List<Task> resultTaskList = List.empty(growable: true);

    for (var task in tempTaskList) {
      if (task.taskDate.target!.compareTo(date)) {
        resultTaskList.add(task);
      }
    }
    return resultTaskList;
  }

  TaskDate _findTaskDate(DateTime date) {
    if (taskDate.isEmpty()) {
      addTaskDate(date);
    }

    List<TaskDate> tempDateList = getTaskDateList();

    for (var tempDate in tempDateList) {
      if (tempDate.year == date.year &&
          tempDate.month == date.month &&
          tempDate.day == date.day) {
        return tempDate;
      }
    }

    return addTaskDate(date);
  }

  ///==////////////////////////////////////////////////////////////////

  ///Firebase Management ------------------------------------------///
  Future ifCollectionExistsOnFirebase(String taskGroup) async {
    var snapshot =
        await taskCollection.doc(FirebaseAuth.instance.currentUser!.uid).collection(taskGroup).limit(1).get();
    return snapshot.docs.isNotEmpty;
  }

  Future _getFirebaseTaskGroups() async {
    List dynamicList = [];
    List<String> taskGroups = <String>[];
    await taskCollection.doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {
      dynamicList = value.toString().contains('groups')
          ? value['groups']
          : List.empty(growable: true);
    });
    taskGroups = dynamicList.cast<String>();

    return taskGroups;
  }

  ///==////////////////////////////////////////////////////////////////
}
