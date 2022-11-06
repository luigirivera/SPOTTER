import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotter/services/auth.dart';
import 'models/sync_model.dart';
import 'models/task_model.dart';
import 'models/session_model.dart';
import 'models/user_model.dart';
import 'objectbox.g.dart';
import 'services/connectivity.dart';
import 'services/firebase.dart';

class ObjectBox {
  ObjectBox();

  late Store store;
  late final Box<SpotterUser> users;
  late final Box<TaskGroup> taskGroups;
  late final Box<Task> taskList;
  late final Box<TaskDate> taskDate;
  late final Box<StudyTheme> theme;
  late final Box<StudyCount> count;
  late final Box<SessionDate> sessionDate;
  late final Box<DataToUpload> dataListToUpload;

  final CollectionReference taskCollection =
      FirebaseFirestore.instance.collection('Tasks');

  final CollectionReference sessionCollection =
      FirebaseFirestore.instance.collection('Study Session');

  final AuthService _auth = AuthService();
  final ConnectivityService _connection = ConnectivityService();

  /// Code section to open objectbox store / Init setters------------///
  ObjectBox._open(this.store) {
    users = Box<SpotterUser>(store);
    taskGroups = Box<TaskGroup>(store);
    taskList = Box<Task>(store);
    taskDate = Box<TaskDate>(store);
    theme = Box<StudyTheme>(store);
    count = Box<StudyCount>(store);
    sessionDate = Box<SessionDate>(store);
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

    if (await _connection.ifConnectedToInternet()) {
      await initFBTaskCollection();
    }
  }

  Future initSessionCollection() async {
    if (await _connection.ifConnectedToInternet()) {
      await initFBSessionCollection();
    }
  }

  StudyTheme getTheme() => theme.getAll().isEmpty
      ? StudyTheme(index: -1, folder: "1_trees", name: "trees")
      : theme.getAll().first;

  SpotterUser getSpotterUser(String uid) => _findUser(uid);

  List<TaskGroup> getTaskGroupList() => taskGroups.getAll().toList();

  List<Task> getTaskList() => taskList.getAll().toList();

  List<TaskDate> getTaskDateList() => taskDate.getAll().toList();

  TaskGroup? getTaskGroup(String taskGroup) => _findTaskGroup(taskGroup);

  TaskDate getTaskDate(DateTime date) => findTaskDate(date)!;

  List<Task> getTaskListByDate(DateTime date) =>
      findTaskDate(date)!.tasks.toList();

  List<Task> getTaskListByGroup(String taskGroup) =>
      _findTaskGroup(taskGroup)!.tasks.toList();

  List<TaskGroup> getTaskGroupsByDate(DateTime date) =>
      findTaskDate(date)!.taskGroups.toList();

  List<Task> getTaskListByGroupAndDate(TaskDate date, TaskGroup group) =>
      _findTaskListByGroupAndDate(date, group);

  double getStudySessionCount(DateTime date) =>
      _findStudySessionCountByDate(date);

  double _findStudySessionCountByDate(DateTime date) {
    return sessionDate
            .getAll()
            .where((element) => element.compareTo(
                SessionDate(year: date.year, month: date.month, day: date.day)))
            .isEmpty
        ? 0
        : count
            .getAll()
            .where((element) => element.sessionDate.target!.compareTo(
                SessionDate(year: date.year, month: date.month, day: date.day)))
            .first
            .count
            .toDouble();
  }

  Future<void> deleteEverything() async {
    if (await _connection.ifConnectedToInternet()) {
      await FirebaseFirestore.instance
          .runTransaction((Transaction transaction) async {
        recursivelyDeleteAllDocContent(
            taskCollection.doc(_auth.currentUser!.uid));
        transaction.delete(taskCollection.doc(_auth.currentUser!.uid));
        transaction.delete(sessionCollection.doc(_auth.currentUser!.uid));
      }).whenComplete(() async {
        await _auth.deleteUser();
      });
    } else {
      SpotterUser user = _findUser(_auth.currentUser!.uid!);
      user.deleteUser = true;
      users.put(user);
    }

    taskGroups.removeAll();
    taskDate.removeAll();
    taskList.removeAll();
    theme.removeAll();
    count.removeAll();
    sessionDate.removeAll();
    dataListToUpload.removeAll();
  }

  Future<void> clearData() async {
    taskGroups.removeAll();
    taskDate.removeAll();
    taskList.removeAll();
    theme.removeAll();
    count.removeAll();
    sessionDate.removeAll();
    dataListToUpload.removeAll();
  }

