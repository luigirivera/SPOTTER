import 'package:objectbox/objectbox.dart';
import 'package:spotter/models/task_model.dart';

@Entity()
class UploadData{
  @Id()
  int id = 0;

  int? taskID;
  int? taskGroupID;
  int? taskDateID;

  int addOrDelete;
  int operand;

  UploadData({required this.addOrDelete, required this.operand});
}