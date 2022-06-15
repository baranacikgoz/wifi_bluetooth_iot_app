import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bluetooth_repository/core.dart';

import '../../core/instances.dart';

class BluetoothStatusCubit extends Cubit<BluetoothStatus> {
  late final StreamSubscription bluetoothStatusSubscription;

  BluetoothStatusCubit() : super(BluetoothStatus.unknown) {
    monitorBluetoothStatus();
  }

  StreamSubscription<BluetoothStatus> monitorBluetoothStatus() {
    return bluetoothStatusSubscription =
        BluetoothRepository.instance.status.listen((status) {
      emit(status);
    });
  }
}