  void importData() async {
    List<String> groups = await getFirebaseTaskGroups();
    for (int i = 0; i < groups.length; i++) {
      taskGroups.put(TaskGroup(taskGroup: groups.elementAt(i)));
    }

    for (var group in taskGroups.getAll()) {
      List<String> dates = await getFirebaseTaskDates(taskCollection
          .doc(_auth.currentUser!.uid)
          .collection(group.taskGroup)
          .doc('dates'));
      for (int i = 0; i < dates.length; i++) {
        List<String> parseDate = dates.elementAt(i).split('-');
        DateTime dt = DateTime.utc(
            int.parse(parseDate.elementAt(0)),
            int.parse(parseDate.elementAt(1)),
            int.parse(parseDate.elementAt(2)));

        TaskDate td = TaskDate(
            year: dt.year, month: dt.month, day: dt.day, weekday: dt.weekday);
        bool exists = false;

        List<int> indices = List.empty(growable: true);
        for (int i = 0; i < taskDate.getAll().length; i++) {
          if (taskDate.getAll().elementAt(i).compareTo(td)) {
            exists = true;
            indices.add(i);
            break;
          }
        }

        for (var index in indices) {
          TaskDate td2 = taskDate.getAll().removeAt(index);
          td2.taskGroups.add(group);
          taskDate.put(td2);
        }

        if (!exists) {
          td.taskGroups.add(group);
          taskDate.put(td);
        }
      }
    }

    for (var group in taskGroups.getAll()) {
      List dynamicList = List.empty(growable: true);
      var dates = await taskCollection
          .doc(_auth.currentUser!.uid)
          .collection(group.taskGroup)
          .doc('dates')
          .get()
          .then((value) => dynamicList = value['dates']);
      List<String> datesList = dynamicList.cast<String>();
      for (var dates in datesList) {
        List<String> parseDate = dates.split('-');
        await taskCollection
            .doc(_auth.currentUser!.uid)
            .collection(group.taskGroup)
            .doc('dates')
            .collection(dates)
            .get()
            .then((value) => value.docs.forEach((element) {
                  Task task = Task(
                      completed: element.get('completed'),
                      taskDescription: element.get('description'));
                  task.taskGroup.target = group;

                  TaskDate td = findTaskDate(DateTime.utc(
                    int.parse(parseDate.elementAt(0)),
                    int.parse(parseDate.elementAt(1)),
                    int.parse(parseDate.elementAt(2)),
                  ))!;
                  task.taskDate.target = td;

                  group.tasks.add(task);
                  td.tasks.add(task);

                  taskList.put(task);

                  print(task.taskDescription);
                }));
      }
    }

    List<String> sessionDates = await getFirebaseSessionDates(
        sessionCollection.doc(_auth.currentUser!.uid));

    for (var date in sessionDates) {
      List<String> parseDate = date.split('-');
      SessionDate sd = SessionDate(
          year: int.parse(parseDate.elementAt(0)),
          month: int.parse(parseDate.elementAt(1)),
          day: int.parse(parseDate.elementAt(2)));
      sessionDate.put(sd);
    }

    theme.put(await getFirebaseTheme());

    for (var date in sessionDate.getAll()) {
      String dateString = '${date.year}-${date.month}-${date.day}';
      var snapshot = await sessionCollection
          .doc(_auth.currentUser!.uid)
          .collection(dateString)
          .get()
          .then((value) => value.docs.forEach((element) {
                StudyCount c = StudyCount(count: element.get('count'));
                c.sessionDate.target = date;
                count.put(c);
              }));
    }
  }

  Future addToSessionCount() async {
    DateTime date = DateTime.now();
    SessionDate? sDate = sessionDate
            .getAll()
            .where((element) => element.compareTo(
                SessionDate(year: date.year, month: date.month, day: date.day)))
            .isEmpty
        ? null
        : sessionDate
            .getAll()
            .where((element) => element.compareTo(
                SessionDate(year: date.year, month: date.month, day: date.day)))
            .first;

    if (sDate == null) {
      SessionDate date = SessionDate(
          year: DateTime.now().year,
          month: DateTime.now().month,
          day: DateTime.now().day);

      StudyCount studyCount = StudyCount(count: 1);
      studyCount.sessionDate.target = date;
      count.put(studyCount);

      date.session.target = studyCount;
      sessionDate.put(date);

      if (await _connection.ifConnectedToInternet()) {
        await addFBSS(count.getAll().first);
        await addFBSSDate(date);
      } else {
        DataToUpload data = DataToUpload(
            addOrDeleteOrNeither: 0, operandType: 3, countID: studyCount.id);
        dataListToUpload.put(data);

        DataToUpload data2 = DataToUpload(
            addOrDeleteOrNeither: 0, operandType: 5, sessionDateID: date.id);
        dataListToUpload.put(data2);
      }
    } else {
      StudyCount studyCount = count
          .getAll()
          .where((element) => element.sessionDate.target!.compareTo(sDate))
          .first;
      StudyCount toRemove = count.getAll().first;
      count.removeAll();
      studyCount.count++;
      count.put(studyCount);

      if (await _connection.ifConnectedToInternet()) {
        await addFBSS(count.getAll().first);
      } else {
        DataToUpload data1 = DataToUpload(
            addOrDeleteOrNeither: 1, operandType: 3, countID: toRemove.id);
        dataListToUpload.put(data1);
        DataToUpload data2 = DataToUpload(
            addOrDeleteOrNeither: 0, operandType: 3, countID: studyCount.id);
        dataListToUpload.put(data2);
      }
    }
  }

