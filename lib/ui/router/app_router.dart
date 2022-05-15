import 'package:flutter/material.dart';

import '../../core/constants/strings.dart';
import '../screens/device_screen/device_screen.dart';
import '../screens/find_devices_screen/find_devices_screen.dart';

import "package:flutter_blue/flutter_blue.dart";

part 'screen_args.dart';

class AppRouter {
  static const String findDevicesScreen = '/';
  static const String deviceScreen = '/device-screen';

  const AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case findDevicesScreen:
        return MaterialPageRoute(builder: (_) => const FindDevicesScreen());

      case deviceScreen:
        return MaterialPageRoute(builder: (_) => DeviceScreen(args: settings.arguments as DeviceScreenArgs));

      default:
        throw Exception(Strings.routeExceptionMessage);
    }
  }

  //! Custom navigaton methods. If you want to change the way of navigating,
  //! you don't have to change it from everywhere, just change inside the functions

  //! Removes all screens and then pushes the screen
  static pushNamedAndRemoveUntil({
    required BuildContext context,
    required String pageName,
  }) {
    // If navigator can remove current screen, removes it
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        pageName,
        (route) => false, // false --> remove all screens
      );
    } else {
      // left no screen to remove, therefore pushes the given screen
      push(context: context, pageName: pageName);
    }

    Navigator.of(context).pushNamedAndRemoveUntil(pageName, (route) => false);
  }

  //! Removes all screens and then pushes the screen with arguments
  static pushNamedAndRemoveUntilWithArguments(
      {required BuildContext context, required String pageName, required Object args}) {
    // If navigator can remove current screen, removes it
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        pageName,
        (route) => false,
        arguments: args,
      );
    } else {
      // left no screen to remove, then push the given screen
      push(context: context, pageName: pageName);
    }
  }

  //! Pushes given page
  static push({required BuildContext context, required String pageName}) {
    Navigator.of(context).pushNamed(pageName);
  }

  //! Pushes given page with arguments
  static pushWithArgument({required BuildContext context, required String pageName, required args}) {
    Navigator.of(context).pushNamed(pageName, arguments: args);
  }
}
