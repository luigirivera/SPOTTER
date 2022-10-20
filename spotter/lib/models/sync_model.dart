import 'package:objectbox/objectbox.dart';
import 'package:spotter/models/task_model.dart';

@Entity()
class DataToUpload{
  @Id()
  int id = 0;

  int? taskID;
  int? taskGroupID;
  int? taskDateID;

  bool initiateFBTaskCollection = false;
  ///-1: neither, 0: add, 1: delete
  int addOrDeleteOrNeither;
  ///0: task, 1: taskGroup, 2: taskDate
  int? operandType;

  DataToUpload({required this.addOrDeleteOrNeither, this.operandType, this.taskID, this.taskGroupID, this.taskDateID, this.initiateFBTaskCollection = false});
}