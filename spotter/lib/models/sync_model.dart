import 'package:objectbox/objectbox.dart';

@Entity()
class DataToUpload{
  @Id()
  int id = 0;

  int? dataID;

  bool initiateFBTaskCollection;
  bool deleteUser;
  ///-1: neither, 0: add, 1: delete
  int addOrDeleteOrNeither;
  ///0: task, 1: taskGroup, 2: taskDate
  int? operandType;

  DataToUpload({required this.addOrDeleteOrNeither, this.operandType, this.dataID, this.initiateFBTaskCollection = false, this.deleteUser = false});
}