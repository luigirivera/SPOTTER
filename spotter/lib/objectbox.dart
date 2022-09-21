import 'package:path_provider/path_provider.dart';
import 'models/task_model.dart';
import 'objectbox.g.dart';

class ObjectBox{
  ObjectBox();
  late final Store store;
  late final Box<String> taskCollectionNames;
  late final Box<Task> taskCollections;

  ObjectBox._create(this.store){
    taskCollectionNames = Box<String>(store);
    taskCollections = Box<Task>(store);
    if(taskCollectionNames.isEmpty()){
      taskCollectionNames.put('General');
    }
  }

  static Future<ObjectBox> create() async{
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final store = openStore(directory: documentsDirectory.path);
    return ObjectBox._create(store);
  }

  List<String> getTaskCollectionNames() => taskCollectionNames.getAll().toList();

  List<Task> getTasks() => taskCollections.getAll().toList();

  void addTaskCollectionName(String taskGroup){
    taskCollectionNames.put(taskGroup);
  }

  void deleteTaskCollectionName(String taskGroup){
    taskCollectionNames.put(taskGroup);
  }

  void addTask(Task task){
    taskCollections.put(task);
  }

  void deleteTask(Task task){
    taskCollections.remove(task.id);
  }
}