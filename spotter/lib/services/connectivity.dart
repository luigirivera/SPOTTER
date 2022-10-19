import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity connection = Connectivity();

  StreamController<ConnectivityResult> connectivityStreamController =
      StreamController<ConnectivityResult>();

  ConnectivityService() {
    connection.onConnectivityChanged.listen((ConnectivityResult result) {
      connectivityStreamController.add(result);
    });
  }

  Stream<ConnectivityResult> get statusStream {
    return connectivityStreamController.stream;
  }

  Future<String> get status async {
    return resultParse(await connection.checkConnectivity());
  }

  Future<bool> ifConnectedToInternet() async {
    return await status != 'none';
  }

  ///Not sure which ones the phone uses I set the extra ones to none for now
  String resultParse(ConnectivityResult result){
    String output = 'error';
    switch(result){
      case ConnectivityResult.bluetooth:
        output = 'none';
        break;
      case ConnectivityResult.wifi:
        output = 'wifi';
        break;
      case ConnectivityResult.ethernet:
        output = 'none';
        break;
      case ConnectivityResult.mobile:
        output = 'mobile';
        break;
      case ConnectivityResult.none:
        output = 'none';
        break;
      case ConnectivityResult.vpn:
        output = 'none';
        break;
    }

    return output;
  }
}
