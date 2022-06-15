import 'package:wifi_bluetooth_iot_app/core/constants/strings.dart';
import 'package:wifi_bluetooth_iot_app/logic/bluetooth/device_operations/device_connection_cubit.dart';
import 'package:wifi_bluetooth_iot_app/ui/independent_widgets/custom_app_bar.dart';
import 'package:bluetooth_repository/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../router/app_router.dart';

class DeviceScreen extends StatelessWidget {
  final DeviceScreenArgs args;

  const DeviceScreen({
    Key? key,
    required this.args,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final device = args.device;

    return Scaffold(
      appBar: const CustomAppBar(title: Strings.deviceScreenTitle, actions: []),
      body: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 8,
            margin: const EdgeInsets.only(left: 7, top: 6, bottom: 12, right: 7),
            child: _buildBody(context, device),
          )
        ],
      ),
    );
  }
}

Widget _buildBody(BuildContext context, BluetoothDevice _device) {
  return BlocBuilder<DeviceConnectionCubit, DeviceConnectionState>(
    builder: (context, state) {
      if (state is TryingToConnect) {
        return _buildTryingToConnectView(context, _device);
      } else if (state is Connected && state.device == _device) {
        return _deviceConnectedView(context, _device);
      } else if (state is Connected && state.device != _device) {
        return _connectedToAnotherDeviceView(context, _device, state.device);
      } else {
        return _buildNotConnectedView(context, _device);
      }
    },
  );
}

Column _buildNotConnectedView(BuildContext context, BluetoothDevice _device) {
  final String _name = _device.name;
  final String _id = _device.id.id;
  return Column(
    children: [
      ListTile(
        title: Text(_name),
        subtitle: Text(_id),
        leading: const Icon(Icons.bluetooth_disabled),
      ),
      Container(
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.centerLeft,
          child: const Text("Not connected")),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
              onPressed: () =>
                  context.read<DeviceConnectionCubit>().connectDevice(_device),
              child: const Text(
                "Connect",
                style: TextStyle(color: Colors.redAccent),
              ))
        ],
      )
    ],
  );
}

Column _deviceConnectedView(BuildContext context, BluetoothDevice _device) {
  final String _name = _device.name;
  final String _id = _device.id.id;
  return Column(
    children: [
      ListTile(
        title: Text(_name),
        subtitle: Text(_id),
        leading: const Icon(Icons.bluetooth_connected),
      ),
      Container(
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.centerLeft,
          child: const Text("Connected to this device")),
      TextButton(
          onPressed: () =>
              context.read<DeviceConnectionCubit>().disconnectDevice(_device),
          child: const Text(
            "Disconnect",
            style: TextStyle(color: Colors.redAccent),
          ))
    ],
  );
}

Column _connectedToAnotherDeviceView(BuildContext context, BluetoothDevice _thisDevice,
    BluetoothDevice otherDeviceThatConnected) {
  final String _name = _thisDevice.name;
  final String _id = _thisDevice.id.id;
  return Column(
    children: [
      ListTile(
        title: Text(_name),
        subtitle: Text(_id),
        leading: const Icon(Icons.perm_device_information_outlined),
      ),
      Container(
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.centerLeft,
          child: const Text("Connected to another device")),
      Column(
        children: [
          TextButton(
              onPressed: () => AppRouter.pushWithArgument(
                  context: context,
                  pageName: AppRouter.deviceScreen,
                  args: DeviceScreenArgs(device: otherDeviceThatConnected)),
              child: const Expanded(child: Text("Go to the connected device"))),
          TextButton(
              onPressed: () => context
                  .read<DeviceConnectionCubit>()
                  .disconnectDevice(otherDeviceThatConnected),
              child: const Expanded(
                child: Text(
                  "Disconnect the connected device",
                  style: TextStyle(color: Colors.redAccent),
                ),
              ))
        ],
      )
    ],
  );
}

Column _buildTryingToConnectView(BuildContext context, BluetoothDevice _device) {
  final String _name = _device.name;
  final String _id = _device.id.id;
  return Column(
    children: [
      ListTile(
        title: Text(_name),
        subtitle: Text(_id),
        leading: const CircularProgressIndicator(),
      ),
      Container(
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.centerLeft,
          child: const Text("Trying to connect..")),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
              onPressed: () =>
                  context.read<DeviceConnectionCubit>().disconnectDevice(_device),
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.redAccent),
              ))
        ],
      )
    ],
  );
}
