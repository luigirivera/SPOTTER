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
      'groups': ['General'],
    });
  }

  ///==////////////////////////////////////////////////////////////////

  /// Getters ------------------------------------------------------///
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

  List<Task> getTaskListByGroupAndDate(DateTime date, TaskGroup group) => _findTaskListByGroupAndDate(date, group);

  ///==////////////////////////////////////////////////////////////////

  ///Objectbox Management ------------------------------------------///
  void addTask(Task task) {
    String taskGroup = task.taskGroup.target!.taskGroup;
    taskCollection
        .doc(uid)
        .collection(taskGroup)
        .doc(task.taskDescription)
        .set({
      'description': task.taskDescription,
      'group': taskGroup,
      'completed': task.completed,
    });
    taskList.put(task);
  }

  TaskDate addTaskDate(DateTime date) {
    TaskDate newTaskDate =
        TaskDate(year: date.year, month: date.month, day: date.day);
    taskDate.put(newTaskDate);
    return newTaskDate;
  }

  Future addTaskGroup(String taskGroup) async {
    List<String> taskGroupList = await _getFirebaseTaskGroups();
    taskGroupList.add(taskGroup);
    await taskCollection.doc(uid).set({'groups': taskGroupList});

    taskGroups.put(TaskGroup(taskGroup: taskGroup));
  }

  Future deleteTaskGroup(String taskGroup) async {
    List<String> taskGroupList = await _getFirebaseTaskGroups();
    int index = taskGroupList.indexOf(taskGroup);
    taskGroupList.removeAt(index);
    await taskCollection.doc(uid).set({'groups': taskGroupList});

    TaskGroup group = _findTaskGroup(taskGroup)!;
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

  List<Task> _findTaskListByGroupAndDate(DateTime date, TaskGroup group){
    List<Task> tempTaskList = group.tasks;
    List<Task> resultTaskList = List.empty(growable: true);
    TaskDate tempTaskDate = getTaskDate(date);
    for(var task in tempTaskList){
      if(task.taskDate.target!.compareTo(tempTaskDate)){
        resultTaskList.add(task);
      }
    }
    return resultTaskList;
  }

  ///This is for assigning the object relations
  ///The "id" of the TaskDate obj is needed to assign correctly
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
        await taskCollection.doc(uid).collection(taskGroup).limit(1).get();
    return snapshot.docs.isNotEmpty;
  }

  Future _getFirebaseTaskGroups() async {
    List dynamicList = [];
    List<String> taskGroups = <String>[];
    await taskCollection.doc(uid).get().then((value) {
      dynamicList = value.toString().contains('groups') ? value['groups'] : List.empty(growable: true);
    });
    taskGroups = dynamicList.cast<String>();

    return taskGroups;
  }

  ///==////////////////////////////////////////////////////////////////
}
