import 'package:objectbox/objectbox.dart';

///Making the Tasks object and filling it with some default values
///These are subjected to change by the user so pls don't add final tag
@Entity()
class Task {
  @Id()
  int id = 0; //don't delete this. it's for objectbox
  String taskDescription;
  String taskGroup;
  bool completed = false;

  Task({required this.taskDescription, required this.taskGroup, required this.completed});

  @override
  String toString() => '${taskDescription}taskGroup: $taskGroup completed: $completed';
}

@Entity()
class TaskCollectionList{
  @Id()
  int id = 0; //don't delete this. it's for objectbox
  List<String> taskCollectionNames;

  TaskCollectionList({required this.taskCollectionNames});
}