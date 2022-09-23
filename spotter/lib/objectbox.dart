import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'models/task_model.dart';
import 'objectbox.g.dart';

class ObjectBox {
  ObjectBox();
  late Store store;
  late final Box<TaskGroup> taskGroups;
  late final Box<Task> taskList;

  ObjectBox._open(this.store) {
    taskGroups = Box<TaskGroup>(store);
    taskList = Box<Task>(store);
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

  List<TaskGroup> getTaskGroups() =>
      taskGroups.getAll().toList();

  List<Task> getTaskList() => taskList.getAll().toList();

  void addTaskGroup(String taskGroup) {
    taskGroups.put(TaskGroup(taskGroup: taskGroup));
  }

  void deleteTaskGroup(String taskGroup) {
    taskGroups.put(TaskGroup(taskGroup: taskGroup));
  }

  void addTask(Task task) {
    taskList.put(task);
  }

  void deleteTask(Task task) {
    taskList.remove(task.id);
  }
}
