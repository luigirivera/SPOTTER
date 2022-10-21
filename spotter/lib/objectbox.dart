import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotter/services/auth.dart';
import 'models/sync_model.dart';
import 'models/task_model.dart';
import 'models/session_model.dart';
import 'objectbox.g.dart';
import 'services/connectivity.dart';
import 'services/firebase.dart';

class ObjectBox {
  ObjectBox();

  late Store store;
  late final Box<TaskGroup> taskGroups;
  late final Box<Task> taskList;
  late final Box<TaskDate> taskDate;
  late final Box<StudyTheme> theme;
  late final Box<DataToUpload> dataListToUpload;

  final CollectionReference taskCollection =
      FirebaseFirestore.instance.collection('Tasks');
  final AuthService _auth = AuthService();
  final ConnectivityService _connection = ConnectivityService();

  /// Code section to open objectbox store / Init setters------------///
  ObjectBox._open(this.store) {
    taskGroups = Box<TaskGroup>(store);
    taskList = Box<Task>(store);
    taskDate = Box<TaskDate>(store);
    theme = Box<StudyTheme>(store);
    dataListToUpload = Box<DataToUpload>(store);
  }

  static Future<ObjectBox> open() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final databaseDirectory = join(documentsDirectory.path, 'objectbox');
    final store = await openStore(directory: databaseDirectory);
    return ObjectBox._open(store);
  }

  ///Default task groups users see upon registering
  Future initTaskCollection() async {
    taskGroups.put(TaskGroup(taskGroup: 'General'));

    if (await _connection.status != 'none') {
      await taskCollection.doc(_auth.currentUser!.uid).set({
        'groups': ['General'],
      });
    } else {
      DataToUpload uData =
          DataToUpload(addOrDeleteOrNeither: -1, initiateFBTaskCollection: true);
      dataListToUpload.put(uData);
    }
  }

  StudyTheme getTheme() => theme.getAll().isEmpty
      ? StudyTheme(index: -1, folder: "1_trees", name: "trees")
      : theme.getAll().first;

  List<TaskGroup> getTaskGroupList() => taskGroups.getAll().toList();

  List<Task> getTaskList() => taskList.getAll().toList();

  List<TaskDate> getTaskDateList() => taskDate.getAll().toList();

  TaskGroup? getTaskGroup(String taskGroup) => _findTaskGroup(taskGroup);

  TaskDate getTaskDate(DateTime date) => _findTaskDate(date)!;

  List<Task> getTaskListByDate(DateTime date) =>
      _findTaskDate(date)!.tasks.toList();

  List<Task> getTaskListByGroup(String taskGroup) =>
      _findTaskGroup(taskGroup)!.tasks.toList();

  List<TaskGroup> getTaskGroupsByDate(DateTime date) =>
      _findTaskDate(date)!.taskGroups.toList();

  List<Task> getTaskListByGroupAndDate(TaskDate date, TaskGroup group) =>
      _findTaskListByGroupAndDate(date, group);

  Future setTheme(StudyTheme theme) async {
    this.theme.removeAll();
    this.theme.put(theme);
  }

  ///Add a task to both the ObjectBox and Firebase
  Future addTask(Task task) async {
    taskList.put(task);

    if(await _connection.status != 'none') {
      await addFBTask(task);
    }else{
      DataToUpload data = DataToUpload(addOrDeleteOrNeither: 0, operandType: 0, taskID: task.id);
      dataListToUpload.put(data);
    }
  }

  ///Add a task group to both the ObjectBox and Firebase.
  Future addTaskGroup(String taskGroup) async {
    TaskGroup newTaskGroup = TaskGroup(taskGroup: taskGroup);
    taskGroups.put(newTaskGroup);

    await addFBTaskGroup(taskGroup);
    if(await _connection.status != 'none') {
      await addFBTaskGroup(taskGroup);
    }else{
      DataToUpload data = DataToUpload(addOrDeleteOrNeither: 0, operandType: 1, taskID: newTaskGroup.id);
      dataListToUpload.put(data);
    }
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

  ///Bulk delete a list of tasks.
  ///Accomplished by accepting a task list then iteratively checks for the ones marked completed.
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

  ///Delete a task from both the ObjectBox and Firebase.
  ///If the task group associated with the task is empty,
  ///then the link between the task group and the associated task date is removed.
  ///It's long winded because of the inability for the object to be found in the List().
  Future deleteTask(Task task) async {
    TaskDate date = task.taskDate.target!;
    TaskGroup group = task.taskGroup.target!;


    await deleteFBTask(task);

    taskList.remove(task.id);

    // if (_findTaskListByGroupAndDate(date, group).isEmpty) {
    //   List<TaskGroup> taskGroupList = date.taskGroups.toList();
    //   List<TaskGroup> resultTaskGroupList = List.empty(growable: true);
    //   date.taskGroups.clear();
    //   date.taskGroups.applyToDb();
    //
    //   for (var value in taskGroupList) {
    //     if (value.taskGroup != group.taskGroup) {
    //       resultTaskGroupList.add(value);
    //     }
    //   }
    //   date.taskGroups.addAll(resultTaskGroupList);
    //   date.taskGroups.applyToDb();
    // }

    debugPrint(taskGroups.contains(group.id).toString());
    date.taskGroups.remove(taskGroups.get(group.id));

    if (date.tasks.isEmpty) {
      deleteTaskDate(date);
    }
  }

  Future deleteSelectedTaskGroups(List<TaskGroup> taskGroupList, List<bool> selectedGroups) async {
    int max = taskGroupList.length;
    for(int i = 0; i < max; i++){
      if(selectedGroups[i]){
        await deleteTaskGroup(taskGroupList[i]);
      }
    }
  }

  ///Delete a task group from both the ObjectBox and Firebase.
  Future deleteTaskGroup(TaskGroup taskGroup) async {
    await deleteFBTaskGroup(taskGroup.taskGroup );

    taskGroups.remove(taskGroup.id);
  }

  void deleteTaskDate(TaskDate date) {
    taskDate.remove(date.id);
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

  TaskDate? _findTaskDate(DateTime date) {
    List<TaskDate> tempDateList = getTaskDateList();

    for (var tempDate in tempDateList) {
      if (tempDate.year == date.year &&
          tempDate.month == date.month &&
          tempDate.day == date.day) {
        return tempDate;
      }
    }

    return null;
  }

  bool ifTaskDateExists(DateTime date) {
    if (_findTaskDate(date) == null) {
      return false;
    } else {
      return true;
    }
  }

  bool ifTaskGroupExistsInObjectBox(String taskGroup) {
    if (_findTaskGroup(taskGroup) != null) return true;
    return false;
  }
}
