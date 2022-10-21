import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotter/services/auth.dart';
import '../models/task_model.dart';

final CollectionReference taskCollection =
    FirebaseFirestore.instance.collection('Tasks');
final AuthService _auth = AuthService();

Future addFBTask(Task task) async {
  String taskGroup = task.taskGroup.target!.taskGroup;
  TaskDate date = task.taskDate.target!;

  await taskCollection
      .doc(_auth.currentUser!.uid)
      .collection(taskGroup)
      .doc('${date.year}-${date.month}-${date.day}')
      .collection('tasks')
      .doc(task.taskDescription)
      .set({
    'description': task.taskDescription,
    'group': taskGroup,
    'completed': task.completed,
  });
}

Future addFBTaskGroup(String taskGroup) async {
  List<String> taskGroupList = await getFirebaseTaskGroups();
  taskGroupList.add(taskGroup);
  await taskCollection
      .doc(_auth.currentUser!.uid)
      .set({'groups': taskGroupList});
}

Future deleteFBTask(Task task) async {
  TaskDate date = task.taskDate.target!;
  TaskGroup group = task.taskGroup.target!;

  await taskCollection
      .doc(_auth.currentUser!.uid)
      .collection(group.taskGroup)
      .doc('${date.year}/${date.month}/${date.day}')
      .collection('tasks')
      .doc(task.taskDescription)
      .delete();
}

Future deleteFBTaskGroup(String taskGroup) async {
  List<String> taskGroupList = await getFirebaseTaskGroups();
  int index = taskGroupList.indexOf(taskGroup);
  taskGroupList.removeAt(index);
  return await taskCollection
      .doc(_auth.currentUser!.uid)
      .set({'groups': taskGroupList});
}

Future getFirebaseTaskGroups() async {
  List dynamicList = List.empty(growable: true);
  List<String> taskGroups = List.empty(growable: true);
  await taskCollection.doc(_auth.currentUser!.uid).get().then((value) {
    dynamicList = value['groups'];
  });
  taskGroups = dynamicList.cast<String>();

  return taskGroups;
}

Future ifCollectionExistsOnFirebase(String taskGroup) async {
  var snapshot = await taskCollection
      .doc(_auth.currentUser!.uid)
      .collection(taskGroup)
      .limit(1)
      .get();
  return snapshot.docs.isNotEmpty;
}

Future recursivelyDeleteAllDocContent(DocumentReference doc) async {
  await _rDeleteAllDoc(doc);
}

Future _rDeleteAllDoc(DocumentReference doc) async {
  
}
