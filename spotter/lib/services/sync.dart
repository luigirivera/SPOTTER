import 'package:spotter/main.dart';
import '../models/sync_model.dart';
import 'firebase.dart';

Future uploadCaller() async {
  var doc = await objectbox.userDoc.get();
  if(!doc.exists){
    await initFBTaskCollection();
  }
  if(!objectbox.dataListToUpload.isEmpty()){
    upload(objectbox.dataListToUpload.getAll(), 0);
  }
}

Future<void> upload(List<DataToUpload> dataList, int index) async {
  if(dataList[index].operandType == 0 && dataList.length != index + 1){
    upload(dataList, index++);
  }
  if(dataList[index].operandType == 1){
    await addFBTaskGroup(objectbox.taskGroups.get(dataList[index].dataID!)!.taskGroup);
    return;
  }else if(dataList[index].operandType == 2){

  }
}
