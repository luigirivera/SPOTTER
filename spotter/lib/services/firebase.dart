import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';
import 'auth.dart';

final CollectionReference _userCollection =
    FirebaseFirestore.instance.collection('Tasks');

final CollectionReference _taskCollection =
    FirebaseFirestore.instance.collection('Study Session');
final AuthService _auth = AuthService();

Future<void> initFBTaskCollection() async {
  await _userCollection.doc(_auth.currentUser!.uid).set({
    'groups': ['General'],
  });
  await _userCollection
      .doc(_auth.currentUser!.uid)
      .collection('General')
      .doc('dates')
      .set({'dates': []});
}

Future<void> initFBSessionCollection() async {
  await _taskCollection.doc(_auth.currentUser!.uid).set({'dates': []});
}

Future<void> addFBTask(Task task) async {
  String taskGroup = task.taskGroup.target!.taskGroup;
  TaskDate date = task.taskDate.target!;

  await _userCollection
      .doc(_auth.currentUser!.uid)
      .collection(taskGroup)
      .doc('dates')
      .collection('${date.year}-${date.month}-${date.day}')
      .doc(task.taskDescription)
      .set({
    'description': task.taskDescription,
    'group': taskGroup,
    'completed': task.completed,
  });
}

Future<void> addFBTaskGroup(String taskGroup) async {
  List<String> taskGroupList = await getFirebaseTaskGroups();
  taskGroupList.add(taskGroup);
  await _userCollection
      .doc(_auth.currentUser!.uid)
      .set({'groups': taskGroupList});
  await _userCollection
      .doc(_auth.currentUser!.uid)
      .collection(taskGroup)
      .doc('dates')
      .set({'dates': []});
}

Future<void> addFBTaskDate(TaskDate taskDate, String taskGroup) async {
  DocumentReference dateDocRef = _userCollection
      .doc(_auth.currentUser!.uid)
      .collection(taskGroup)
      .doc('dates');
  List<String> taskDateList = await getFirebaseTaskDates(dateDocRef);
  taskDateList.add('${taskDate.year}-${taskDate.month}-${taskDate.day}');
  await dateDocRef.set({'dates': taskDateList});
}

Future<void> deleteFBTask(Task task) async {
  TaskDate date = task.taskDate.target!;
  TaskGroup group = task.taskGroup.target!;

  await _userCollection
      .doc(_auth.currentUser!.uid)
      .collection(group.taskGroup)
      .doc('dates')
      .collection('${date.year}-${date.month}-${date.day}')
      .doc(task.taskDescription)
      .delete();
}

Future<void> deleteFBTaskGroup(String taskGroup) async {
  List<String> taskGroupList = await getFirebaseTaskGroups();
  int index = taskGroupList.indexOf(taskGroup);
  taskGroupList.removeAt(index);
  await _userCollection
      .doc(_auth.currentUser!.uid)
      .set({'groups': taskGroupList});
}

Future<void> deleteFBTaskDate(TaskDate taskDate, String taskGroup) async {
  DocumentReference dateDocRef = _userCollection
      .doc(_auth.currentUser!.uid)
      .collection(taskGroup)
      .doc('dates');
  List<String> taskDateList = await getFirebaseTaskDates(dateDocRef);
  int index = taskDateList
      .indexOf('${taskDate.year}-${taskDate.month}-${taskDate.day}');
  taskDateList.removeAt(index);
  await dateDocRef.set({'dates': taskDateList});
}

Future<List<String>> getFirebaseTaskGroups() async {
  List dynamicList = List.empty(growable: true);
  List<String> taskGroups = List.empty(growable: true);
  await _userCollection.doc(_auth.currentUser!.uid).get().then((value) {
    dynamicList = value['groups'];
  });
  taskGroups = dynamicList.cast<String>();

  return taskGroups;
}

Future<List<String>> getFirebaseTaskDates(DocumentReference dateDocRef) async {
  List dynamicList = List.empty(growable: true);
  List<String> taskDates = List.empty(growable: true);
  await dateDocRef.get().then((value) {
    dynamicList = value['dates'];
  });
  taskDates = dynamicList.cast<String>();

  return taskDates;
}

Future<bool> ifCollectionExistsOnFirebase(String taskGroup) async {
  var snapshot = await _userCollection
      .doc(_auth.currentUser!.uid)
      .collection(taskGroup)
      .limit(1)
      .get();
  return snapshot.docs.isNotEmpty;
}

Future<void> recursivelyDeleteAllDocContent(DocumentReference doc) async {
  DocumentReference userDocRef = _userCollection.doc(_auth.currentUser!.uid);
  DocumentReference dateDocRef;
  List<String> taskGroups = await getFirebaseTaskGroups();
  List<String> taskDates;
  int taskGroupsTotal = taskGroups.length;
  int taskDatesTotal;

  for (int i = 0; i < taskGroupsTotal; i++) {
    dateDocRef = userDocRef.collection(taskGroups[i]).doc('dates');
    taskDates = await getFirebaseTaskDates(dateDocRef);
    taskDatesTotal = taskDates.length;

    for (int j = 0; j < taskDatesTotal; j++) {
      dateDocRef.collection(taskDates[j]).get().then((doc) {
        doc.docs.clear();
      });
    }
  }
}
