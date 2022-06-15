import 'dart:async';

import 'package:bluetooth_repository/src/models/models.dart';
import 'package:flutter_blue/flutter_blue.dart';

export 'package:flutter_blue/flutter_blue.dart';

enum BluetoothStatus { off, on, unknown }

class StartScanFailed implements Exception {
  final String message;

  const StartScanFailed({
    required this.message,
  });
}

BluetoothStatus deserializeBluetoothState(BluetoothState bluetoothState) {
  if (bluetoothState == BluetoothState.on) {
    return BluetoothStatus.on;
  } else {
    return BluetoothStatus.off;
  }
}

class BluetoothRepository {
  BluetoothRepository._();

  static final instance = BluetoothRepository._();

  final _flutterBlueInstance = FlutterBlue.instance;

  Stream<BluetoothStatus> get status {
    return _flutterBlueInstance.state.map(deserializeBluetoothState);
  }

  Future<dynamic> startScan({required Duration duration}) async {
    return _flutterBlueInstance.startScan(timeout: duration);
    //.timeout(const Duration(seconds: 2), onTimeout: throw const StartScanFailed(message: "Timeout error"));
  }

  Stream<List<DeviceResult>> get scanResults {
    return _flutterBlueInstance.scanResults.map((result) {
      final List<DeviceResult> _list = [];

      for (final e in result) {
        final BluetoothDevice _bluetoothDevice = e.device;
        final AdvertisementData _advertisementData = e.advertisementData;

        final _advertisementValues = AdvertisementValues(
          localName: _advertisementData.localName,
          connectable: _advertisementData.connectable,
          manufacturerData: _advertisementData.manufacturerData,
          serviceData: _advertisementData.serviceData,
          serviceUuids: _advertisementData.serviceUuids,
        );

        _list.add(
          DeviceResult(
            device: _bluetoothDevice,
            advertisementValues: _advertisementValues,
            rssi: e.rssi,
          ),
        );
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
