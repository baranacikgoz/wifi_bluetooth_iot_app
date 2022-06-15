import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bluetooth_repository/core.dart';
import 'package:wifi_bluetooth_iot_app/core/instances.dart';

class ScanCubit extends Cubit<bool> {
  final BluetoothRepository _repository = BluetoothRepository.instance;

  //final BluetoothStatusCubit bluetoothStatusCubit;

  //late final StreamSubscription bluetoothStatusCubitSubscription;

  late final StreamSubscription scanStatusSubscription;

  static const Duration singleScanDuration = Duration(seconds: 20);

  ScanCubit() : super(false) {
    //monitorBluetoothStatus();
    monitorScanStatus();
  }

  Future<void> startScan() async {
    return _repository.startScan(duration: singleScanDuration);
  }

  Future<void> stopScan() {
    return _repository.stopScan();
  }

  StreamSubscription<bool> monitorScanStatus() {
    return scanStatusSubscription = _repository.isScanning().listen((isScanningNow) {
      log("isScanning: $isScanningNow");

      switch (isScanningNow) {
        case true:
          emit(true);
          break;

        case false:
          emit(false);
          break;
      }
    });
  }

  // StreamSubscription<BluetoothStatus> monitorBluetoothStatus() {
  //   return bluetoothStatusCubitSubscription = bluetoothStatusCubit.stream.listen((bluetoothStatus) {
  //     switch (bluetoothStatus) {
  //       case BluetoothStatus.OFF:
  //         // TODO: Handle this case.
  //         break;
  //       case BluetoothStatus.ON:
  //         // TODO: Handle this case.
  //         break;
  //       case BluetoothStatus.UNKNOWN:
  //         // TODO: Handle this case.
  //         break;
  //     }
  //   });
  // }
}
