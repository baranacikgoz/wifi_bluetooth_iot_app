import 'package:bluetooth_repository/core.dart';
import 'package:flutter/material.dart';

class CustomListItem extends StatelessWidget {
  final BluetoothDevice device;
  final int rssi;
  final Function onTapHandle;
  final IconData leftIcon;
  final int index;
  final Widget rightButton;

  const CustomListItem({
    Key? key,
    required this.device,
    required this.rssi,
    required this.onTapHandle,
    required this.leftIcon,
    required this.index,
    required this.rightButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          onTapHandle();
        },
        child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 8,
            margin: const EdgeInsets.only(left: 7, top: 6, bottom: 6, right: 7),
            child: ListTile(
              leading: Text("rssi: $rssi"),
              minLeadingWidth: 15,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
              title: Column(
                children: [
                  Text(
                    device.name,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    device.id.id,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    device.type.toString(),
                    style: Theme.of(context).textTheme.labelMedium,
                  )
                ],
              ),
              trailing: rightButton,
            )));
  }
}
