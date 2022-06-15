import 'package:bluetooth_repository/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_bluetooth_iot_app/logic/bluetooth/device_operations/device_connection_cubit.dart';
import 'package:wifi_bluetooth_iot_app/logic/bluetooth/scan_related/scan_cubit.dart';
import 'package:wifi_bluetooth_iot_app/logic/bluetooth/scan_related/scan_results_cubit.dart';
import 'package:wifi_bluetooth_iot_app/ui/screens/find_devices_screen/widgets/widgets.dart';

import '../../../core/constants/strings.dart';

import '../../independent_widgets/custom_app_bar.dart';
import '../../router/app_router.dart';

class FindDevicesScreen extends StatelessWidget {
  const FindDevicesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool scanState = context.watch<ScanCubit>().state;

    return Scaffold(
      appBar: const CustomAppBar(
        title: Strings.homeScreenTitle,
        actions: [],
      ),
      body: Column(
        children: [
          _buildConnectedDevice(context),
          _buildDevices(context, scanState),
        ],
      ),
      floatingActionButton: _buildScanButton(context, scanState),
    );
  }
}

Widget _buildConnectedDevice(BuildContext context) {
  final connectionCubit = context.read<DeviceConnectionCubit>();

  return BlocBuilder<DeviceConnectionCubit, DeviceConnectionState>(
    builder: (context, state) {
      if (state is Connected) {
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 8,
          margin: const EdgeInsets.only(left: 7, top: 6, bottom: 12, right: 7),
          child: Column(
            children: [
              ListTile(
                title: Text(state.device.name),
                subtitle: Text(state.device.id.id),
                trailing: const Icon(Icons.bluetooth_connected),
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                alignment: Alignment.centerLeft,
                child: const Text("Connected device"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () => AppRouter.pushWithArgument(
                          context: context,
                          pageName: AppRouter.deviceScreen,
                          args: DeviceScreenArgs(device: state.device)),
                      child: const Text("Go to device")),
                  TextButton(
                      onPressed: () => connectionCubit.disconnectDevice(state.device),
                      child: const Text(
                        "Disconnect",
                        style: TextStyle(color: Colors.redAccent),
                      ))
                ],
              )
            ],
          ),
        );
      } else if (state is TryingToConnect) {
        return Row(
          children: [
            const Text("Trying to connect a device"),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.red)),
                onPressed: () => connectionCubit.disconnectDevice(state.device),
                child: const Text("Cancel"))
          ],
        );
      } else {
        return const SizedBox();
      }
    },
  );
}

Widget _buildDevices(BuildContext context, bool scanState) {
  return BlocBuilder<ScanResultsCubit, List<DeviceResult>>(builder: (context, state) {
    return state.isEmpty
        ? const Center(
            child: Text("Start a scan!"),
          )
        : Expanded(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                //shrinkWrap: true,
                itemCount: state.length,
                itemBuilder: (ctx, index) {
                  final result = state[index];

                  return CustomListItem(
                      device: result.device,
                      rssi: result.rssi,
                      onTapHandle: scanState == false
                          ? () {
                              AppRouter.pushWithArgument(
                                  context: context,
                                  pageName: AppRouter.deviceScreen,
                                  args: DeviceScreenArgs(device: state[index].device));
                            }
                          : () {},
                      leftIcon: Icons.bluetooth_searching_rounded,
                      index: index,
                      rightButton: _buildRightButton(context, scanState));
                }),
          );
  });
}

Widget _buildRightButton(BuildContext context, bool scanState) {
  return scanState == false
      ? const Icon(Icons.arrow_forward_ios)
      : const Text("Scanning");
}

FloatingActionButton _buildScanButton(BuildContext context, bool scanState) {
  return scanState == false
      ? FloatingActionButton(
          child: const Icon(Icons.search),
          backgroundColor: Colors.green,
          onPressed: () => context.read<ScanCubit>().startScan())
      : FloatingActionButton(
          child: const Icon(Icons.stop),
          backgroundColor: Colors.red,
          onPressed: () => context.read<ScanCubit>().stopScan());
}
