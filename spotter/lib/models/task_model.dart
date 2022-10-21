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

  bool equals(TaskGroup otherTaskGroup){
    return id == otherTaskGroup.id && taskGroup == otherTaskGroup.taskGroup;
  }

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
  int weekday;

  final ToMany<TaskGroup> taskGroups = ToMany<TaskGroup>();

  @Backlink()
  final ToMany<Task> tasks = ToMany<Task>();

  TaskDate({required this.year, required this.month, required this.day, required this.weekday});

  ///If the dates are the same then return true
  bool compareTo(TaskDate date){
    return year == date.year && month == date.month && day == date.day && weekday == date.weekday;
  }
}
