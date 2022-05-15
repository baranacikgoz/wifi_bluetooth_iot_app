import 'dart:async';
import 'dart:developer';

import 'package:bluetooth_repository/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../scan_related/scan_results_cubit.dart';

class DeviceConnectionCubit extends Cubit<DeviceConnectionState> {
  final ScanResultsCubit scanResultsCubit;
  late final StreamSubscription scanResultsSubsription;

  late StreamSubscription connectedDeviceStateSubscription;

  //static const Duration connectTimeOut = Duration(seconds: 20);

  Map<BluetoothDevice, BluetoothDeviceState> _devicesAndStatus = {};

  DeviceConnectionCubit({required this.scanResultsCubit}) : super(Disconnected());

  StreamSubscription monitorScanResults() {
    return scanResultsSubsription = scanResultsCubit.stream.listen((_scanResults) {
      _devicesAndStatus = {};
      _scanResults.map((_result) {
        _devicesAndStatus.addAll({_result.device: BluetoothDeviceState.disconnected});
      });
    });
  }

  void connectDevice(BluetoothDevice device) async {
    emit(TryingToConnect(device: device));
    try {
      await device.connect();
      emit(Connected(device: device));
    } catch (e) {
      emit(ConnectAttempFailed(device: device, errorMessage: e.toString()));
      emit(Disconnected());
    }
  }

  void disconnectDevice(BluetoothDevice device) async {
    emit(TryingToDisonnect());
    try {
      await device.disconnect();
      emit(Disconnected());
    } catch (e) {
      emit(ConnectAttempFailed(device: device, errorMessage: e.toString()));
      connectedDeviceStateSubscription.cancel();
    }
  }

  StreamSubscription monitorConnectedDeviceState(BluetoothDevice device) {
    return connectedDeviceStateSubscription = device.state.listen((_deviceState) {
      log("Device state changed: $_deviceState");

      switch (_deviceState) {
        case BluetoothDeviceState.disconnected:
          emit(Disconnected());
          break;

        // case BluetoothDeviceState.connecting:
        //   break;
        // case BluetoothDeviceState.connected:
        //   break;

        // case BluetoothDeviceState.disconnecting:
        //   break;

        default:
          () {};
          break;
      }
    });
  }
  // StreamSubscription monitorConnectedDevices() {}

  // void connectDevice(BluetoothDevice device) async {

  //   _devicesAndStatus.update(device, (value) => BluetoothDeviceState.connecting);

  //   try {
  //     await device.connect();
  //     _devicesAndStatus.update(device, (value) => BluetoothDeviceState.connected);
  //   } catch (e) {
  //     _devicesAndStatus.update(device, (value) => BluetoothDeviceState.disconnected);
  //   }
  // }

  // monitorDeviceStates(List<BluetoothDevice> devices) async {
  //   _devicesAndStatus.
  //   }
}

abstract class DeviceConnectionState {}

class Disconnected extends DeviceConnectionState {
  // final BluetoothDevice device;
  // Disconnected({
  //   required this.device,
  // });
}

class TryingToConnect extends DeviceConnectionState {
  final BluetoothDevice device;
  TryingToConnect({
    required this.device,
  });
}

class TryingToDisonnect extends DeviceConnectionState {}

class ConnectAttempFailed extends AttempFailed {
  ConnectAttempFailed({required BluetoothDevice device, required String errorMessage})
      : super(device: device, errorMessage: errorMessage);
}

class DisconnectAttempFailed extends AttempFailed {
  DisconnectAttempFailed({required BluetoothDevice device, required String errorMessage})
      : super(device: device, errorMessage: errorMessage);
}

class Connected extends DeviceConnectionState {
  final BluetoothDevice device;
  Connected({
    required this.device,
  });
}

abstract class AttempFailed extends DeviceConnectionState {
  final BluetoothDevice device;
  final String errorMessage;
  AttempFailed({
    required this.device,
    required this.errorMessage,
  });
}
