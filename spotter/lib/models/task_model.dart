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
  DateTime date;

  Task({required this.taskDescription, required this.taskGroup, required this.completed, required this.date});

  @override
  String toString() => 'Task: $taskDescription, Task Group: $taskGroup, Completed: $completed';
}

@Entity()
class TaskGroup{
  @Id()
  int id = 0;
  String taskGroup;

  TaskGroup({required this.taskGroup});

  @override
  String toString() => 'Task Group: $taskGroup';
}