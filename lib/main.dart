import 'dart:ui';
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

  // Initialize Hive first (doesn't depend on Firebase)
  await Hive.initFlutter();
  Hive.registerAdapter(ChannelModelAdapter());
  Hive.registerAdapter(CategoryAdapter());
  await Hive.openBox<ChannelModel>('favorites');

  // Initialize Firebase with error handling
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase initialized successfully');
  } catch (e) {
    print('❌ Firebase initialization failed: $e');
    // Continue running even if Firebase fails (for development)
    if (kDebugMode) {
      print('Running without Firebase in debug mode');
    } else {
      // In production, you might want to show an error dialog
      rethrow;
    }
  }

  // Setup crashlytics only if Firebase initialized successfully
  if (Firebase.apps.isNotEmpty) {
    // Pass all uncaught errors to Crashlytics.
    if (!kDebugMode) {
      FlutterError.onError = (FlutterErrorDetails details) {
        final exception = details.exception;

        // Ignore specific known errors
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
  }

  await setupLocator();
  setupDialogUi();
  setupBottomSheetUi();

  try {
    await configureDependencies();
    print('✅ Dependencies configured successfully');
    print(
        'IsRegistered ChannelRepository: ${locator.isRegistered<ChannelRepository>()}');
  } catch (e, stack) {
    print('❌ configureDependencies FAILED: $e');
    print(stack);
  }

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
          title: 'Mero TV',
          initialRoute: Routes.startupView,
          onGenerateRoute: StackedRouter().onGenerateRoute,
          navigatorKey: StackedService.navigatorKey,
          navigatorObservers: [StackedService.routeObserver],
          builder: (context, child) {
            // Add a wrapper to show Firebase connection status in debug
            if (kDebugMode && Firebase.apps.isEmpty) {
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.warning_amber_rounded,
                          size: 64, color: Colors.orange),
                      const SizedBox(height: 16),
                      const Text(
                        'Firebase Not Connected',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Running in offline mode',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          // Retry Firebase initialization
                          // You might want to implement retry logic here
                        },
                        child: const Text('Retry Connection'),
                      ),
                    ],
                  ),
                ),
              );
            }
            return child!;
          },
        );
      },
    );
  }
}
