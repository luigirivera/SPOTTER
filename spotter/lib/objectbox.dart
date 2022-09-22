import 'package:path_provider/path_provider.dart';
import 'models/task_model.dart';
import 'objectbox.g.dart';

class ObjectBox{
  ObjectBox();
  late final Store store;
  late final Box<TaskGroup> taskGroups;
  late final Box<Task> taskList;

  ObjectBox._create(this.store){
    taskGroups = Box<TaskGroup>(store);
    taskList = Box<Task>(store);
    if(taskGroups.isEmpty()){
      taskGroups.put(TaskGroup(taskGroup: 'General'));
    }
  }

  static Future<ObjectBox> create() async{
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final store = await openStore(directory: documentsDirectory.path);
    return ObjectBox._create(store);
  }

  List<TaskGroup> getTaskGroups() => taskGroups.getAll().toList();

  List<Task> getTaskList() => taskList.getAll().toList();

  void addTaskGroup(String taskGroup){
    taskGroups.put(TaskGroup(taskGroup: taskGroup));
  }

  void deleteTaskGroup(String taskGroup){
    taskGroups.put(TaskGroup(taskGroup: taskGroup));
  }

  void addTask(Task task){
    taskList.put(task);
  }

  void deleteTask(Task task){
    taskList.remove(task.id);
  }
}