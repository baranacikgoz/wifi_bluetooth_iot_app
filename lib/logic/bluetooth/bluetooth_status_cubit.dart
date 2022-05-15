import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bluetooth_repository/core.dart';

import '../../core/instances.dart';

class BluetoothStatusCubit extends Cubit<BluetoothStatus> {
  late final StreamSubscription bluetoothStatusSubscription;

  BluetoothStatusCubit() : super(BluetoothStatus.UNKNOWN) {
    monitorBluetoothStatus();
  }

  StreamSubscription<BluetoothStatus> monitorBluetoothStatus() {
    return bluetoothStatusSubscription = bluetoothRepositoryInstance.status.listen((status) {
      emit(status);
    });
  }
}
