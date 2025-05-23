import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'firebase_options.dart';
import 'core/app_export.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'presentation/statistics_mood_charts_screen/statisticsmood_tab_page.dart';
import 'presentation/sign_up_step_two_screen/provider/sign_up_step_two_provider.dart';
import 'package:provider/provider.dart';
import 'core/utils/url_handler.dart';
import 'core/utils/size_utils.dart';
import 'presentation/spotify_screen/provider/spotify_provider.dart';
import 'presentation/sign_up_step_four_screen/provider/sign_up_step_four_provider.dart';
import 'presentation/welcome_screen/welcome_screen.dart';
import 'core/utils/root_bundle_asset_loader.dart';
import 'services/auth_service.dart';
import 'services/auth_persistence_service.dart';
import 'presentation/homescreen_screen/homescreen_screen.dart';
import 'core/services/storage_service.dart';
import 'providers/user_provider.dart';
import 'services/notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'presentation/pin_verification_screen/pin_verification_screen.dart';
import 'providers/accessibility_provider.dart';
import 'widgets/text_scaling_wrapper.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> globalMessengerKey = GlobalKey<ScaffoldMessengerState>();

/// This is the main entry point of the application.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await EasyLocalization.ensureInitialized();
  await StorageService.init();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Initialize URL handler before running the app
  UrlHandler.init();

  // Check for saved credentials and attempt auto-login
  final savedCredentials = await AuthPersistenceService.getSavedCredentials();
  final authService = AuthService();
  bool isAuthenticated = false;

  if (savedCredentials != null) {
    try {
      final user = await authService.signInWithEmailAndPassword(
        savedCredentials['email']!,
        savedCredentials['password']!,
      );
      isAuthenticated = user != null;
    } catch (e) {
      // If auto-login fails, clear saved credentials
      await AuthPersistenceService.clearSavedCredentials();
    }
  }

  // Check if PIN is enabled
  bool shouldShowPinVerification = false;
  if (isAuthenticated) {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(savedCredentials?['email'])
          .get();
      shouldShowPinVerification = userDoc.exists && userDoc.data()?['pinEnabled'] == true;
    } catch (e) {
      print('Error checking PIN status: $e');
    }
  }

  // Initialize notification service
  try {
    await NotificationService().initialize();
    print('Notification service initialized successfully');
  } catch (e) {
    print('Error initializing notification service: $e');
  }

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en')],
      path: 'lib/localization',
      assetLoader: CustomRootBundleAssetLoader(),
      fallbackLocale: const Locale('en'),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SpotifyProvider()),
          ChangeNotifierProvider(
            create: (_) => UserProvider(),
            lazy: false,
          ),
          ChangeNotifierProvider(
            create: (_) => AccessibilityProvider(),
            lazy: false,
          ),
        ],
        child: ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp(
              theme: ThemeData(
                visualDensity: VisualDensity.standard,
                useMaterial3: true,
              ),
              title: 'MoodFlow',
              navigatorKey: rootNavigatorKey,
              debugShowCheckedModeBanner: false,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              builder: (context, child) {
                SizeUtils.init(context);
                final isInverted = context.watch<AccessibilityProvider>().isInverted;
                return TextScalingWrapper(
                  child: ColorFiltered(
                    colorFilter: isInverted
                        ? const ColorFilter.matrix([
                            -1, 0, 0, 0, 255,
                            0, -1, 0, 0, 255,
                            0, 0, -1, 0, 255,
                            0, 0, 0, 1, 0,
                          ])
                        : const ColorFilter.mode(
                            Colors.transparent,
                            BlendMode.dst,
                          ),
                    child: child!,
                  ),
                );
              },
              initialRoute: isAuthenticated 
                ? (shouldShowPinVerification ? AppRoutes.pinVerificationScreen : AppRoutes.homescreenScreen)
                : AppRoutes.welcomeScreen,
              routes: AppRoutes.routes,
              onGenerateRoute: AppRoutes.onGenerateRoute,
              home: isAuthenticated 
                ? (shouldShowPinVerification ? PinVerificationScreen.builder(context) : HomescreenScreen.builder(context))
                : WelcomeScreen.builder(context),
            );
          },
          child: isAuthenticated ? const HomescreenScreen() : const WelcomeScreen(),
        ),
      ),
    ),
  );
}

Future<void> _requestContactPermission() async {
  final status = await Permission.contacts.request();
  if (status.isDenied) {
    print('Contact permission denied');
  } else if (status.isGranted) {
    print('Contact permission granted');
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) => MaterialApp(
        theme: theme,
        title: 'MoodFlow',
        debugShowCheckedModeBanner: false,
        navigatorKey: rootNavigatorKey,
        scaffoldMessengerKey: globalMessengerKey,
        builder: (context, child) {
          SizeUtils.init(context);
          if (rootNavigatorKey.currentState == null) {
            debugPrint('=== Navigator key not initialized ===');
          } else {
            debugPrint('=== Navigator key initialized successfully ===');
          }
          return child!;
        },
        initialRoute: AppRoutes.welcomeScreen,
        routes: AppRoutes.routes,
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }
}
