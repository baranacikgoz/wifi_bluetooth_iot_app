import 'package:bluetooth_repository/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_bluetooth_iot_app/core/themes/app_theme.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:wifi_bluetooth_iot_app/logic/bluetooth/device_operations/device_connection_cubit.dart';
import 'package:wifi_bluetooth_iot_app/logic/bluetooth/scan_related/scan_cubit.dart';
import 'package:wifi_bluetooth_iot_app/logic/bluetooth/scan_related/scan_results_cubit.dart';
import 'package:wifi_bluetooth_iot_app/ui/independent_widgets/custom_snackbar.dart';
import 'package:wifi_bluetooth_iot_app/ui/router/app_router.dart';
import 'package:path_provider/path_provider.dart';

import 'core/constants/strings.dart';
import 'core/debug/app_bloc_observer.dart';
import 'core/instances.dart';
import 'logic/bluetooth/bluetooth_status_cubit.dart';
import 'logic/switch_theme/cubit/switch_theme_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );

  HydratedBlocOverrides.runZoned(() => runApp(App()),
      storage: storage, blocObserver: AppBlocObserver());
}

class App extends StatelessWidget {
  final osThemeIsLight =
      schedularBindingInstance.window.platformBrightness == Brightness.light;

  App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => BluetoothStatusCubit()),
          BlocProvider(create: (context) => ScanCubit()),
          BlocProvider(create: (context) => ScanResultsCubit()),
          BlocProvider(
              create: (context) => DeviceConnectionCubit(
                  scanResultsCubit: context.read<ScanResultsCubit>())),

          // If Android/IOS theme of the device is light, start app with light theme,
          // else start app with dark theme
          osThemeIsLight
              ? BlocProvider(
                  create: (context) =>
                      SwitchThemeCubit(initialTheme: AppTheme.lightTheme))
              : BlocProvider(
                  create: (context) => SwitchThemeCubit(initialTheme: AppTheme.darkTheme))
        ],
        child: Builder(builder: (context) {
          return MultiBlocListener(
            listeners: [
              BlocListener<BluetoothStatusCubit, BluetoothStatus>(
                //listenWhen: (previous, current) => previous != current,
                listener: (context, state) {
                  if (state != BluetoothState.on) {
                    //! onBluetoothOff
                  } else {
                    //! onBluetoothOn
                  }
                },
              ),
              BlocListener<DeviceConnectionCubit, DeviceConnectionState>(
                listener: (context, state) {
                  if (state is AttempFailed) {
                    CustomSnackbar.showSnackbarWithTimedMessage(
                        context: context, message: "Failed: ${state.errorMessage}");
                  }
                },
              ),
              BlocListener<ScanCubit, bool>(
                listener: (context, state) {
                  // TODO: implement listener
                },
              )
            ],
            child: Builder(builder: (context) {
              return MaterialApp(
                title: Strings.appTitle,
                theme: BlocProvider.of<SwitchThemeCubit>(context, listen: true).state,
                debugShowCheckedModeBanner: false,
                //initialRoute: AppRouter.findDevicesScreen,
                onGenerateRoute: AppRouter.onGenerateRoute,
              );
            }),
          );
        }));
  }
}
