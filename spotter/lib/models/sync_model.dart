import 'package:objectbox/objectbox.dart';

@Entity()
class DataToUpload{
  @Id()
  int id = 0;

  int? taskID;
  int? groupID;
  int? dateID;


  bool deleteUser;
  ///-1: neither, 0: add, 1: delete
  int addOrDeleteOrNeither;
  ///0: task, 1: taskGroup, 2: taskDate
  int? operandType;

  DataToUpload({required this.addOrDeleteOrNeither, this.operandType, this.taskID, this.groupID, this.dateID, this.deleteUser = false});
}