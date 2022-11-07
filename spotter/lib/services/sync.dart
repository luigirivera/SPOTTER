import 'package:spotter/main.dart';
import 'package:spotter/models/user_model.dart';
import '../models/session_model.dart';
import '../models/sync_model.dart';
import '../models/task_model.dart';
import 'firebase.dart';
import 'auth.dart';

final AuthService _auth = AuthService();

Future uploadCaller() async {
  if (objectbox.getSpotterUser(_auth.currentUser!.uid!).deleteUser) {
    objectbox.deleteEverything();
  } else {
    var doc = await objectbox.taskCollection.doc(_auth.currentUser!.uid).get();
    if (!doc.exists) {
      await initFBTaskCollection();
    }

    var ssDoc =
        await objectbox.sessionCollection.doc(_auth.currentUser!.uid).get();

    if (!ssDoc.exists) {
      await initFBSessionCollection();
    }

    if (!objectbox.dataListToUpload.isEmpty()) {
      upload(objectbox.dataListToUpload.getAll(), 0);
    }
  }
}

Future<void> upload(List<DataToUpload> dataList, int index) async {
  if (dataList[index].operandType == 0 && dataList.length != index + 1) {
    upload(dataList, index++);
  }

  if (dataList[index].operandType == 1 || dataList[index].operandType == 2) {
    if (dataList[index].operandType == 1) {
      TaskGroup taskGroup = objectbox.taskGroups.get(dataList[index].groupID!)!;
      await addFBTaskGroup(taskGroup.taskGroup);
      return;
    } else if (dataList[index].operandType == 2) {
      TaskGroup taskGroup = objectbox.taskGroups.get(dataList[index].groupID!)!;
      TaskDate taskDate = objectbox.taskDate.get(dataList[index].dateID!)!;
      await addFBTaskDate(taskDate, taskGroup.taskGroup);
      return;
    }

    Task task = objectbox.taskList.get(dataList[index].taskID!)!;
    await addFBTask(task);
    return;
  } else {
    if (dataList[index].operandType == 3) {
      StudyCount count = objectbox.count.get(dataList[index].countID!)!;
      await addFBSS(count);
      return;
    } else if (dataList[index].operandType == 4) {
      StudyTheme theme = objectbox.theme.get(dataList[index].themeID!)!;
      await addFBTheme(theme);
      return;
    } else if (dataList[index].operandType == 5) {
      SessionDate date =
          objectbox.sessionDate.get(dataList[index].sessionDateID!)!;
      await addFBSSDate(date);
      return;
    }
  }
}

//TODO: Add a function to upload all Objectbox data to Firebase
Future<void> uploadAll() async {
  List<TaskGroup> taskGroups = objectbox.taskGroups.getAll();
  List<TaskDate> taskDates = objectbox.taskDate.getAll();
  List<Task> tasks = objectbox.taskList.getAll();
  List<StudyCount> counts = objectbox.count.getAll();
  List<StudyTheme> themes = objectbox.theme.getAll();
  List<SessionDate> sessionDates = objectbox.sessionDate.getAll();

  for (var taskGroup in taskGroups) {
    if (taskGroup.taskGroup.compareTo("General") != 0) {
      await addFBTaskGroup(taskGroup.taskGroup);
    }
  }

  for (var taskDate in taskDates) {
    for (var group in taskDate.taskGroups) {
      await addFBTaskDate(taskDate, group.taskGroup);
    }
  }

  for (var task in tasks) {
    await addFBTask(task);
  }

  for (var count in counts) {
    await addFBSS(count);
  }

  for (var theme in themes) {
    await addFBTheme(theme);
  }

  for (var dates in sessionDates) {
    await addFBSSDate(dates);
  }
}