  Future setTheme(StudyTheme theme) async {
    StudyTheme? toRemove =
        this.theme.getAll().isEmpty ? null : this.theme.getAll().first;
    this.theme.removeAll();
    this.theme.put(theme);

    if (await _connection.ifConnectedToInternet()) {
      await addFBTheme(theme);
    } else {
      if (toRemove != null) {
        DataToUpload data1 = DataToUpload(
            addOrDeleteOrNeither: 1, operandType: 2, themeID: toRemove.id);
        dataListToUpload.put(data1);
      }
      DataToUpload data2 = DataToUpload(
          addOrDeleteOrNeither: 0, operandType: 4, themeID: theme.id);
      dataListToUpload.put(data2);
    }
  }

  ///Add a task to both the ObjectBox and Firebase
  Future addTask(Task task) async {
    taskList.put(task);

    if (await _connection.ifConnectedToInternet()) {
      await addFBTask(task);
    } else {
      DataToUpload data = DataToUpload(
          addOrDeleteOrNeither: 0, operandType: 0, taskID: task.id);
      dataListToUpload.put(data);
    }
  }

  ///Add a task group to both the ObjectBox and Firebase.
  Future addTaskGroup(String taskGroup) async {
    TaskGroup newTaskGroup = TaskGroup(taskGroup: taskGroup);
    taskGroups.put(newTaskGroup);

    if (await _connection.ifConnectedToInternet()) {
      await addFBTaskGroup(taskGroup);
    } else {
      DataToUpload data = DataToUpload(
          addOrDeleteOrNeither: 0, operandType: 1, groupID: newTaskGroup.id);
      dataListToUpload.put(data);
    }
  }

  Future<TaskDate> addTaskDate(DateTime date, String taskGroup) async {
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

    if (await _connection.ifConnectedToInternet()) {
      await deleteFBTask(task);
    } else {
      DataToUpload data = DataToUpload(
          addOrDeleteOrNeither: 1, operandType: 0, taskID: task.id);
      dataListToUpload.put(data);
    }

    taskList.remove(task.id);

    //Have to do it this way because of the ObjectBox implementation issue.
    //Found OB dev to back me up on that here:
    //https://stackoverflow.com/questions/47247670/objectbox-source-entity-has-no-id-should-have-been-put-before
    if (_findTaskListByGroupAndDate(date, group).isEmpty) {
      List<TaskGroup> taskGroupList = date.taskGroups.toList();
      for (int i = 0; i < taskGroupList.length; i++) {
        if (taskGroupList[i].taskGroup == group.taskGroup) {
          date.taskGroups.removeAt(i);
        }
      }
      date.taskGroups.applyToDb();
    }

    if (date.tasks.isEmpty) {
      deleteTaskDate(date);
    }
  }

  Future deleteSelectedTaskGroups(
      List<TaskGroup> taskGroupList, List<bool> selectedGroups) async {
    int max = taskGroupList.length;
    for (int i = 0; i < max; i++) {
      if (selectedGroups[i]) {
        await deleteTaskGroup(taskGroupList[i]);
      }
    }
  }

  ///Delete a task group from both the ObjectBox and Firebase.
  Future deleteTaskGroup(TaskGroup taskGroup) async {
    if (await _connection.ifConnectedToInternet()) {
      await deleteFBTaskGroup(taskGroup.taskGroup);
    } else {
      DataToUpload data = DataToUpload(
          addOrDeleteOrNeither: 1, operandType: 1, groupID: taskGroup.id);
      dataListToUpload.put(data);
    }

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

  TaskDate? findTaskDate(DateTime date) {
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

  SpotterUser _findUser(String uid) {
    List<SpotterUser> spotterUsers = users.getAll();
    SpotterUser result = SpotterUser();

    for (var user in spotterUsers) {
      if (user.uid! == uid) {
        result = user;
      }
    }

    return result;
  }

  bool ifTaskDateExists(DateTime date) {
    if (findTaskDate(date) == null) {
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
