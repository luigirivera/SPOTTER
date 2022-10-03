import 'package:objectbox/objectbox.dart';

///Making the Tasks object and filling it with some default values
///These are subjected to change by the user so pls don't add final tag
@Entity()
class Task {
  @Id()
  int id = 0; //don't delete this. it's for objectbox
  String taskDescription;
  bool completed = false;

  final taskGroup = ToOne<TaskGroup>();
  final taskDate = ToOne<TaskDate>();

  Task({required this.taskDescription, required this.completed});

  @override
  String toString() =>
      'Task: $taskDescription, Task Group: $taskGroup, Completed: $completed';
}

@Entity()
class TaskGroup {
  @Id()
  int id = 0;
  String taskGroup;

  @Backlink()
  final tasks = ToMany<Task>();

  TaskGroup({required this.taskGroup});

  @override
  String toString() => 'Task Group: $taskGroup';
}

@Entity()
class TaskDate {
  @Id()
  int id = 0;
  int year;
  int month;
  int day;

  @Backlink()
  final ToMany<Task> tasks = ToMany<Task>();

  final ToMany<TaskGroup> taskGroups = ToMany<TaskGroup>();

  TaskDate({required this.year, required this.month, required this.day});

  bool compareTo(TaskDate otherTaskDate){
    if(year == otherTaskDate.year && month == otherTaskDate.month && day == otherTaskDate.day){
      return true;
    }
    return false;
  }
}
