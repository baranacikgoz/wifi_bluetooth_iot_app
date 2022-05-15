import 'dart:async';

import 'package:bluetooth_repository/src/models/models.dart';
import 'package:flutter_blue/flutter_blue.dart';

export 'package:flutter_blue/flutter_blue.dart';

enum BluetoothStatus { OFF, ON, UNKNOWN }

class StartScanFailed implements Exception {
  final String message;

  const StartScanFailed({
    required this.message,
  });
}

BluetoothStatus deserializeBluetoothState(BluetoothState bluetoothState) {
  switch (bluetoothState) {
    case BluetoothState.on:
      return BluetoothStatus.ON;

    case BluetoothState.off:
      return BluetoothStatus.OFF;

    default:
      return BluetoothStatus.UNKNOWN;
  }
}

class BluetoothRepository {
  final _flutterBlueInstance = FlutterBlue.instance;

  Stream<BluetoothStatus> get status {
    return _flutterBlueInstance.state.map((bluetoothState) {
      return deserializeBluetoothState(bluetoothState);
    });
  }

  Future<dynamic> startScan({required Duration duration}) async {
    return _flutterBlueInstance.startScan(timeout: duration);
    //.timeout(const Duration(seconds: 2), onTimeout: throw const StartScanFailed(message: "Timeout error"));
  }

  Stream<List<DeviceResult>> get scanResults {
    return _flutterBlueInstance.scanResults.map((result) {
      List<DeviceResult> _list = [];

      for (var e in result) {
        final BluetoothDevice _bluetoothDevice = e.device;
        final AdvertisementData _advertisementData = e.advertisementData;

        final _advertisementValues = AdvertisementValues(
            localName: _advertisementData.localName,
            connectable: _advertisementData.connectable,
            manufacturerData: _advertisementData.manufacturerData,
            serviceData: _advertisementData.serviceData,
            serviceUuids: _advertisementData.serviceUuids);

        _list.add(DeviceResult(device: _bluetoothDevice, advertisementValues: _advertisementValues, rssi: e.rssi));
      }

      return _list;
    });
  }

  Stream<bool> isScanning() {
    return _flutterBlueInstance.isScanning;
  }

  Future<dynamic> stopScan() {
    return _flutterBlueInstance.stopScan();
  }
}
