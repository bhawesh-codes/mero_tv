// main.dart
import 'dart:ui';
import 'package:mero_tv/models/channel_model.dart';
import 'package:mero_tv/repository/channel_repository.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:media_kit/media_kit.dart';
import 'package:mero_tv/app/app.bottomsheets.dart';
import 'package:mero_tv/app/app.dialogs.dart';
import 'package:mero_tv/app/app.locator.dart';
import 'package:mero_tv/app/app.router.dart';
import 'package:mero_tv/services/get_it_service.dart';
import 'package:stacked_services/stacked_services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔹 Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 🔹 Disable Crashlytics in debug/test mode
  if (!kDebugMode) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  MediaKit.ensureInitialized();

  // 🔹 Setup locator only if not already set up
  await setupLocator();
  setupDialogUi();
  setupBottomSheetUi();
  try {
    await configureDependencies();
    print('Dependencies configured successfully');
    print(
        'IsRegistered ChannelRepository: ${locator.isRegistered<ChannelRepository>()}');
  } catch (e, stack) {
    print('configureDependencies FAILED: $e');
    print(stack);
  }
  // 🔹 Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(ChannelModelAdapter());
  Hive.registerAdapter(CategoryAdapter()); 
  await Hive.openBox<ChannelModel>('favorites');

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: Routes.startupView,
            onGenerateRoute: StackedRouter().onGenerateRoute,
            navigatorKey: StackedService.navigatorKey,
            navigatorObservers: [StackedService.routeObserver],
          );
        });
  }
}
