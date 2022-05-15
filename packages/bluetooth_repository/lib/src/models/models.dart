import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_blue/flutter_blue.dart';

class AdvertisementValues extends Equatable {
  final String localName;
  final int? txPowerLevel;
  final bool connectable;
  final Map<int, List<int>> manufacturerData;
  final Map<String, List<int>> serviceData;
  final List<String> serviceUuids;

  const AdvertisementValues({
    required this.localName,
    this.txPowerLevel,
    required this.connectable,
    required this.manufacturerData,
    required this.serviceData,
    required this.serviceUuids,
  });

  Map<String, dynamic> toMap() {
    return {
      'localName': localName,
      'txPowerLevel': txPowerLevel,
      'connectable': connectable,
      'manufacturerData': manufacturerData,
      'serviceData': serviceData,
      'serviceUuids': serviceUuids,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  List<Object?> get props => [localName, txPowerLevel, connectable, manufacturerData, serviceData, serviceUuids];
}

class DeviceResult extends Equatable {
  final BluetoothDevice device;
  final AdvertisementValues advertisementValues;
  final int rssi;

  const DeviceResult({
    required this.device,
    required this.advertisementValues,
    required this.rssi,
  });

  @override
  List<Object?> get props => [device, advertisementValues];
}
