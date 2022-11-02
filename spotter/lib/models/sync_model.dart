import 'package:objectbox/objectbox.dart';

@Entity()
class DataToUpload {
  @Id()
  int id = 0;

  int? taskID;
  int? groupID;
  int? dateID;
  int? countID;
  int? themeID;

  bool deleteUser;

  ///-1: neither, 0: add, 1: delete
  int addOrDeleteOrNeither;

  ///0: task, 1: taskGroup, 2: taskDate, 3: count, 4: theme
  int? operandType;

  DataToUpload(
      {required this.addOrDeleteOrNeither,
      this.operandType,
      this.taskID,
      this.groupID,
      this.dateID,
      this.countID,
      this.themeID,
      this.deleteUser = false});
}
