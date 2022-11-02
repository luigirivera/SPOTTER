import 'package:spotter/main.dart';
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
    //operandType 3 and 4
  }
}
