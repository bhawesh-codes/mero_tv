import 'dart:ui';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/services.dart';
import 'package:mero_tv/models/channel_model.dart';
import 'package:mero_tv/repository/channel_repository.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mero_tv/app/app.bottomsheets.dart';
import 'package:mero_tv/app/app.dialogs.dart';
import 'package:mero_tv/app/app.locator.dart';
import 'package:mero_tv/app/app.router.dart';
import 'package:mero_tv/services/get_it_service.dart';
import 'package:stacked_services/stacked_services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('✅ Firebase initialized successfully');
  } catch (e) {
    debugPrint('❌ Firebase initialization failed: $e');
  }

  try {
    await Hive.initFlutter();
    debugPrint('✅ Hive initialized successfully');

    Hive.registerAdapter(ChannelModelAdapter());
    Hive.registerAdapter(CategoryAdapter());

    // ✅ Schema version check - FIXES YOUR CRASH
    const currentVersion = 2;
    final versionBox = await Hive.openBox('app_version');
    final savedVersion =
        versionBox.get('channel_model_version', defaultValue: 0);

    if (savedVersion < currentVersion) {
      debugPrint('⚠️ Schema version mismatch. Clearing old favorites data...');

      // Safely delete old box if it exists
      if (await Hive.boxExists('favorites')) {
        await Hive.deleteBoxFromDisk('favorites');
        debugPrint('✅ Old favorites box deleted');
      }

      await versionBox.put('channel_model_version', currentVersion);
    }
    await versionBox.close();

    // Open favorite box (creates new if deleted)
    final box = await Hive.openBox<ChannelModel>('favorites');
    debugPrint('✅ Hive boxes opened successfully ${box.isOpen}');
    box.isEmpty; // Verify box is readable
  } catch (e) {
    debugPrint('❌ Hive initialization failed: $e');
    // Last resort recovery
    try {
      await Hive.deleteBoxFromDisk('favorites');
      await Hive.openBox<ChannelModel>('favorites');
      debugPrint('✅ Recovered from Hive error');
    } catch (recoveryError) {
      debugPrint('❌ Recovery failed: $recoveryError');
    }
  }

  // Setup crashlytics only if Firebase initialized successfully
  if (Firebase.apps.isNotEmpty && !kDebugMode) {
    FlutterError.onError = (FlutterErrorDetails details) {
      final exception = details.exception;

      if (exception is RangeError &&
          exception.message.toString().contains('millisecondsSinceEpoch')) {
        debugPrint('Caught flutter timestamp overflow (ignored): $exception');
        return;
      }
      if (exception is PlatformException && exception.code == 'VideoError') {
        debugPrint('Caught VideoError: ${exception.message}');
        return;
      }

      FirebaseCrashlytics.instance.recordFlutterError(details);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      if (error is RangeError &&
          error.message.toString().contains('millisecondsSinceEpoch')) {
        debugPrint('Caught stream timestamp overflow (ignored): $error');
        return true;
      }
      if (error is PlatformException && error.code == 'VideoError') {
        debugPrint('Caught async VideoError: ${error.message}');
        return true;
      }

      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  // Setup locators and dependencies
  await setupLocator();
  setupDialogUi();
  setupBottomSheetUi();

  try {
    await configureDependencies();
    debugPrint('✅ Dependencies configured successfully');
    debugPrint(
        'IsRegistered ChannelRepository: ${locator.isRegistered<ChannelRepository>()}');
  } catch (e, stack) {
    debugPrint('❌ configureDependencies FAILED: $e');
    debugPrint(stack.toString());
  }

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MainApp(),
    ),
  );
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
          locale: DevicePreview.locale(context),
          builder: DevicePreview.appBuilder,
          debugShowCheckedModeBanner: false,
          title: 'Mero TV',
          initialRoute: Routes.startupView,
          onGenerateRoute: StackedRouter().onGenerateRoute,
          navigatorKey: StackedService.navigatorKey,
          navigatorObservers: [StackedService.routeObserver],
        );
      },
    );
  }
}
