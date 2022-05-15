import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../scan_related/scan_results_cubit.dart';

class DeviceServiceCubit extends Cubit<ServiceState> {
  final ScanResultsCubit scanResultsCubit;
  late final StreamSubscription scanResultsSubsription;

  DeviceServiceCubit({required this.scanResultsCubit}) : super(NotDiscoveringInitial()) {
    monitorScanResults();
  }

  StreamSubscription monitorScanResults() {
    return scanResultsSubsription = scanResultsCubit.stream.listen((scanResult) {});
  }
}

abstract class ServiceState {}

class NotDiscoveringInitial extends ServiceState {}

class TryingDiscoverServices extends ServiceState {}

class DiscoveredServices extends ServiceState {}

class DiscoverServicesFailed extends ServiceState {}
