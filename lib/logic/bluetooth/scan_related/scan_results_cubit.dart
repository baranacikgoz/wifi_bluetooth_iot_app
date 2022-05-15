import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bluetooth_repository/core.dart';
import 'package:iot_connect_app/core/instances.dart';

class ScanResultsCubit extends Cubit<List<DeviceResult>> {
  late final StreamSubscription scanResultsSubscription;

  ScanResultsCubit() : super([]) {
    monitorScanResults();
  }

  StreamSubscription<List<DeviceResult>> monitorScanResults() {
    return scanResultsSubscription = bluetoothRepositoryInstance.scanResults.listen((result) {
      emit(result);
    });
  }
}
